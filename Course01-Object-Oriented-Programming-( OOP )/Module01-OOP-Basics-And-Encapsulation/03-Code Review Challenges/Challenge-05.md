

# 🔍 Code Review Challenge 05 — Poor Constructor Design

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟠 Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You are reviewing a hotel reservation system.

The team created a `Reservation` class.

The developer says:

> "The class is flexible because users can create an empty reservation and fill the data later."

However, production bugs started appearing:

* Reservations without customers.
* Invalid dates.
* Negative prices.
* Missing room information.

Your task:

Review the constructor design.

---

# 👀 Code Under Review

```csharp
public class Reservation
{
    public int Id { get; set; }

    public string CustomerName { get; set; }

    public string RoomNumber { get; set; }

    public DateTime CheckIn { get; set; }

    public DateTime CheckOut { get; set; }

    public decimal Price { get; set; }



    public Reservation()
    {

    }
}
```

---

# Example Usage

```csharp
Reservation reservation =
    new Reservation();


reservation.Id = 1;

reservation.CustomerName = "Ahmed";

reservation.Price = -500;

reservation.CheckIn =
    DateTime.Now.AddDays(5);


reservation.CheckOut =
    DateTime.Now;
```

---

# 🔴 Review Findings

---

# Issue 1 — Empty Constructor Creates Invalid Objects

## Problem

The class allows:

```csharp
Reservation reservation =
    new Reservation();
```

At this moment:

```text
CustomerName = null

RoomNumber = null

Price = 0

Dates = default values
```

The object exists but is not meaningful.

---

# Senior Engineer Thinking

Ask:

> Can this object exist in an invalid state?

Yes.

Therefore:

The constructor design is weak.

---

# Issue 2 — Required Data Is Not Enforced

A reservation cannot exist without:

```text
Customer

Room

Dates
```

But the class allows:

```csharp
new Reservation();
```

The responsibility of creating a valid reservation is lost.

---

# Issue 3 — Public Setters Allow Broken State

Current:

```csharp
public decimal Price { get; set; }
```

Allows:

```csharp
reservation.Price = -1000;
```

---

Current:

```csharp
public DateTime CheckOut { get; set; }
```

Allows:

```csharp
CheckIn > CheckOut
```

Example:

```text
Check in:
10 September

Check out:
5 September
```

Impossible reservation.

---

# Issue 4 — Too Much Flexibility

The developer intended:

> "Create first, configure later."

But this creates:

```text
Freedom

+

No Protection
```

Professional objects prefer:

```text
Controlled Creation

+

Valid State
```

---

# 🧠 Senior Engineer Analysis

A senior developer asks:

---

## Question 1

### What should a constructor guarantee?

Answer:

After construction:

```text
The object should be valid.
```

---

## Question 2

### What data is required?

Reservation requires:

```text
Customer

Room

Check-in date

Check-out date

Price
```

---

## Question 3

### Should every property have a setter?

No.

Only data that can legitimately change should be mutable.

---

# ❌ Design Problems Summary

| Problem                 | Severity  | Reason                   |
| ----------------------- | --------- | ------------------------ |
| Empty constructor       | 🔴 High   | Invalid objects possible |
| Public setters          | 🔴 High   | Uncontrolled changes     |
| No validation           | 🔴 High   | Broken reservations      |
| No clear creation rules | 🟠 Medium | Weak object design       |

---

# ✅ Recommended Design Direction

The object should guarantee:

```text
Reservation

Always valid:

Customer exists

Room exists

CheckOut > CheckIn

Price >= 0
```

---

# Refactored Version

```csharp
using System;


public class Reservation
{
    public int Id { get; }

    public string CustomerName { get; }

    public string RoomNumber { get; }

    public DateTime CheckIn { get; }

    public DateTime CheckOut { get; }

    public decimal Price { get; }



    public Reservation(
        int id,
        string customerName,
        string roomNumber,
        DateTime checkIn,
        DateTime checkOut,
        decimal price)
    {

        if(string.IsNullOrWhiteSpace(customerName))
        {
            throw new ArgumentException(
                "Customer name required.");
        }


        if(string.IsNullOrWhiteSpace(roomNumber))
        {
            throw new ArgumentException(
                "Room number required.");
        }


        if(checkOut <= checkIn)
        {
            throw new ArgumentException(
                "Invalid reservation dates.");
        }


        if(price < 0)
        {
            throw new ArgumentException(
                "Price cannot be negative.");
        }


        Id = id;

        CustomerName = customerName;

        RoomNumber = roomNumber;

        CheckIn = checkIn;

        CheckOut = checkOut;

        Price = price;
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
        Reservation reservation =
            new Reservation(
                1,
                "Ahmed",
                "Room-101",
                new DateTime(2026,9,1),
                new DateTime(2026,9,5),
                2000);



        Console.WriteLine(
            reservation.CustomerName);
    }
}
```

---

# Output

```text
Ahmed
```

---

# Invalid Test

```csharp
Reservation reservation =
    new Reservation(
        1,
        "Ahmed",
        "Room-101",
        DateTime.Now,
        DateTime.Now.AddDays(-2),
        2000);
```

Result:

```
Exception

Invalid reservation dates.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Create empty object

↓

Fill properties later

↓

Hope it becomes valid
```

---

# After

```text
Provide required data

↓

Validate

↓

Create valid object
```

---

# Why Use Constructor Validation?

Because every place using the object can trust it.

Without validation:

```csharp
if(reservation.Price < 0)
{
}
```

must exist everywhere.

With validation:

```text
Reservation guarantees correctness.
```

---

# Why Are Properties Read-Only?

Before:

```csharp
Price {get;set;}
```

Anyone can change reservation price.

After:

```csharp
Price {get;}
```

The reservation value is protected.

---

# When Should Properties Change?

Example:

A reservation may support:

```text
ChangeDate()
Cancel()
```

instead of:

```csharp
CheckIn = newDate;
```

Because changes need rules.

---

# 🎤 Interview Discussion

---

## Q1: What is the responsibility of a constructor?

### Answer:

To initialize an object into a valid state.

---

## Q2: Why are empty constructors sometimes dangerous?

### Answer:

Because they allow creation of incomplete or invalid objects.

---

## Q3: Should all properties be immutable?

### Answer:

No.

Only values that should not change.

Mutable state should change through controlled methods.

---

## Q4: Where should validation happen?

### Answer:

At the boundary where invalid state enters the system, usually constructors and domain methods.

---

# 🧠 Reviewer Checklist

When reviewing constructors:

```text
☑ Can this object exist incomplete?

☑ Are required values enforced?

☑ Is validation performed?

☑ Are default constructors necessary?

☑ Can properties create invalid states?
```

---

# 🏁 Key Takeaways

1. Constructors create valid objects.
2. Empty constructors can allow broken states.
3. Required data should be enforced early.
4. Public setters weaken object control.
5. Objects should not need external code to "fix" them after creation.
6. A good constructor protects the object's invariants.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 05 Completed ✅
</p>

---


