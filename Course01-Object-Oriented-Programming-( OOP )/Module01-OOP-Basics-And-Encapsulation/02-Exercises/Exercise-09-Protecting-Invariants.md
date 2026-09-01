

# 🧩 Exercise 09 — Protecting Invariants

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Professional OOP Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Invariants
* Domain rules
* Protecting object consistency
* Encapsulation
* Controlled mutations
* Valid state transitions
* Avoiding invalid object states

---

## Why This Matters

Many systems fail because they allow objects to enter impossible states.

Example:

```csharp
public class Order
{
    public string Status { get; set; }

    public bool IsPaid { get; set; }
}
```

This allows:

```text
Status = "Shipped"

IsPaid = false
```

But logically:

```text
A shipped order must have payment completed.
```

The object is now inconsistent.

---

Professional developers ask:

> "What conditions must always be true for this object?"

Those conditions are called:

# Invariants

---

# 🏢 Real-World Scenario

# E-Commerce Order Management System

You are designing an order system.

An order has:

* Order ID
* Customer name
* Items
* Payment status
* Order status

---

The business has rules:

## Order Rules

```text
An order must contain at least one item.

A cancelled order cannot be shipped.

A shipped order must be paid.

A completed order cannot be cancelled.

Order total cannot be negative.
```

---

# 📌 Requirements

Create an `Order` class.

---

# Order State

The order contains:

```text
OrderId

CustomerName

Items

Status

IsPaid
```

---

# Order Behaviors

The order should support:

---

## Add Item

```csharp
AddItem(OrderItem item)
```

Rules:

* Item cannot be null.

---

## Pay Order

```csharp
Pay()
```

Rules:

* Order must contain items.

---

## Ship Order

```csharp
Ship()
```

Rules:

* Order must be paid.
* Order cannot already be cancelled.

---

## Cancel Order

```csharp
Cancel()
```

Rules:

* Cannot cancel shipped orders.
* Cannot cancel completed orders.

---

# 🧠 Engineering Focus

Before coding, think about invariants.

---

# Question 1

## What Must Always Be True?

For an order:

```text
Order has items

Paid orders are valid

Shipped orders are paid

Cancelled orders cannot ship
```

These are invariants.

---

# Question 2

## Who Protects These Rules?

Bad design:

```text
Controller checks payment

UI checks items

Service checks status
```

Problem:

Every caller must remember the rules.

---

Better:

```text
Order protects order rules.
```

Because:

```text
Order owns order state.
```

---

# Question 3

## Can Public Setters Protect Invariants?

Example:

```csharp
order.Status = "Shipped";
```

No.

Because this bypasses all rules.

---

# ❌ Bad Design Example

```csharp
public class Order
{
    public int Id;

    public string Status;

    public bool IsPaid;

    public List<OrderItem> Items;
}
```

Usage:

```csharp
Order order = new Order();

order.Status = "Shipped";

order.IsPaid = false;
```

---

# Why This Is Poor Design

## 1. Invalid State Is Allowed

The system accepts:

```text
Shipped order

+
Unpaid status
```

---

## 2. Rules Are Outside The Object

Every developer must know:

```text
When can order ship?

When can order cancel?
```

---

## 3. Future Changes Become Dangerous

Requirement:

```text
Only premium customers can cancel after payment.
```

Where do you change this?

Many places.

---

# ✅ Expected Design Direction

The order should protect itself.

---

# Order Responsibilities

```text
Order

Owns:
- Status
- Payment state
- Items

Protects:
- Valid transitions
- Business rules
```

---

# State Flow

```text
Created
   |
   |
   ▼
Paid
   |
   |
   ▼
Shipped
   |
   |
   ▼
Completed


Created
   |
   |
   ▼
Cancelled
```

Invalid:

```text
Created → Shipped

Unpaid → Shipped

Completed → Cancelled
```

---

# 💻 Solution

## Order Status

```csharp
public enum OrderStatus
{
    Created,
    Paid,
    Shipped,
    Completed,
    Cancelled
}
```

---

## Order Item

```csharp
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
                "Item name required.");
        }


        if (price < 0)
        {
            throw new ArgumentException(
                "Price cannot be negative.");
        }


        Name = name;

        Price = price;
    }
}
```

---

