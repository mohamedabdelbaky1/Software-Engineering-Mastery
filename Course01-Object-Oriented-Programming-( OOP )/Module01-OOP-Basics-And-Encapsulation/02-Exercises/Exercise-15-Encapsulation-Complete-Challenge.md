

# 🧩 Exercise 15 — Encapsulation Complete Challenge

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🔴 Senior Beginner / Junior Professional
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Full encapsulation
* Domain modeling
* Private state
* Public behavior
* Object invariants
* Controlled state changes
* Collection protection
* Immutable value objects

---

# Why This Matters

Weak OOP design:

```text id="c4q3i1"
Public Data
+
External Logic
+
Random Changes
```

Professional OOP design:

```text id="v0wr0g"
Private State

+

Meaningful Behavior

+

Protected Rules
```

The object becomes responsible for keeping itself correct.

---

# 🏢 Real-World Scenario

# E-Commerce Order Domain

You are building the order module of a large e-commerce platform.

An order is not just:

```text id="5j2o2r"
OrderId
Items
Price
Status
```

It has rules and behavior.

---

# Order Lifecycle

```text id="3m9w0z"
Created

   ↓

Confirmed

   ↓

Paid

   ↓

Shipped

   ↓

Completed
```

Possible cancellation:

```text id="7sg2u8"
Created
Confirmed
Paid

        ↓

    Cancelled
```

---

# 📌 Requirements

Create a complete order domain model.

---

# Order State

The order contains:

```text id="6w5y5q"
Order Id

Customer Name

Items

Status

Payment Status
```

---

# Business Rules

The object must guarantee:

---

## Order Creation

```text id="0h0mvv"
Order must have customer name.

Order cannot be created without items.

Order starts as Created.
```

---

## Items

```text id="6e1f8y"
Cannot add null items.

Cannot modify items externally.

Cannot add items after payment.
```

---

## Payment

```text id="m7u8f5"
Only confirmed orders can be paid.

Paid orders cannot be modified.
```

---

## Shipping

```text id="8d90g5"
Only paid orders can ship.
```

---

## Cancellation

```text id="v8sp3r"
Cannot cancel shipped orders.

Cannot cancel completed orders.
```

---

# 🧠 Engineering Focus

## Question 1

### Who Owns Order Rules?

Bad:

```text id="1p3gqn"
OrderService

Controller

UI
```

Everywhere.

---

Better:

```text id="0x4y8g"
Order
```

because:

```text id="l7z4j0"
Order owns order state.
```

---

# Question 2

## Should Items Be Public?

Bad:

```csharp id="8e9y0j"
order.Items.Add(item);
```

Now someone can bypass:

* Payment rules.
* Validation.
* Business logic.

---

# Question 3

## Should Status Be Editable?

Bad:

```csharp id="5xjv9r"
order.Status = OrderStatus.Shipped;
```

This skips:

```text id="t0y7q3"
Payment verification

Shipping rules
```

---

# ❌ Bad Design Example

```csharp id="k9zq4h"
public class Order
{
    public int Id;

    public string CustomerName;

    public List<OrderItem> Items;

    public string Status;

    public bool Paid;
}
```

Usage:

```csharp id="q1k8x9"
Order order = new Order();

order.Status = "Shipped";

order.Paid = false;

order.Items.Clear();
```

---

# Why This Is Poor Design

## 1. State Is Exposed

Anyone can modify important information.

---

## 2. Rules Are Bypassed

The system allows:

```text id="y6u4c0"
Unpaid → Shipped
```

---

## 3. Object Has No Responsibility

It becomes:

```text id="3f9vpu"
Data Container
```

---

# ✅ Expected Design Direction

The final design:

```text id="4c1x0w"
Order

Private:

Items
Internal rules


Public:

Confirm()
Pay()
Ship()
Cancel()

Read-only:

Status
Items
```

---

# Design Diagram

```text id="v9u0zk"

             Customer

                |
                ▼

              Order

     -----------------------

     State

     - Status
     - Payment
     - Items


     Behavior

     - Confirm()
     - Pay()
     - Ship()
     - Cancel()


     Rules

     - Valid transitions
     - Validation

```

---

# 💻 Solution

## Enums

```csharp id="i5q8sx"
public enum OrderStatus
{
    Created,
    Confirmed,
    Paid,
    Shipped,
    Completed,
    Cancelled
}
```

---

```csharp id="7v9r1n"
public class OrderItem
{
    public string Name { get; }

    public decimal Price { get; }


    public OrderItem(
        string name,
        decimal price)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name required.");
        }


        if (price < 0)
        {
            throw new ArgumentException(
                "Invalid price.");
        }


        Name = name;
        Price = price;
    }
}
```

---

# Order Class

