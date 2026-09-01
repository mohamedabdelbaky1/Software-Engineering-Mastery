

# 🧩 Exercise 14 — Designing Immutable Objects

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Professional OOP Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Immutable objects
* Read-only state
* Object safety
* `readonly`
* Getter-only properties
* Value objects
* Preventing unexpected mutations

---

# Why This Matters

Most objects in business systems change:

Example:

```text
BankAccount

Balance changes
Status changes
Transactions added
```

But some objects represent a fixed value.

Examples:

```text
Money

Date Range

Address

Coordinates

Currency
```

These objects should often be immutable.

---

## Mutable Object Example

```csharp
Money money = new Money();

money.Amount = 100;
```

Later:

```csharp
money.Amount = 500;
```

Now the same object represents a different value.

This can create unexpected behavior.

---

## Immutable Object

Instead:

```csharp
Money money =
    new Money(100);
```

The value never changes.

If we need another value:

```csharp
Money newMoney =
    money.Add(50);
```

A new object is created.

---

# 🏢 Real-World Scenario

# Payment System — Money Representation

You are building a payment system.

The system needs a `Money` object.

A money value contains:

* Amount
* Currency

Example:

```text
100 USD

500 EGP
```

---

Money should follow these rules:

```text
Amount cannot be negative.

Currency cannot be empty.

Money cannot change after creation.

Operations return a new Money object.
```

---

# 📌 Requirements

Create a `Money` class.

---

# Money State

The object contains:

```text
Amount

Currency
```

---

# Object Rules

The object must guarantee:

```text
Amount is always valid.

Currency never changes.

Money value cannot be modified.
```

---

# Behaviors

---

## Add Money

```csharp
Add(Money other)
```

Example:

```text
100 USD + 50 USD

=

150 USD
```

---

## Multiply Money

```csharp
Multiply(decimal factor)
```

Example:

```text
100 USD × 2

=

200 USD
```

---

# 🧠 Engineering Focus

## Question 1

### Should Money Change?

Example:

```text
Money = 100 USD
```

Should this object become:

```text
Money = 200 USD
```

No.

The original value loses meaning.

---

# Question 2

## Who Owns The Value?

Money itself.

Therefore:

```text
Money controls validity.
```

---

# Question 3

## How Do We Modify Immutable Objects?

We don't.

Instead:

```text
Old Object

+

Operation

↓

New Object
```

---

# ❌ Bad Design Example

```csharp
public class Money
{
    public decimal Amount { get; set; }

    public string Currency { get; set; }
}
```

Usage:

```csharp
Money price =
    new Money();

price.Amount = 100;

price.Currency = "USD";


price.Amount = 500;
```

---

# Why This Is Poor Design

## 1. Value Can Change Unexpectedly

A price object can suddenly represent another amount.

---

## 2. Harder Debugging

Example:

```text
Order created with:

100 USD


Later:

500 USD
```

Who changed it?

---

## 3. No Guarantee

The object cannot promise:

```text
My value never changes.
```

---

# ✅ Expected Design Direction

Design:

```text
Money

Immutable State

+

Operations Creating New Values
```

---

# Object Design

```text
Money

Private State:

Amount
Currency


Public:

Add()
Multiply()


No setters
```

---

# 💻 Solution

```csharp
using System;


public sealed class Money
{
    public decimal Amount { get; }

    public string Currency { get; }


    public Money(
        decimal amount,
        string currency)
    {
        if (amount < 0)
        {
            throw new ArgumentException(
                "Amount cannot be negative.");
        }


        if (string.IsNullOrWhiteSpace(currency))
        {
            throw new ArgumentException(
                "Currency is required.");
        }


        Amount = amount;

        Currency = currency;
    }



    public Money Add(Money other)
    {
        if (Currency != other.Currency)
        {
            throw new InvalidOperationException(
                "Currencies must match.");
        }


        return new Money(
            Amount + other.Amount,
            Currency);
    }



    public Money Multiply(decimal factor)
    {
        if (factor < 0)
        {
            throw new ArgumentException(
                "Factor cannot be negative.");
        }


        return new Money(
            Amount * factor,
            Currency);
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
        Money price =
            new Money(
                100,
                "USD");


        Money discount =
            new Money(
                20,
                "USD");


        Money finalPrice =
            price.Add(discount);


        Console.WriteLine(
            finalPrice.Amount);


        Money doubled =
            price.Multiply(2);


        Console.WriteLine(
            doubled.Amount);


        Console.WriteLine(
            price.Amount);
    }
}
```

---

# Expected Output

```text
120

200

100
```

Notice:

```text
Original price stayed 100.
```

The object was not modified.

---

# 🔍 Solution Explanation

## Why Are There No Setters?

There is no:

```csharp
Amount { get; set; }
```

because that would allow:

```csharp
money.Amount = 500;
```

breaking immutability.

---

## Why Return New Objects?

Example:

```csharp
price.Add(discount);
```

creates:

```text
Old Money

100 USD


New Money

120 USD
```

The original remains unchanged.

---

## Why Is Money Sealed?

```csharp
public sealed class Money
```

Because immutable objects should not easily be extended in ways that introduce mutable behavior.

---

# 💡 Senior Engineer Notes

## Immutable Object Characteristics

An immutable object:

✅ Has no setters
✅ Cannot change after creation
✅ Validates data during construction
✅ Returns new objects for modifications

---

# Benefits of Immutability

## 1. Easier Reasoning

The value never changes.

---

## 2. Safer Sharing

Multiple objects can reference the same instance.

Nobody can modify it.

---

## 3. Better Thread Safety

Immutable objects are naturally safer in concurrent environments.

---

# Immutable vs Mutable

| Mutable                | Immutable            |
| ---------------------- | -------------------- |
| State changes          | State fixed          |
| Easier initially       | Safer long-term      |
| More validation needed | Easier reasoning     |
| Risk of side effects   | Predictable behavior |

---

# Real Production Examples

Common immutable types:

```text
string

DateTime

Guid

Money

Coordinates
```

---

# 🎤 Interview Connection

## Question 1

### What is an immutable object?

Answer:

An object whose state cannot change after creation.

---

## Question 2

### How do you create an immutable class?

Answer:

* Private fields or getter-only properties.
* No setters.
* Validate in constructor.
* Return new objects instead of modifying state.

---

## Question 3

### Why are immutable objects useful?

Answer:

They reduce side effects, improve reliability, and make code easier to reason about.

---

## Question 4

### Is immutability always better?

Answer:

No.

Mutable objects are useful when state changes naturally, such as:

* Bank accounts.
* Orders.
* Shopping carts.

Immutable objects are useful for values.

---

# 🧠 Engineering Reflection

```text
1. Why should Money not have setters?

2. What happens when Add() creates a new object?

3. Why is immutability useful?

4. Which objects in real systems should be immutable?

5. When would immutability be a bad choice?
```

---

# 🏁 Key Takeaways

1. Some objects should never change after creation.
2. Immutable objects are easier to understand and safer.
3. Removing setters is not enough; the whole design must prevent mutation.
4. Operations on immutable objects create new instances.
5. Value objects are common candidates for immutability.
6. Good OOP design chooses between mutable and immutable based on the object's responsibility.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 14 of 19 ✅
</p>

````


* Private state + public behavior + invariants + lifecycle rules.