## Order Class

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class Order
{
    private readonly List<OrderItem> items = new();


    public int OrderId { get; }

    public string CustomerName { get; }

    public OrderStatus Status { get; private set; }

    public bool IsPaid { get; private set; }


    public IReadOnlyList<OrderItem> Items => items;


    public decimal Total =>
        items.Sum(item => item.Price);



    public Order(
        int orderId,
        string customerName)
    {
        OrderId = orderId;

        CustomerName = customerName;

        Status = OrderStatus.Created;
    }



    public void AddItem(OrderItem item)
    {
        if (item == null)
        {
            throw new ArgumentNullException(
                nameof(item));
        }


        items.Add(item);
    }



    public void Pay()
    {
        if (items.Count == 0)
        {
            throw new InvalidOperationException(
                "Cannot pay empty order.");
        }


        IsPaid = true;

        Status = OrderStatus.Paid;
    }



    public void Ship()
    {
        if (!IsPaid)
        {
            throw new InvalidOperationException(
                "Order must be paid first.");
        }


        if (Status == OrderStatus.Cancelled)
        {
            throw new InvalidOperationException(
                "Cancelled order cannot ship.");
        }


        Status = OrderStatus.Shipped;
    }



    public void Cancel()
    {
        if (Status == OrderStatus.Shipped ||
            Status == OrderStatus.Completed)
        {
            throw new InvalidOperationException(
                "Cannot cancel this order.");
        }


        Status = OrderStatus.Cancelled;
    }
}
```

---

# 🧪 Test Cases

```csharp
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


        order.Pay();


        order.Ship();


        Console.WriteLine(
            order.Status);
    }
}
```

---

# Expected Output

```text
Shipped
```

---

# Invalid Test Case

Trying to ship before payment:

```csharp
Order order =
    new Order(
        1002,
        "Ahmed");


order.AddItem(
    new OrderItem(
        "Mouse",
        50));


order.Ship();
```

Result:

```text
Exception

Order must be paid first.
```

---

# 🔍 Solution Explanation

## Why Is Status Private Set?

```csharp
public OrderStatus Status { get; private set; }
```

Because status changes have rules.

External code should not do:

```csharp
order.Status = OrderStatus.Shipped;
```

---

## Why Is IsPaid Controlled?

Payment is not just data.

It represents a business event.

Therefore:

```csharp
order.Pay();
```

is better than:

```csharp
order.IsPaid = true;
```

---

## Why Are State Transitions Inside Order?

Because:

```text
Order owns Order lifecycle.
```

The order knows:

* Current status.
* Payment state.
* Allowed transitions.

---

# 💡 Senior Engineer Notes

## Invariant Protection Pattern

A strong object follows:

```text
Receive Request

       ↓

Validate Rule

       ↓

Perform Change

       ↓

Remain Valid
```

---

## Good Objects Reject Invalid Operations

Example:

```text
Cannot ship unpaid order
```

is not an error in your design.

It is a protected rule.

---

## Avoid Boolean Explosion

This design:

```csharp
bool IsPaid;
bool IsCancelled;
bool IsShipped;
```

can create impossible combinations:

```text
Paid = false

Shipped = true

Cancelled = true
```

An enum/state machine is often clearer.

---

# 🎤 Interview Connection

## Question 1

### What is an invariant?

Answer:

An invariant is a condition that must always remain true for an object to stay valid.

---

## Question 2

### Where should business rules live?

Answer:

Usually close to the data they protect, often inside the domain object that owns that state.

---

## Question 3

### Why are public setters dangerous?

Answer:

Because they allow external code to bypass validation and create invalid states.

---

## Question 4

### How do you maintain object consistency?

Answer:

By:

* Constructor validation
* Encapsulation
* Controlled methods
* Valid state transitions

---

# 🧠 Engineering Reflection

Answer:

```text
1. What are the invariants of Order?

2. Why cannot Status be publicly changed?

3. Why is Pay() better than IsPaid = true?

4. What invalid states does this design prevent?

5. How would adding "Refunded" status affect the design?
```

---

# 🏁 Key Takeaways

1. Invariants define what makes an object valid.
2. Objects should protect their own rules.
3. State transitions should happen through meaningful behavior.
4. Public mutation allows invalid states.
5. Enums often model lifecycle states better than multiple booleans.
6. Good encapsulation means preserving correctness, not just hiding fields.
7. Protecting invariants is one of the strongest benefits of OOP.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 09 of 19 ✅
</p>
```

