

# 🧩 Exercise 16 — OOP Code Review Challenge

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🔴 Code Review / Engineering Judgment
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Reviewing existing code
* Identifying OOP violations
* Encapsulation problems
* Responsibility violations
* Poor API design
* Refactoring recommendations

---

# Why This Matters

Professional developers spend a large amount of time reading existing code.

A senior engineer should quickly recognize problems like:

```text id="5x5p2k"
Public mutable state

Classes doing too much

Business logic outside objects

Invalid states possible

Poor abstractions
```

---

# 🏢 Real-World Scenario

## Hotel Booking System

You joined a team maintaining a hotel reservation system.

A junior developer created this implementation:

```csharp id="1n5f2x"
public class Booking
{
    public int Id;

    public string CustomerName;

    public string RoomNumber;

    public string Status;

    public decimal Price;

    public bool Paid;


    public void Save()
    {
        Console.WriteLine("Saving booking...");
    }


    public void SendEmail()
    {
        Console.WriteLine("Sending email...");
    }


    public void Cancel()
    {
        Status = "Cancelled";
    }
}
```

The system works, but the team has maintenance problems.

---

# 📌 Review Requirements

Analyze the code and identify:

1. Encapsulation problems.
2. Responsibility problems.
3. Invalid states.
4. API design issues.
5. Suggested improvements.

---

# 🧠 Engineering Focus

Think like a senior reviewer.

---

# Review Question 1

## Can Booking State Be Modified Freely?

Current:

```csharp id="5y5o0d"
booking.Status = "Cancelled";
```

Problem:

Anyone can change:

```text id="7e6s7m"
Confirmed → Cancelled

Completed → Cancelled

Cancelled → Active
```

without rules.

---

# Review Question 2

## Does Booking Have Too Many Responsibilities?

Current:

```csharp id="w3k9mw"
Save()

SendEmail()

Cancel()
```

Ask:

Does a booking know:

```text id="1l4x9z"
Database operations?

Email system?

Reservation rules?
```

---

Answer:

No.

---

# Review Question 3

## Is Cancel() Enough?

Current:

```csharp id="h8x3gq"
public void Cancel()
{
    Status = "Cancelled";
}
```

Problem:

No validation.

A completed booking can be cancelled.

---

# ❌ Bad Design Analysis

---

## Problem 1 — Public Fields

```csharp id="3g8h6m"
public string Status;
```

### Issue:

External code controls internal state.

Example:

```csharp id="5q2j8x"
booking.Status = "Completed";
```

No rules.

---

## Problem 2 — Missing Constructor

Current:

```csharp id="n9c5q1"
Booking booking = new Booking();
```

Creates:

```text id="k6q9p2"
Empty booking

No customer

No room

No price
```

Invalid object.

---

## Problem 3 — Mixed Responsibilities

The class handles:

```text id="9j5d3w"
Booking domain

+

Database

+

Email
```

Violates responsibility separation.

---

## Problem 4 — String Status

Current:

```csharp id="a7d4p6"
Status = "Confirmed";
```

Possible errors:

```text id="h5w2v9"
confirm

CONFIRMED

Confimed
```

---

## Problem 5 — No Business Rules

Example:

```csharp id="m8p7x3"
booking.Cancel();
```

Allowed anytime.

---

# ✅ Expected Design Direction

A better design:

```text id="2j8r5z"
Booking

Owns:

- Booking state
- Reservation rules
- Lifecycle


BookingRepository

Owns:

- Saving data


NotificationService

Owns:

- Emails
```

---

# Design

```text id="p6n3z0"

             Booking

        -----------------

        State

        - Status
        - Price


        Behavior

        - Confirm()
        - Pay()
        - Cancel()


        Rules

        - Valid transitions

```

---

# 💻 Solution

## Booking Status

```csharp id="s3n9w7"
public enum BookingStatus
{
    Pending,
    Confirmed,
    Paid,
    Cancelled,
    Completed
}
```

---

## Booking Class

