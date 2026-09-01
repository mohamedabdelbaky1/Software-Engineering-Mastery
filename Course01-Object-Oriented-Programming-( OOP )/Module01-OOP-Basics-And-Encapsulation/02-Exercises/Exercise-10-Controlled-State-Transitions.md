

# 🧩 Exercise 10 — Controlled State Transitions

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Professional OOP Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Object lifecycle modeling
* State machines
* Valid state transitions
* Invalid transitions
* Encapsulation of workflows
* Domain behavior
* Preventing illegal operations

---

## Why This Matters

Many real-world objects have a lifecycle.

Examples:

### Order

```text
Created
   ↓
Paid
   ↓
Shipped
   ↓
Delivered
```

---

### Employee

```text
Applied
   ↓
Interviewed
   ↓
Hired
   ↓
Active
```

---

### Payment

```text
Pending
   ↓
Processing
   ↓
Completed
```

---

A weak design allows:

```csharp
order.Status = "Delivered";
```

The system cannot know:

* Was payment completed?
* Was the order shipped?
* Is this transition valid?

Professional objects control their own lifecycle.

---

# 🏢 Real-World Scenario

# Video Streaming Subscription System

You are designing a subscription system for a streaming platform.

A subscription has a lifecycle:

```text
Trial
  |
  ↓
Active
  |
  ↓
Suspended
  |
  ↓
Cancelled
```

---

The business rules:

## Trial

A trial subscription can become:

```text
Trial → Active

Trial → Cancelled
```

---

## Active

An active subscription can become:

```text
Active → Suspended

Active → Cancelled
```

---

## Suspended

A suspended subscription can become:

```text
Suspended → Active

Suspended → Cancelled
```

---

## Cancelled

A cancelled subscription cannot return to any other state.

---

# 📌 Requirements

Create a `Subscription` class.

---

# Subscription State

The object contains:

```text
Id

CustomerName

CurrentStatus

StartDate
```

---

# Subscription Behaviors

---

## Activate

```csharp
Activate()
```

Allowed:

```text
Trial → Active

Suspended → Active
```

---

## Suspend

```csharp
Suspend()
```

Allowed:

```text
Active → Suspended
```

---

## Cancel

```csharp
Cancel()
```

Allowed:

```text
Trial → Cancelled

Active → Cancelled

Suspended → Cancelled
```

---

# 🧠 Engineering Focus

Before coding, think about lifecycle ownership.

---

# Question 1

## Should Status Be Publicly Editable?

Bad:

```csharp
subscription.Status = Active;
```

Problems:

Someone can do:

```text
Cancelled → Active
```

which violates business rules.

---

# Question 2

## Who Owns the Lifecycle Rules?

Possible:

```text
Controller
Service
UI
Database
```

Problem:

Rules become duplicated.

---

Better:

```text
Subscription
```

because:

```text
Subscription owns subscription state.
```

---

# Question 3

## Is Every State Change Valid?

No.

Example:

```text
Cancelled → Active
```

should be impossible.

The object must reject it.

---

# ❌ Bad Design Example

```csharp
public class Subscription
{
    public int Id;

    public string CustomerName;

    public string Status;
}
```

Usage:

```csharp
Subscription subscription =
    new Subscription();


subscription.Status = "Active";

subscription.Status = "Cancelled";

subscription.Status = "Active";
```

---

# Why This Is Poor Design

## 1. Any Transition Is Possible

The object accepts:

```text
Cancelled → Active
```

even if the business forbids it.

---

## 2. Rules Are Outside

Every caller must remember:

```text
Which transitions are allowed?
```

---

## 3. Object Cannot Protect Itself

The object becomes:

```text
Data storage
```

instead of:

```text
Business object
```

---

# ✅ Expected Design Direction

The subscription should control transitions.

---

# State Model

```text

          Activate
    ┌────────────────┐
    │                ▼

  Trial ─────────► Active
    │                 │
    │                 │
    │                 ▼
    │            Suspended
    │                 │
    │                 │
    └─────────────────┘

          Cancel

              ↓

          Cancelled

```

---

# Design Rules

The class should:

* Hide status modification.
* Expose meaningful actions.
* Validate transitions.
* Reject invalid operations.

---

# 💻 Solution

## Subscription Status

```csharp
public enum SubscriptionStatus
{
    Trial,
    Active,
    Suspended,
    Cancelled
}
```

---

## Subscription Class

