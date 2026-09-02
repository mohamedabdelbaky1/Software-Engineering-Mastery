

# 🔧 Refactoring Challenge 09 — Controlled State Transitions

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on an order processing system.

The team created an `Order` class.

The order lifecycle is:

```text
Pending

   ↓

Paid

   ↓

Shipped

   ↓

Delivered
```

However, developers can directly change the order status.

This caused production problems:

* Orders shipped without payment.
* Delivered orders returned to pending.
* Invalid status changes.
* Missing business rules.

Your task:

Refactor the order status management.

---

# 🔴 Original Code

```csharp
public class Order
{
    public int Id { get; set; }


    public string Status { get; set; }


    public decimal Total { get; set; }
}
```

---

# Example Usage

```csharp
Order order =
    new Order();


order.Id = 100;

order.Status = "Pending";

order.Total = 5000;



order.Status = "Delivered";
```

---

# Current Problem

The system now contains:

```text
Order

Status = Delivered
```

But:

* Was it paid?
* Was it shipped?
* Was delivery completed?

Nobody knows.

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Status Is Uncontrolled Data

Current:

```csharp
order.Status = "Delivered";
```

Any code can perform any transition.

---

Example:

```text
Pending

     ↓

Delivered
```

This should not be allowed.

---

# ❌ Problem 2 — String Status Creates Errors

Current:

```csharp
public string Status {get;set;}
```

Allows:

```csharp
order.Status =
    "Deliverd";
```

Typo creates invalid state.

---

# ❌ Problem 3 — No Business Rules

The class does not know:

```text
Can order ship?

Can order be delivered?

Can order be cancelled?
```

---

# ❌ Problem 4 — External Code Controls Lifecycle

Currently:

```text
External Code

      |
      ↓

Changes Order State
```

The order has no authority over itself.

---

# 🧠 Senior Engineer Thinking

A senior developer asks:

---

## Question 1

Who owns order state?

Answer:

```text
Order
```

Because order lifecycle belongs to the order.

---

## Question 2

Is changing status a simple assignment?

No.

Changing:

```text
Pending → Paid
```

is a business operation.

---

## Question 3

What should the public API look like?

Not:

```csharp
order.Status = "Paid";
```

Better:

```csharp
order.Pay();
```

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Replace string status with a controlled type.

---

## Step 2

Remove public state modification.

---

## Step 3

Create meaningful transition methods.

---

## Step 4

Protect invalid transitions.

---

# ✅ Refactored Code

---

# OrderStatus

```csharp
public enum OrderStatus
{
    Pending,

    Paid,

    Shipped,

    Delivered,

    Cancelled
}
```

---

# Order Class

```csharp
using System;


public class Order
{
    public int Id { get; }


    public decimal Total { get; }


    public OrderStatus Status { get; private set; }



    public Order(
        int id,
        decimal total)
    {
        if(total <= 0)
        {
            throw new ArgumentException(
                "Invalid order total.");
        }


        Id = id;

        Total = total;

        Status = OrderStatus.Pending;
    }



    public void Pay()
    {
        if(Status != OrderStatus.Pending)
        {
            throw new InvalidOperationException(
                "Only pending orders can be paid.");
        }


        Status = OrderStatus.Paid;
    }



    public void Ship()
    {
        if(Status != OrderStatus.Paid)
        {
            throw new InvalidOperationException(
                "Only paid orders can be shipped.");
        }


        Status = OrderStatus.Shipped;
    }



    public void Deliver()
    {
        if(Status != OrderStatus.Shipped)
        {
            throw new InvalidOperationException(
                "Only shipped orders can be delivered.");
        }


        Status = OrderStatus.Delivered;
    }



    public void Cancel()
    {
        if(Status == OrderStatus.Delivered)
        {
            throw new InvalidOperationException(
                "Delivered order cannot be cancelled.");
        }


        Status = OrderStatus.Cancelled;
    }
}
```

---

# 🧪 Test Cases

---

## Valid Lifecycle

```csharp
public class Program
{
    public static void Main()
    {
        Order order =
            new Order(
                100,
                5000);



        order.Pay();


        order.Ship();


        order.Deliver();



        Console.WriteLine(
            order.Status);
    }
}
```

---

# Output

```text
Delivered
```

---

# Invalid Transition

```csharp
Order order =
    new Order(
        100,
        5000);


order.Deliver();
```

Result:

```text
Exception:

Only shipped orders can be delivered.
```

---

# Invalid Direct Modification

```csharp
order.Status =
    OrderStatus.Delivered;
```

Compilation Error:

```text
Property 'Status' cannot be assigned
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Order

Status Property

Anyone can change it
```

---

# After

```text
Order

Status

+

Rules

+

Allowed transitions
```

---

# Why Use Methods Instead of Setter?

Before:

```csharp
order.Status = "Delivered";
```

The code only changes data.

It does not explain:

* Why.
* When.
* Whether it is allowed.

---

After:

```csharp
order.Deliver();
```

The object can check:

* Current state.
* Required conditions.
* Business rules.

---

# State Machine Thinking

The object now behaves like a state machine:

```
Pending
   |
   | Pay()
   ↓
Paid
   |
   | Ship()
   ↓
Shipped
   |
   | Deliver()
   ↓
Delivered
```

Only valid paths are allowed.

---

# Benefits

---

## 1. Invalid States Become Harder

Impossible:

```text
Pending → Delivered
```

---

## 2. Rules Have One Owner

Before:

Every service knows order rules.

After:

```text
Order owns lifecycle rules.
```

---

## 3. Code Becomes More Readable

Before:

```csharp
order.Status = "Paid";
```

After:

```csharp
order.Pay();
```

The intention is clear.

---

# 🎤 Interview Discussion

---

## Q1: Why are public setters dangerous for status properties?

### Answer:

Because they allow invalid state transitions without enforcing business rules.

---

## Q2: What is a state transition?

### Answer:

A controlled movement from one valid state to another.

Example:

```
Pending → Paid
```

---

## Q3: Why use methods instead of changing state directly?

### Answer:

Because methods can validate rules before changing state.

---

## Q4: What is an invariant in this example?

### Answer:

Rules that must always remain true.

Examples:

```
Delivered orders cannot be shipped again.

Only paid orders can be shipped.
```

---

# 🧠 Refactoring Checklist

```text
☑ Is important state protected?

☑ Can invalid transitions happen?

☑ Are states represented safely?

☑ Do methods represent business actions?

☑ Does the object own lifecycle rules?
```

---

# 🏁 Key Takeaways

1. State changes are often business operations.
2. Objects should control their own lifecycle.
3. Public setters can create invalid states.
4. Methods express intent better than assignments.
5. Encapsulation protects transitions, not only fields.
6. Good objects make illegal actions difficult.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 09 Completed ✅
</p>

---

