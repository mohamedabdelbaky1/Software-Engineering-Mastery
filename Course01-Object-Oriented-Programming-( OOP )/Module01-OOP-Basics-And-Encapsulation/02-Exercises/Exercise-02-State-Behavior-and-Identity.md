I will continue with the same FAANG-style documentation approach.

```

This exercise will move from **"How to create objects"** to the core OOP thinking:

> Every object has **State + Behavior + Identity**.

---

# 🧩 Exercise 02 — State, Behavior, and Identity

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟢 Foundation → 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Object State
* Object Behavior
* Object Identity
* Responsibility modeling
* Difference between data and behavior
* Designing objects based on domain concepts

---

## Why This Matters

A common beginner mistake is thinking:

> "A class is just a collection of variables."

Professional OOP thinking is different.

An object is not only data.

An object represents:

```text
Identity
+
State
+
Behavior
```

Understanding this is the foundation for:

* Encapsulation
* Clean Architecture
* Domain Modeling
* Object-Oriented Design

---

# 🏢 Real-World Scenario

## Food Delivery Application

You are designing part of a food delivery system.

The system needs to represent a restaurant order.

An order has:

### State

Information that describes the current condition:

```text
Order Number
Customer Name
Total Amount
Current Status
```

---

### Behavior

Actions the order can perform:

```text
Confirm Order
Cancel Order
Calculate Total
```

---

### Identity

Each order should be distinguishable from another order.

Example:

```text
Order #1001

is different from

Order #1002
```

Even if both have:

```text
Customer = Mohamed
Amount = 200
```

they are still different objects.

---

# 📌 Requirements

Create an `Order` class.

---

## Order State

The order should contain:

```text
Id
CustomerName
TotalAmount
Status
```

---

## Order Behavior

The order should support:

### Confirm

```csharp
Confirm()
```

Changes:

```text
Pending → Confirmed
```

---

### Cancel

```csharp
Cancel()
```

Changes:

```text
Pending → Cancelled
```

---

### Display Information

```csharp
DisplayDetails()
```

Shows:

```text
Order Id
Customer
Amount
Status
```

---

# 🧠 Engineering Focus

Before writing code, answer these questions.

---

## 1. What Is the Object?

Question:

> What real-world thing exists in the system?

Answer:

```text
Order
```

---

## 2. What Is Its State?

Question:

> What information describes the object currently?

Answer:

```text
Id
CustomerName
TotalAmount
Status
```

---

## 3. What Is Its Behavior?

Question:

> What actions does this object own?

Answer:

```text
Confirming
Cancelling
Displaying details
```

---

## 4. Who Owns the Rule?

Example:

Business rule:

```text
Only pending orders can be cancelled.
```

Where should this rule live?

Bad:

```text
OrderService
Controller
UI
```

Better:

```text
Inside Order
```

Because:

```text
Order owns Order status.
```

---

# ❌ Bad Design Example

```csharp
public class Order
{
    public int Id;
    public string CustomerName;
    public decimal TotalAmount;
    public string Status;
}
```

Usage:

```csharp
Order order = new Order();

order.Status = "Confirmed";
```

---

# Why This Is Poor Design

## 1. No Behavior

The class only stores data.

It does not represent what an order can do.

---

## 2. Anyone Can Change State

This is possible:

```csharp
order.Status = "Delivered";
```

even if:

```text
Payment not completed
Restaurant rejected order
```

---

## 3. Business Rules Are Outside

Someone else must remember:

```text
When can order change status?
```

This causes duplicated logic.

---

# ✅ Expected Design Direction

Think about responsibilities.

---

## Class

```text
Order
```

---

## State Ownership

The order owns:

```text
Id
Customer
Amount
Status
```

---

## Behavior Ownership

The order controls:

```text
Confirm()
Cancel()
```

---

## Relationship

```text
Customer
    |
    |
    ▼
  Order
    |
    |
    ▼
 Order Status
```

---

# 💻 Solution

```csharp
using System;

public class Order
{
    public int Id { get; }

    public string CustomerName { get; }

    public decimal TotalAmount { get; }

    public string Status { get; private set; }


