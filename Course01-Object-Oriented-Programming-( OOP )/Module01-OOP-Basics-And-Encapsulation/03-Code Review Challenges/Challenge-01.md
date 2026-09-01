

# 🔍 Code Review Challenge 01 — Public State Problem

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟡 Junior → Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You joined an e-commerce company.

The team has a `ShoppingCart` class that manages customer purchases.

The current implementation works, but after several months, developers started reporting bugs:

* Cart total becomes incorrect.
* Products disappear unexpectedly.
* Different parts of the application modify cart data directly.
* Developers are afraid to change the class.

You are asked to review the code.

---

# 👀 Code Under Review

```csharp
using System.Collections.Generic;
using System.Linq;


public class ShoppingCart
{
    public int CustomerId;

    public List<CartItem> Items;

    public decimal Total;


    public void CalculateTotal()
    {
        Total = Items.Sum(x => x.Price * x.Quantity);
    }
}


public class CartItem
{
    public string ProductName;

    public decimal Price;

    public int Quantity;
}
```

---

# Example Usage

```csharp
ShoppingCart cart = new ShoppingCart();


cart.CustomerId = 1001;


cart.Items = new List<CartItem>();


cart.Items.Add(
    new CartItem
    {
        ProductName = "Laptop",
        Price = 1000,
        Quantity = 1
    });


cart.Total = -500;
```

---

# 🔴 Review Findings

---

# Issue 1 — Public Mutable Fields

## Problem

The class exposes all internal data:

```csharp
public List<CartItem> Items;

public decimal Total;
```

Any external code can modify the cart.

Example:

```csharp
cart.Total = -500;
```

The cart accepts invalid data.

---

## Impact

The object cannot protect itself.

Possible production problems:

```text
Negative totals

Incorrect invoices

Invalid checkout calculations

Data corruption
```

---

# Senior Engineer Thinking

Ask:

> Who owns the cart rules?

The answer:

```
ShoppingCart
```

The cart should control:

* Adding items.
* Removing items.
* Calculating totals.

External code should request actions, not modify state.

---

# Issue 2 — No Encapsulation Boundary

Current design:

```text
Application Code

        |
        |
        ▼

ShoppingCart Fields
```

Everything is exposed.

A better design:

```text
Application Code

        |
        |
        ▼

ShoppingCart Public API

        |
        |
        ▼

Private Internal State
```

---

# Issue 3 — Cart Total Can Become Incorrect

Current:

```csharp
public decimal Total;
```

Example:

```csharp
cart.Items.Add(item);

Console.WriteLine(cart.Total);
```

The value may be outdated.

The object has two sources of truth:

```
Items

+

Total
```

They can disagree.

---

# Issue 4 — CartItem Has No Protection

Current:

```csharp
public int Quantity;
```

Allows:

```csharp
item.Quantity = -10;
```

Invalid product quantity.

---

# 🧠 Senior Engineer Analysis

A professional reviewer asks:

---

## Question 1

### Can this object enter an invalid state?

Yes.

Example:

```text
Quantity = -5

Total = -100
```

---

## Question 2

### Who should control changes?

The object itself.

---

## Question 3

### Is this class an object or just a data container?

Current:

```
ShoppingCart = Data Holder
```

Better:

```
ShoppingCart = Business Object
```

---

# ❌ Design Problems Summary

| Problem       | Severity  | Reason                   |
| ------------- | --------- | ------------------------ |
| Public fields | 🔴 High   | No protection            |
| Public List   | 🔴 High   | Internal state leaked    |
| Public Total  | 🔴 High   | Duplicate state          |
| No validation | 🔴 High   | Invalid objects possible |
| No behavior   | 🟠 Medium | Logic exists outside     |

---

# ✅ Recommended Design Direction

The goal:

```text
ShoppingCart

Private:
    items


Public:
    AddItem()
    RemoveItem()
    CalculateTotal()


Read Only:
    Items
    Total
```

