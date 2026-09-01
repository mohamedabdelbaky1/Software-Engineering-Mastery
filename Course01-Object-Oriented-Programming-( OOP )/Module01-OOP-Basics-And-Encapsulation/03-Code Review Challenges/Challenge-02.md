

# 🔍 Code Review Challenge 02 — God Class Problem

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟠 Junior → Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You joined a payment platform team.

The previous developer created a class called:

```text
PaymentManager
```

Over time, new features were added:

* Payment processing
* Invoice generation
* Email notifications
* Database operations
* Discount calculation
* Logging

The system works, but developers complain:

* Small changes break unrelated features.
* Testing is difficult.
* The class keeps growing.
* Nobody knows where new code should go.

Your task:

Review the design and propose improvements.

---

# 👀 Code Under Review

```csharp
using System;


public class PaymentManager
{
    public void ProcessPayment(
        string customerName,
        decimal amount)
    {
        if(amount <= 0)
        {
            throw new Exception(
                "Invalid amount");
        }


        Console.WriteLine(
            "Processing payment...");
    }



    public void GenerateInvoice(
        string customerName,
        decimal amount)
    {
        Console.WriteLine(
            $"Invoice for {customerName}: {amount}");
    }



    public void SendEmail(
        string customerName)
    {
        Console.WriteLine(
            $"Sending email to {customerName}");
    }



    public void SavePayment()
    {
        Console.WriteLine(
            "Saving payment to database");
    }



    public decimal CalculateDiscount(
        decimal amount)
    {
        return amount * 0.1m;
    }



    public void WriteLog(
        string message)
    {
        Console.WriteLine(
            $"LOG: {message}");
    }
}
```

---

# Example Usage

```csharp
PaymentManager manager =
    new PaymentManager();


manager.ProcessPayment(
    "Mohamed",
    1000);


manager.GenerateInvoice(
    "Mohamed",
    1000);


manager.SendEmail(
    "Mohamed");


manager.SavePayment();


manager.WriteLog(
    "Payment completed");
```

---

# 🔴 Review Findings

---

# Issue 1 — Too Many Responsibilities

## Problem

`PaymentManager` handles:

```text id="6k3p8m"
Payment

Invoice

Email

Database

Discount

Logging
```

These are different responsibilities.

---

# Why Is This Dangerous?

Imagine a requirement:

> Change invoice format.

Should you modify:

```text id="n8p4z1"
PaymentManager
```

?

Yes.

But now every developer touching invoice logic changes the same class.

---

# Impact

Problems:

```text id="x4m7q9"
Hard to maintain

Hard to test

Frequent merge conflicts

Higher bug risk
```

---

# Senior Engineer Thinking

Ask:

> "How many reasons does this class have to change?"

A good class should have:

```text id="4m9x2k"
One primary responsibility
```

This is the foundation of:

```text id="z7p3n8"
Single Responsibility Principle
```

(SOLID will be studied later.)

---

# Issue 2 — Low Cohesion

## Definition

Cohesion means:

> How closely related the responsibilities inside a class are.

---

Current:

```text id="2n6q8v"
PaymentManager

Payment logic
+
Email logic
+
Database logic
```

Low cohesion.

---

Better:

```text id="5x9m3r"
PaymentService

Payment only
```

High cohesion.

---

# Issue 3 — Hard Testing

Current:

To test payment:

You must deal with:

```text id="9k4m7x"
Email

Database

Logging

Invoice
```

Even if you only need:

```text id="1z8p5q"
Payment calculation
```

---

# Issue 4 — Naming Problem

The name:

```csharp
PaymentManager
```

is unclear.

Manager classes often become:

```text id="p8m4y2"
"Put everything here"
```

---

Better names describe responsibility:

```text id="3q7n9w"
PaymentService

InvoiceGenerator

EmailSender

PaymentRepository
```

---

# 🧠 Senior Engineer Analysis

A senior reviewer asks:

---

## Question 1

### What does this class represent?

Current answer:

```text id="f5k9q1"
Everything related to payments and more
```

Bad.

---

Better:

```text id="m8x3v6"
One business responsibility
```

---

## Question 2

### Which parts change independently?

Examples:

Invoice:

```text id="r5n8x2"
Business rules change
```

Email:

```text id="v7m2k9"
Provider changes
```

Database:

```text id="q4x8p1"
Storage changes
```