    public Order(
        int id,
        string customerName,
        decimal totalAmount)
    {
        Id = id;
        CustomerName = customerName;
        TotalAmount = totalAmount;

        Status = "Pending";
    }


    public void Confirm()
    {
        if (Status != "Pending")
        {
            throw new InvalidOperationException(
                "Only pending orders can be confirmed.");
        }

        Status = "Confirmed";
    }


    public void Cancel()
    {
        if (Status != "Pending")
        {
            throw new InvalidOperationException(
                "Only pending orders can be cancelled.");
        }

        Status = "Cancelled";
    }


    public void DisplayDetails()
    {
        Console.WriteLine($"Order Id: {Id}");
        Console.WriteLine($"Customer: {CustomerName}");
        Console.WriteLine($"Amount: {TotalAmount}");
        Console.WriteLine($"Status: {Status}");
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
                "Mohamed",
                250);


        order.DisplayDetails();


        order.Confirm();


        Console.WriteLine();


        order.DisplayDetails();
    }
}
```

---

## Expected Output

```text
Order Id: 1001
Customer: Mohamed
Amount: 250
Status: Pending


Order Id: 1001
Customer: Mohamed
Amount: 250
Status: Confirmed
```

---

# Invalid Operation Test

```csharp
Order order =
    new Order(
        1002,
        "Ali",
        300);


order.Confirm();

order.Cancel();
```

Expected:

```text
Exception

Only pending orders can be cancelled.
```

---

# 🔍 Solution Explanation

## Why Is Id Read-Only?

```csharp
public int Id { get; }
```

Because identity should not randomly change.

An order created as:

```text
Order #1001
```

should remain:

```text
Order #1001
```

---

## Why Is Status Private Set?

```csharp
public string Status { get; private set; }
```

Because external code should not do:

```csharp
order.Status = "Delivered";
```

The order controls its own transitions.

---

## Why Are Confirm and Cancel Methods?

Because they represent domain behavior.

Compare:

```csharp
order.Status = "Confirmed";
```

with:

```csharp
order.Confirm();
```

The second expresses intent.

---

# 💡 Senior Engineer Notes

## Current Design Demonstrates:

✅ State ownership
✅ Behavior ownership
✅ Identity concept
✅ Basic encapsulation
✅ Controlled transitions

---

## Future Improvements

In production code we may improve:

---

### Replace String Status

Current:

```csharp
string Status
```

Better:

```csharp
OrderStatus enum
```

Example:

```csharp
Pending,
Confirmed,
Cancelled
```

---

### Add Domain Rules

Examples:

```text
Cannot cancel shipped orders.

Cannot confirm cancelled orders.

Amount cannot be negative.
```

---

### Separate Responsibilities

Large systems may introduce:

```text
Order
OrderRepository
PaymentService
NotificationService
```

depending on requirements.

---

# 🎤 Interview Connection

## Question 1

### What are the three characteristics of an object?

Answer:

An object has:

```text
State
Behavior
Identity
```

---

## Question 2

### What is the difference between state and behavior?

Answer:

State represents what an object knows.

Behavior represents what an object can do.

Example:

```text
Order

State:
Status = Pending

Behavior:
Confirm()
Cancel()
```

---

## Question 3

### Why should objects contain behavior instead of only data?

Answer:

Because objects should own the rules that protect their state and maintain valid behavior.

---

## Question 4

### Why is identity important?

Answer:

Two objects may have identical values but still represent different entities.

Example:

```text
Two orders from the same customer
```

are still different orders.

---

# 🧠 Engineering Reflection

Answer before moving forward:

```text
1. Why does Order own Confirm()?

2. Why should external code not directly modify Status?

3. Is CustomerName state or behavior?

4. Why is Order Id immutable?

5. What bugs happen if Status is public?
```

---

# 🏁 Key Takeaways

1. Objects are more than data containers.
2. Every object has:

   * State
   * Behavior
   * Identity
3. State should have a clear owner.
4. Behavior should live close to the data it affects.
5. Objects should protect their own rules.
6. Meaningful methods communicate intent.
7. Identity separates objects even when their data is identical.
8. This thinking prepares us for Encapsulation and Object Design.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 02 of 19 ✅
</p>
```