```csharp id="q3d4z5"
using System;
using System.Collections.Generic;
using System.Linq;


public class Order
{
    private readonly List<OrderItem> items = new();


    public int Id { get; }

    public string CustomerName { get; }

    public OrderStatus Status { get; private set; }

    public IReadOnlyList<OrderItem> Items => items;



    public Order(
        int id,
        string customerName)
    {
        if (string.IsNullOrWhiteSpace(customerName))
        {
            throw new ArgumentException(
                "Customer name required.");
        }


        Id = id;

        CustomerName = customerName;

        Status = OrderStatus.Created;
    }



    public void AddItem(OrderItem item)
    {
        EnsureModificationAllowed();


        if (item == null)
        {
            throw new ArgumentNullException(
                nameof(item));
        }


        items.Add(item);
    }



    public void Confirm()
    {
        if (items.Count == 0)
        {
            throw new InvalidOperationException(
                "Cannot confirm empty order.");
        }


        if (Status != OrderStatus.Created)
        {
            throw new InvalidOperationException(
                "Invalid confirmation.");
        }


        Status = OrderStatus.Confirmed;
    }



    public void Pay()
    {
        if (Status != OrderStatus.Confirmed)
        {
            throw new InvalidOperationException(
                "Only confirmed orders can be paid.");
        }


        Status = OrderStatus.Paid;
    }



    public void Ship()
    {
        if (Status != OrderStatus.Paid)
        {
            throw new InvalidOperationException(
                "Only paid orders can ship.");
        }


        Status = OrderStatus.Shipped;
    }



    public void Cancel()
    {
        if (Status == OrderStatus.Shipped ||
            Status == OrderStatus.Completed)
        {
            throw new InvalidOperationException(
                "Cannot cancel order.");
        }


        Status = OrderStatus.Cancelled;
    }



    private void EnsureModificationAllowed()
    {
        if (Status == OrderStatus.Paid ||
            Status == OrderStatus.Shipped ||
            Status == OrderStatus.Completed)
        {
            throw new InvalidOperationException(
                "Order cannot be modified.");
        }
    }
}
```

---

# 🧪 Test Cases

```csharp id="1h8m3c"
public class Program
{
    public static void Main()
    {
        Order order =
            new Order(
                1001,
                "Mohamed");


        order.AddItem(
            new OrderItem(
                "Laptop",
                1000));


        order.Confirm();


        order.Pay();


        order.Ship();


        Console.WriteLine(
            order.Status);
    }
}
```

---

# Expected Output

```text id="r6m2hv"
Shipped
```

---

# Invalid Scenario

```csharp id="e0b8m4"
order.Ship();

order.AddItem(
    new OrderItem(
        "Mouse",
        50));
```

Result:

```text id="p4s0c9"
Exception

Order cannot be modified.
```

---

# 🔍 Solution Explanation

## Why Is Order State Private?

Because order state has meaning.

Example:

```text id="d6q2z9"
Created → Confirmed
```

is a business operation.

Not:

```csharp id="5s7j2w"
Status = Confirmed;
```

---

## Why Is Items Read-Only?

Because the order controls:

* Validation.
* Modification rules.
* Lifecycle.

---

## Why Does Order Own Its Lifecycle?

Because:

```text id="f4b8w6"
Order knows:

Current state

Allowed transitions

Business rules
```

---

# 💡 Senior Engineer Notes

## Encapsulation Checklist

A well-designed object usually answers:

### State

Who owns it?

---

### Modification

Who can change it?

---

### Rules

Where are they enforced?

---

### Behavior

Who performs the operation?

---

# Common Mistakes

## ❌ Public setters everywhere

```csharp
Status {get;set;}
```

---

## ❌ Service-heavy design

```text
OrderService handles everything
```

---

## ❌ Exposing collections

```csharp
public List<OrderItem>
```

---

## ❌ Objects with no behavior

```text
Only properties
```

---

# 🎤 Interview Connection

## Question 1

### What does encapsulation mean?

Answer:

Encapsulation means hiding internal state and exposing controlled operations that maintain object correctness.

---

## Question 2

### Is making fields private enough?

Answer:

No.

Real encapsulation requires protecting rules and controlling behavior.

---

## Question 3

### Where should business rules live?

Answer:

Close to the state they protect, usually inside the responsible domain object.

---

## Question 4

### What makes an object well encapsulated?

Answer:

* Controlled state.
* Clear responsibilities.
* Valid invariants.
* Meaningful behavior.

---

# 🧠 Engineering Reflection

```text id="r0t3h9"
1. Why should Order control payment?

2. Why should Items not be public?

3. Which invariants does Order protect?

4. What makes this better than a Service class controlling everything?

5. How does this design reduce bugs?
```

---

# 🏁 Key Takeaways

1. Encapsulation is about protecting correctness.
2. Objects should own the rules related to their state.
3. Public APIs should expose intentions, not internal details.
4. State transitions should be explicit.
5. Collections require protection.
6. Good objects prevent misuse.
7. This is the foundation for OOD and SOLID.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 15 of 19 ✅
</p>
```