These should be separate.

---

# ❌ Design Problems Summary

| Problem                   | Severity  | Reason                    |
| ------------------------- | --------- | ------------------------- |
| Too many responsibilities | 🔴 High   | Violates SRP              |
| Low cohesion              | 🔴 High   | Class has unrelated logic |
| Hard testing              | 🟠 Medium | Too many dependencies     |
| Poor naming               | 🟡 Medium | Encourages misuse         |
| Tight coupling            | 🔴 High   | Changes affect everything |

---

# ✅ Recommended Design Direction

Split responsibilities:

```text id="n7q4m8"

PaymentService

        |
        |
        +---- InvoiceService

        |
        |
        +---- EmailService

        |
        |
        +---- PaymentRepository

```

---

# Refactored Version

---

# PaymentService

Responsible only for payments.

```csharp
public class PaymentService
{
    public void ProcessPayment(
        decimal amount)
    {
        if(amount <= 0)
        {
            throw new ArgumentException(
                "Invalid amount");
        }


        Console.WriteLine(
            "Payment processed");
    }
}
```

---

# InvoiceService

Responsible only for invoices.

```csharp
public class InvoiceService
{
    public void GenerateInvoice(
        string customerName,
        decimal amount)
    {
        Console.WriteLine(
            $"Invoice created for {customerName}");
    }
}
```

---

# EmailService

Responsible only for notifications.

```csharp
public class EmailService
{
    public void Send(
        string customerName)
    {
        Console.WriteLine(
            $"Email sent to {customerName}");
    }
}
```

---

# PaymentRepository

Responsible only for storage.

```csharp
public class PaymentRepository
{
    public void Save()
    {
        Console.WriteLine(
            "Payment saved");
    }
}
```

---

# DiscountCalculator

Responsible only for discounts.

```csharp
public class DiscountCalculator
{
    public decimal Calculate(
        decimal amount)
    {
        return amount * 0.1m;
    }
}
```

---

# Usage After Refactoring

```csharp
PaymentService paymentService =
    new PaymentService();


InvoiceService invoiceService =
    new InvoiceService();


EmailService emailService =
    new EmailService();


PaymentRepository repository =
    new PaymentRepository();



paymentService.ProcessPayment(1000);

invoiceService.GenerateInvoice(
    "Mohamed",
    1000);

emailService.Send(
    "Mohamed");

repository.Save();
```

---

# 🔍 Refactoring Explanation

## Before

```text id="g9m5q2"
One giant class

PaymentManager

1000+ lines eventually
```

---

## After

```text id="w3p8n6"
Small focused classes

Each class:
- Has one purpose
- Is easier to test
- Is easier to change
```

---

# Why This Is Better?

## 1. Better Maintainability

Changing email logic:

Before:

```text id="x2m7p9"
Modify PaymentManager
```

After:

```text id="k5n8q3"
Modify EmailService
```

---

## 2. Better Testing

Test payment:

Only:

```text id="q8m3x1"
PaymentService
```

---

## 3. Better Ownership

Every class has a clear owner.

---

# 🎤 Interview Discussion

## Q1: What is a God Class?

### Answer:

A God Class is a class that contains too many responsibilities and controls many unrelated parts of a system.

---

## Q2: Why are God Classes dangerous?

### Answer:

Because they create high coupling, low cohesion, difficult testing, and risky changes.

---

## Q3: How do you identify a God Class?

### Answer:

Look for:

* Many unrelated methods.
* Many dependencies.
* Large file size.
* Multiple reasons to change.

---

## Q4: How do you refactor a God Class?

### Answer:

* Identify responsibilities.
* Extract focused classes.
* Move related behavior.
* Reduce dependencies.

---

# 🧠 Reviewer Checklist

When reviewing a class:

```text id="w8p3m5"
☑ Does this class have one clear responsibility?

☑ Can I describe it in one sentence?

☑ Does it have unrelated methods?

☑ Would different features require changing it?

☑ Is the name hiding too many responsibilities?
```

---

# 🏁 Key Takeaways

1. A class should have a focused responsibility.
2. Large classes are usually a design warning.
3. High cohesion improves maintainability.
4. Separation of responsibilities reduces bugs.
5. "Manager" classes often become dumping grounds.
6. Good design makes future changes safer.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 02 Completed ✅
</p>

---

e classes.