---

# Refactored Version

## CartItem

```csharp
public class CartItem
{
    public string ProductName { get; }

    public decimal Price { get; }

    public int Quantity { get; private set; }


    public CartItem(
        string productName,
        decimal price,
        int quantity)
    {
        if(string.IsNullOrWhiteSpace(productName))
            throw new ArgumentException();


        if(price < 0)
            throw new ArgumentException();


        if(quantity <= 0)
            throw new ArgumentException();


        ProductName = productName;

        Price = price;

        Quantity = quantity;
    }


    public decimal GetTotal()
    {
        return Price * Quantity;
    }


    public void IncreaseQuantity(int amount)
    {
        if(amount <= 0)
            throw new ArgumentException();


        Quantity += amount;
    }
}
```

---

# ShoppingCart

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class ShoppingCart
{
    private readonly List<CartItem> items = new();


    public int CustomerId { get; }


    public IReadOnlyList<CartItem> Items
        => items;


    public decimal Total
        => items.Sum(x => x.GetTotal());



    public ShoppingCart(int customerId)
    {
        CustomerId = customerId;
    }



    public void AddItem(CartItem item)
    {
        if(item == null)
            throw new ArgumentNullException();


        items.Add(item);
    }



    public void RemoveItem(CartItem item)
    {
        items.Remove(item);
    }
}
```

---

# 🧪 Test

```csharp
public class Program
{
    public static void Main()
    {
        ShoppingCart cart =
            new ShoppingCart(1001);


        CartItem laptop =
            new CartItem(
                "Laptop",
                1000,
                1);


        cart.AddItem(laptop);


        Console.WriteLine(
            cart.Total);
    }
}
```

---

# Output

```
1000
```

---

# 🔍 Refactoring Explanation

---

## Before

```text
ShoppingCart

Data

+
External Modification
```

---

## After

```text
ShoppingCart

State

+

Behavior

+

Rules
```

---

# Why Remove Total Setter?

Before:

```csharp
cart.Total = -500;
```

After:

```csharp
cart.Total
```

The value is calculated from items.

One source of truth:

```
Items
 ↓
Total
```

---

# Why Use IReadOnlyList?

Instead of:

```csharp
public List<CartItem> Items
```

we use:

```csharp
public IReadOnlyList<CartItem> Items
```

The caller can:

```csharp
cart.Items.Count;
```

but cannot:

```csharp
cart.Items.Clear();
```

---

# Why Move Logic Inside Objects?

Before:

```text
Controller calculates total

Service validates quantity

UI modifies items
```

After:

```text
ShoppingCart owns cart rules

CartItem owns item rules
```

---

# 🎤 Interview Discussion

## Q1: Why are public fields considered bad practice?

### Answer:

Because they expose internal state and allow uncontrolled modification, making it impossible for the object to protect its invariants.

---

## Q2: What is the difference between encapsulation and hiding fields?

### Answer:

Hiding fields is only restricting access.

Encapsulation means protecting state and controlling how it changes.

---

## Q3: Why should Total not be stored?

### Answer:

Because it duplicates information that already exists in Items, creating consistency problems.

---

## Q4: What is the benefit of private state?

### Answer:

The class can enforce rules and safely evolve its implementation.

---

# 🧠 Reviewer Checklist

When reviewing classes, ask:

```text
☑ Are important fields private?

☑ Can external code create invalid states?

☑ Is behavior inside the correct object?

☑ Are collections protected?

☑ Are there duplicated sources of truth?

☑ Does the class have a clear responsibility?
```

---

# 🏁 Key Takeaways

1. Public state creates fragile systems.
2. Objects should control their own data.
3. Expose behavior, not implementation details.
4. Avoid storing calculated values unnecessarily.
5. Encapsulation is about protecting correctness.
6. A good class prevents misuse.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 01 Completed ✅
</p>

---

