

# 🧩 Exercise 07 — Object Initialization and Valid State

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Valid object state
* Invalid object state
* Object invariants
* Maintaining consistency
* Constructor responsibility
* Preventing impossible states
* Designing safe state transitions

---

## Why This Matters

Many developers focus only on:

> "How do I create an object?"

Professional developers ask:

> "Can this object ever become invalid?"

Example:

```csharp
public class Product
{
    public decimal Price { get; set; }

    public int Quantity { get; set; }
}
```

This allows:

```csharp
product.Price = -500;

product.Quantity = -10;
```

The object exists, but it no longer represents a valid product.

---

# 🏢 Real-World Scenario

# Inventory Management System

You are building an inventory system for an online store.

The system manages products.

A product has:

* Product name
* Price
* Available quantity
* Stock status

---

The business rules:

```text
Product name cannot be empty.

Price cannot be negative.

Quantity cannot be negative.

A product with quantity = 0 is out of stock.

A product with quantity > 0 is available.
```

---

# 📌 Requirements

Create a `Product` class.

---

# Product State

The product should contain:

```text
Name

Price

Quantity

StockStatus
```

---

# Object Creation

A product must be created with:

```csharp
new Product(...)
```

Required information:

* Name
* Price
* Initial quantity

---

# Behavior

The product should support:

---

## Add Stock

```csharp
AddStock(int quantity)
```

Rules:

* Quantity must be positive.

---

## Remove Stock

```csharp
RemoveStock(int quantity)
```

Rules:

* Quantity must be positive.
* Cannot remove more than available quantity.

---

## Check Availability

```csharp
IsAvailable()
```

Returns:

```text
true → quantity > 0

false → quantity = 0
```

---

# 🧠 Engineering Focus

Before coding, think about these questions.

---

# Question 1

## What Makes a Valid Product?

A valid product:

```text
Name exists

Price >= 0

Quantity >= 0
```

These are invariants.

---

# Question 2

## Who Protects Product Rules?

Bad:

```text
UI validates price

Controller validates quantity

Database validates name
```

Problem:

Different parts of the system may forget rules.

---

Better:

```text
Product protects itself
```

Because:

```text
Product owns product state.
```

---

# Question 3

## Can We Create Invalid Objects?

Bad:

```csharp
Product product = new Product();

product.Price = -100;
```

The system now contains:

```text
Invalid Product
```

---

A stronger design:

```text
Invalid Product

↓

Cannot be created
```

---

# ❌ Bad Design Example

```csharp
public class Product
{
    public string Name;

    public decimal Price;

    public int Quantity;

    public string StockStatus;
}
```

Usage:

```csharp
Product product =
    new Product();


product.Name = "";

product.Price = -50;

product.Quantity = -10;

product.StockStatus = "Available";
```

---

# Why This Is Poor Design

---

## 1. Impossible States Are Allowed

The system accepts:

```text
Price = -50

Quantity = -10

Available with zero stock
```

---

## 2. State Can Become Inconsistent

Example:

```text
Quantity = 0

StockStatus = Available
```

These values contradict each other.

---

## 3. Rules Are External

Every caller must remember:

```text
How products work
```

This creates duplication.

---

# ✅ Expected Design Direction

The product should protect its own validity.

---

# Product Responsibilities

The class should manage:

```text
Product identity

Product state

Stock operations

Availability rules
```

---

# State Ownership

```text
Product

 |
 |
 ├── Price

 ├── Quantity

 └── Availability
```

---

# Design Direction

```text
Constructor
    |
    ↓
Create Valid Product

Methods
    |
    ↓
Keep Product Valid
```

---

# 💻 Solution