```csharp
using System;


public class Subscription
{
    public int Id { get; }

    public string CustomerName { get; }

    public SubscriptionStatus Status { get; private set; }


    public DateTime StartDate { get; }


    public Subscription(
        int id,
        string customerName)
    {
        Id = id;

        CustomerName = customerName;

        Status = SubscriptionStatus.Trial;

        StartDate = DateTime.Now;
    }


    public void Activate()
    {
        if (Status != SubscriptionStatus.Trial &&
            Status != SubscriptionStatus.Suspended)
        {
            throw new InvalidOperationException(
                $"Cannot activate subscription from {Status}.");
        }


        Status = SubscriptionStatus.Active;
    }


    public void Suspend()
    {
        if (Status != SubscriptionStatus.Active)
        {
            throw new InvalidOperationException(
                "Only active subscriptions can be suspended.");
        }


        Status = SubscriptionStatus.Suspended;
    }


    public void Cancel()
    {
        if (Status == SubscriptionStatus.Cancelled)
        {
            throw new InvalidOperationException(
                "Subscription already cancelled.");
        }


        Status = SubscriptionStatus.Cancelled;
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
        Subscription subscription =
            new Subscription(
                1001,
                "Mohamed");


        Console.WriteLine(
            subscription.Status);


        subscription.Activate();


        Console.WriteLine(
            subscription.Status);


        subscription.Suspend();


        Console.WriteLine(
            subscription.Status);


        subscription.Cancel();


        Console.WriteLine(
            subscription.Status);
    }
}
```

---

# Expected Output

```text
Trial

Active

Suspended

Cancelled
```

---

# Invalid Transition Test

```csharp
Subscription subscription =
    new Subscription(
        1002,
        "Ahmed");


subscription.Cancel();

subscription.Activate();
```

Expected:

```text
Exception

Cannot activate subscription from Cancelled.
```

---

# 🔍 Solution Explanation

## Why Is Status Private Set?

```csharp
public SubscriptionStatus Status 
{ 
    get; 
    private set; 
}
```

Because changing status is not a simple data update.

It represents a business transition.

---

## Why Use Methods?

Compare:

```csharp
subscription.Status = Active;
```

with:

```csharp
subscription.Activate();
```

The second:

* Expresses intention.
* Validates rules.
* Protects lifecycle.

---

## Why Use Enum Instead of Strings?

Bad:

```csharp
Status = "Active";
```

Problems:

```text
"active"

"ACTIVE"

"Actve"
```

can introduce errors.

Enum provides:

* Type safety.
* Clear allowed values.
* Better readability.

---

# 💡 Senior Engineer Notes

## State Machine Thinking

Many domain objects are state machines.

A state machine has:

```text
Current State

+

Allowed Transitions

+

Rules
```

---

Example:

```text
Current:
Active


Request:
Suspend()


Result:
Suspended
```

---

## Good API Design

Bad:

```csharp
ChangeStatus(Status status)
```

Why?

Because it allows:

```text
Anything → Anything
```

---

Better:

```csharp
Activate()

Suspend()

Cancel()
```

Because each action has meaning.

---

# Common Mistakes

## ❌ Generic Status Setter

```csharp
SetStatus()
```

This removes business meaning.

---

## ❌ Putting Workflow Logic Outside

Example:

```csharp
SubscriptionService.ChangeStatus()
```

with all rules there.

The subscription becomes passive.

---

## ❌ Too Many Boolean Flags

Bad:

```csharp
bool IsActive;

bool IsCancelled;

bool IsSuspended;
```

Possible invalid state:

```text
Active = true

Cancelled = true
```

An enum is usually clearer.

---

# 🎤 Interview Connection

## Question 1

### What is a state transition?

Answer:

A state transition is a controlled change from one valid object state to another.

---

## Question 2

### Why should objects control state transitions?

Answer:

Because objects own their state and should protect business rules that determine which changes are valid.

---

## Question 3

### Why are public status setters dangerous?

Answer:

They allow callers to bypass lifecycle rules and create invalid states.

---

## Question 4

### How would you model an object lifecycle?

Answer:

Using:

* Explicit states
* Controlled methods
* Validation rules
* Encapsulation

---

# 🧠 Engineering Reflection

Answer:

```text
1. Why should Status not be publicly editable?

2. What are the valid transitions?

3. Why is Cancel() better than SetStatus(Cancelled)?

4. What invalid states does this design prevent?

5. When would a state machine become necessary in a real system?
```

---

# 🏁 Key Takeaways

1. Many real objects have lifecycles.
2. Not every state change is valid.
3. Objects should control their own transitions.
4. Methods should represent meaningful domain actions.
5. Enums are safer than arbitrary strings for states.
6. State machines help model complex workflows.
7. Controlled transitions are a core part of professional Encapsulation.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 10 of 19 ✅
</p>
```

