

# 🔧 Refactoring Challenge 06 — Removing Duplicate State

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on an invoice management system.

The team created an `Invoice` class.

The class stores:

* Invoice items.
* Total amount.

The system works, but bugs appear:

* Invoice total does not match item prices.
* Developers forget to update the total.
* Different parts of the application calculate different values.

Your task:

Remove duplicate state and make the object always consistent.

---

# 🔴 Original Code

```csharp id="x9m3ka"
using System.Collections.Generic;


public class Invoice
{
    public List<InvoiceItem> Items { get; set; }


    public decimal Total { get; set; }
}
```

---

# Invoice Item

```csharp id="k7p2mz"
public class InvoiceItem
{
    public string Name { get; set; }

    public decimal Price { get; set; }

    public int Quantity { get; set; }
}
```

---

# Example Usage

```csharp id="w2m8qv"
Invoice invoice =
    new Invoice();


invoice.Items =
    new List<InvoiceItem>();


invoice.Items.Add(
    new InvoiceItem
    {
        Name = "Laptop",
        Price = 2000,
        Quantity = 2
    });



invoice.Total = 1000;
```

---

# Current State

The object now contains:

```text id="m5q8x1"
Items:

Laptop
Price = 2000
Quantity = 2


Total:

1000
```

The invoice is inconsistent.

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Multiple Sources of Truth

The invoice stores:

```text id="0s9l4p"
Items

+

Total
```

But:

```text id="h3m7x2"
Total depends on Items
```

The total can be calculated.

---

# Why Is This Dangerous?

Two values can disagree:

Example:

```text id="q6m9x4"
Database:

Items = 5000

Total = 3000
```

Which one is correct?

---

# ❌ Problem 2 — Manual Synchronization

Developers must remember:

```csharp id="v7n2px"
invoice.Total += item.Price;
```

every time an item changes.

---

This creates bugs.

---

# ❌ Problem 3 — Public Modification

Current:

```csharp id="4m8x2q"
public decimal Total {get;set;}
```

Allows:

```csharp id="2k9p5v"
invoice.Total = -500;
```

Invalid invoice.

---

# ❌ Problem 4 — Object Cannot Guarantee Correctness

A good invoice should guarantee:

```text id="9m2x7q"
Total = Sum of all items
```

The current design cannot.

---

# 🧠 Senior Engineer Thinking

A senior developer asks:

---

## Question 1

Is Total independent data?

No.

It is calculated from:

```text id="q4m8x2"
Invoice Items
```

---

## Question 2

Should calculated values be stored?

Usually no.

If a value can be derived reliably, calculate it.

---

## Question 3

Who owns the calculation?

Answer:

```text id="m9x3q7"
Invoice
```

Because the invoice owns its items.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Remove stored `Total`.

---

## Step 2

Make items controlled by the invoice.

---

## Step 3

Calculate total dynamically.

---

## Step 4

Protect invoice consistency.

---

# ✅ Refactored Code

---

# InvoiceItem

```csharp id="n5x8mq"
using System;


public class InvoiceItem
{
    public string Name { get; }

    public decimal Price { get; }

    public int Quantity { get; }



    public InvoiceItem(
        string name,
        decimal price,
        int quantity)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name required.");
        }


        if(price < 0)
        {
            throw new ArgumentException(
                "Invalid price.");
        }


        if(quantity <= 0)
        {
            throw new ArgumentException(
                "Invalid quantity.");
        }


        Name = name;

        Price = price;

        Quantity = quantity;
    }



    public decimal GetTotal()
    {
        return Price * Quantity;
    }
}
```

---

# Invoice

```csharp id="c4m7xz"
using System;
using System.Collections.Generic;
using System.Linq;


public class Invoice
{
    private readonly List<InvoiceItem> items =
        new();



    public IReadOnlyList<InvoiceItem> Items
        => items;



    public decimal Total
    {
        get
        {
            return items.Sum(
                item => item.GetTotal());
        }
    }



    public void AddItem(
        InvoiceItem item)
    {
        if(item == null)
        {
            throw new ArgumentNullException(
                nameof(item));
        }


        items.Add(item);
    }



    public void RemoveItem(
        InvoiceItem item)
    {
        items.Remove(item);
    }
}
```

---

# 🧪 Test Cases

---

## Valid Usage

```csharp id="a7m3qx"
public class Program
{
    public static void Main()
    {
        Invoice invoice =
            new Invoice();



        invoice.AddItem(
            new InvoiceItem(
                "Laptop",
                2000,
                2));



        invoice.AddItem(
            new InvoiceItem(
                "Mouse",
                100,
                1));



        Console.WriteLine(
            invoice.Total);
    }
}
```

---

# Output

```text id="x2m9qk"
4100
```

---

# Invalid Usage

```csharp id="m6q8xp"
invoice.Total = -1000;
```

Compilation error:

```text id="p9x3mw"
Property is read-only
```

---

# 🔍 Refactoring Explanation

---

# Before

```text id="w4m8q2"
Invoice

Items

+

Stored Total
```

Two places represent the same truth.

---

# After

```text id="z7m2x5"
Invoice

Items

↓

Total calculated
```

One source of truth.

---

# Why Remove Total Field?

Because:

```text id="n8q4mx"
Total = Function(Items)
```

It is derived information.

Keeping it creates unnecessary synchronization.

---

# Benefits

---

## 1. Always Correct

Before:

```text id="r5m9x2"
Items changed

Total forgotten
```

After:

```text id="k3q8m1"
Items changed

Total updates automatically
```

---

## 2. Less Code

No need:

```csharp
UpdateTotal();
```

after every operation.

---

## 3. Better Encapsulation

The invoice controls:

* Adding items.
* Removing items.
* Calculating totals.

---

# 🎤 Interview Discussion

---

## Q1: What is duplicate state?

### Answer:

When the same piece of information is stored in multiple places.

Example:

```text
Items

Total
```

where Total depends on Items.

---

## Q2: Why is duplicate state dangerous?

### Answer:

Because multiple representations can become inconsistent.

---

## Q3: When should you store calculated values?

### Answer:

When calculation is expensive or requires external data, and consistency can be managed.

---

## Q4: What is the single source of truth principle?

### Answer:

A piece of important information should have one authoritative owner.

---

# 🧠 Refactoring Checklist

```text id="p4x8m7"
☑ Is the same data stored twice?

☑ Can this value be calculated?

☑ Is there manual synchronization?

☑ Does one object own the truth?

☑ Can invalid states exist?
```

---

# 🏁 Key Takeaways

1. Avoid storing derived data unnecessarily.
2. Multiple sources of truth create bugs.
3. Objects should own their data consistency.
4. Calculated properties are often safer than stored values.
5. Good design reduces the need for manual synchronization.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 06 Completed ✅
</p>

---