```csharp
using System;

public class Product
{
    public string Name { get; }

    public decimal Price { get; }

    public int Quantity { get; private set; }


    public Product(
        string name,
        decimal price,
        int quantity)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Product name is required.");
        }


        if (price < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(price));
        }


        if (quantity < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(quantity));
        }


        Name = name;

        Price = price;

        Quantity = quantity;
    }


    public void AddStock(int quantity)
    {
        if (quantity <= 0)
        {
            throw new ArgumentException(
                "Quantity must be positive.");
        }


        Quantity += quantity;
    }


    public void RemoveStock(int quantity)
    {
        if (quantity <= 0)
        {
            throw new ArgumentException(
                "Quantity must be positive.");
        }


        if (quantity > Quantity)
        {
            throw new InvalidOperationException(
                "Not enough stock.");
        }


        Quantity -= quantity;
    }


    public bool IsAvailable()
    {
        return Quantity > 0;
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
        Product laptop =
            new Product(
                "Laptop",
                1000,
                10);


        Console.WriteLine(
            laptop.IsAvailable());


        laptop.RemoveStock(10);


        Console.WriteLine(
            laptop.IsAvailable());


        laptop.AddStock(5);


        Console.WriteLine(
            laptop.Quantity);
    }
}
```

---

# Expected Output

```text
True

False

5
```

---

# Invalid Creation Test

```csharp
Product product =
    new Product(
        "",
        -100,
        -5);
```

Expected:

```text
Exception

Product name is required.
```

---

# 🔍 Solution Explanation

## Why Is Quantity Private Set?

```csharp
public int Quantity { get; private set; }
```

Because changing quantity has rules.

External code should not do:

```csharp
product.Quantity = -50;
```

Only the product controls stock changes.

---

# Why Is StockStatus Not Stored?

A beginner may create:

```csharp
public string StockStatus;
```

Problem:

```text
Quantity = 0

StockStatus = Available
```

The data becomes inconsistent.

---

Better:

```csharp
IsAvailable()
```

because availability is derived from quantity.

---

# Why Are AddStock and RemoveStock Methods?

Because they represent real domain actions.

Compare:

```csharp
product.Quantity -= 5;
```

with:

```csharp
product.RemoveStock(5);
```

The second allows the object to protect rules.

---

# 💡 Senior Engineer Notes

## Invariant Thinking

An invariant is:

> A condition that must always be true for the object to remain valid.

For Product:

```text
Price >= 0

Quantity >= 0
```

Every operation must preserve these rules.

---

## Object Lifecycle

A professional object lifecycle:

```text
Create Valid Object

        ↓

Perform Behavior

        ↓

Validate Transition

        ↓

Remain Valid
```

---

## Avoid Boolean/String State When Possible

Weak:

```csharp
StockStatus = "Available";
```

Better:

```csharp
Quantity > 0
```

or later:

```csharp
enum StockState
```

---

# 🎤 Interview Connection

## Question 1

### What is an invariant?

Answer:

An invariant is a condition that must always remain true for an object to be considered valid.

---

## Question 2

### Why should objects protect invariants?

Answer:

Because the object owns the state, so it is the best place to guarantee that state remains valid.

---

## Question 3

### What is an invalid object state?

Answer:

A state where the object's data violates business rules or logical constraints.

Example:

```text
Product quantity = -5
```

---

## Question 4

### How do you prevent invalid states?

Answer:

By:

* Constructor validation
* Restricted setters
* Controlled methods
* Encapsulation

---

# 🧠 Engineering Reflection

Answer:

```text
1. Why should Product control Quantity changes?

2. Why is StockStatus calculated instead of stored?

3. What invariants does Product have?

4. What happens if Quantity is public?

5. Why is preventing invalid state better than fixing it later?
```

---

# 🏁 Key Takeaways

1. Objects should start in a valid state.
2. Objects should remain valid after every operation.
3. Invariants define what makes an object valid.
4. The class owning the state should protect its rules.
5. Avoid storing duplicate state that can become inconsistent.
6. Methods should preserve invariants during state changes.
7. Valid object design is the foundation of Encapsulation.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 07 of 19 ✅
</p>
```