```csharp id="v7p2k5"
using System;


public class Booking
{
    public int Id { get; }

    public string CustomerName { get; }

    public string RoomNumber { get; }

    public decimal Price { get; }

    public BookingStatus Status { get; private set; }


    public bool IsPaid { get; private set; }



    public Booking(
        int id,
        string customerName,
        string roomNumber,
        decimal price)
    {
        if (price < 0)
        {
            throw new ArgumentException(
                "Invalid price.");
        }


        Id = id;

        CustomerName = customerName;

        RoomNumber = roomNumber;

        Price = price;

        Status = BookingStatus.Pending;
    }



    public void Confirm()
    {
        if (Status != BookingStatus.Pending)
        {
            throw new InvalidOperationException(
                "Invalid confirmation.");
        }


        Status = BookingStatus.Confirmed;
    }



    public void Pay()
    {
        if (Status != BookingStatus.Confirmed)
        {
            throw new InvalidOperationException(
                "Booking must be confirmed.");
        }


        IsPaid = true;

        Status = BookingStatus.Paid;
    }



    public void Cancel()
    {
        if (Status == BookingStatus.Completed)
        {
            throw new InvalidOperationException(
                "Completed booking cannot be cancelled.");
        }


        Status = BookingStatus.Cancelled;
    }
}
```

---

# Refactoring Comparison

## Before

```text id="7k4m1s"
Booking

- Data
- Database
- Email
- Workflow
```

---

## After

```text id="9x4c2v"
Booking

- State
- Behavior
- Rules
```

---

# 🧪 Test Cases

```csharp id="w8k4p2"
public class Program
{
    public static void Main()
    {
        Booking booking =
            new Booking(
                1,
                "Mohamed",
                "101",
                500);


        booking.Confirm();

        booking.Pay();


        Console.WriteLine(
            booking.Status);
    }
}
```

---

# Expected Output

```text id="0w7m5k"
Paid
```

---

# Invalid Test

```csharp id="n2v5r8"
Booking booking =
    new Booking(
        2,
        "Ahmed",
        "102",
        300);


booking.Cancel();

booking.Pay();
```

Result:

```text id="4y9x1c"
Exception

Booking must be confirmed.
```

---

# 🔍 Code Review Explanation

## Finding #1

### Public Fields

Severity:

🔴 High

Reason:

They allow uncontrolled state modification.

---

## Finding #2

### Multiple Responsibilities

Severity:

🟠 Medium

Reason:

Makes testing and maintenance harder.

---

## Finding #3

### Missing Domain Rules

Severity:

🔴 High

Reason:

Allows invalid business operations.

---

## Finding #4

### Weak State Representation

Severity:

🟡 Medium

Reason:

Strings are error-prone.

---

# 💡 Senior Engineer Notes

During code review, ask:

---

## 1. Can this object become invalid?

If yes:

Add protection.

---

## 2. Who owns this behavior?

If the answer is unclear:

The design probably needs improvement.

---

## 3. Can external code bypass rules?

If yes:

Encapsulation is incomplete.

---

## 4. Does the class have one clear purpose?

If no:

Responsibilities need separation.

---

# 🎤 Interview Connection

## Question 1

### What do you look for during an OOP code review?

Answer:

* Encapsulation issues.
* Responsibility violations.
* Invalid state possibilities.
* Poor abstractions.
* Tight coupling.

---

## Question 2

### How do you identify a God Class?

Answer:

Look for classes that:

* Have many unrelated methods.
* Manage many different concerns.
* Change frequently for different reasons.

---

## Question 3

### Why are public fields considered bad practice?

Answer:

Because they expose implementation details and allow uncontrolled mutation.

---

# 🧠 Engineering Reflection

```text id="m7c9q2"
1. What are the biggest problems in the original code?

2. Which changes improve encapsulation?

3. Why should Save() not exist inside Booking?

4. Why are enums better than status strings?

5. How would you review this code in a real company?
```

---

# 🏁 Key Takeaways

1. Senior engineers evaluate design, not only functionality.
2. Working code can still have poor architecture.
3. Code reviews protect long-term maintainability.
4. Encapsulation prevents misuse.
5. Good classes own their rules and behavior.
6. Refactoring is a core engineering skill.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 16 of 19 ✅
</p>
```

