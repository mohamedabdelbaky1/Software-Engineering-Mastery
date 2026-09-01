

# 🔍 Code Review Challenge 06 — Leaking Internal State

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟠 Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You are reviewing an order management system.

The team created an `Order` class.

The developer tried to apply encapsulation:

* The list is private.
* Direct field access is prevented.

The developer says:

> "The implementation is safe because the collection is private."

During review, you discover that external code can still modify the internal state.

---

# 👀 Code Under Review

```csharp
using System.Collections.Generic;


public class Order
{
    private readonly List<OrderItem> items = new();


    public int Id { get; }


    public List<OrderItem> Items
    {
        get
        {
            return items;
        }
    }



    public Order(int id)
    {
        Id = id;
    }



    public void AddItem(OrderItem item)
    {
        items.Add(item);
    }
}



public class OrderItem
{
    public string Name { get; set; }

    public decimal Price { get; set; }
}
```

---

# Example Usage

```csharp
Order order =
    new Order(100);



order.AddItem(
    new OrderItem
    {
        Name = "Laptop",
        Price = 1000
    });



order.Items.Clear();
```

---

# 🔴 Review Findings

---

# Issue 1 — Internal Collection Is Exposed

## Problem

The field is private:

```csharp
private readonly List<OrderItem> items;
```

This looks good.

But:

```csharp
public List<OrderItem> Items
{
    get
    {
        return items;
    }
}
```

returns the actual internal list.

---

External code now has direct access:

```csharp
order.Items.Clear();
```

The order lost control.

---

# Senior Engineer Thinking

Ask:

> Can external code modify internal state without using the object's methods?

Answer:

Yes.

Therefore:

Encapsulation is broken.

---

# Issue 2 — Readonly Does Not Mean Immutable

Many developers misunderstand:

```csharp
readonly List<OrderItem> items;
```

Meaning:

The reference cannot change.

It does NOT mean:

The list cannot change.

Example:

Allowed:

```csharp
items.Add(item);
```

Not allowed:

```csharp
items = new List<OrderItem>();
```

---

# Issue 3 — OrderItem Also Leaks State

Current:

```csharp
public class OrderItem
{
    public decimal Price { get; set; }
}
```

External code:

```csharp
item.Price = -500;
```

creates:

```text
Order Item

Price = -500
```

---

# Issue 4 — No Ownership Control

The order should own its items.

Currently:

```text
External Code

      |
      |
      ▼

Order Items
```

Better:

```text
Order

      |
      |
      ▼

Private Items

Controlled Operations
```

---

# 🧠 Senior Engineer Analysis

A senior engineer asks:

---

## Question 1

### What is the purpose of private collections?

Answer:

To make the object the only owner of collection changes.

---

## Question 2

### Is exposing a collection safe?

Depends.

This is dangerous:

```csharp
List<OrderItem>
```

because it allows:

* Add
* Remove
* Clear
* Replace

---

Safer:

```csharp
IReadOnlyList<OrderItem>
```

---

## Question 3

### Who should control adding items?

Answer:

The order.

Because:

```text
Order owns order rules.
```

---

# ❌ Design Problems Summary

| Problem                | Severity  | Reason                 |
| ---------------------- | --------- | ---------------------- |
| Internal list exposed  | 🔴 High   | Encapsulation broken   |
| Readonly misunderstood | 🟠 Medium | State still mutable    |
| OrderItem mutable      | 🔴 High   | Invalid items possible |
| No ownership boundary  | 🔴 High   | Rules bypassed         |

---

# ✅ Recommended Design Direction

The design should be:

```text
Order

Private:

List<OrderItem>


Public:

AddItem()
RemoveItem()

Read-only:

Items
```

---

# Refactored Version

---

# OrderItem

```csharp
public class OrderItem
{
    public string Name { get; }

    public decimal Price { get; }


    public OrderItem(
        string name,
        decimal price)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name required.");
        }


        if(price < 0)
        {
            throw new ArgumentException(
                "Price cannot be negative.");
        }


        Name = name;

        Price = price;
    }
}
```

---

# Order

```csharp
using System;
using System.Collections.Generic;


public class Order
{
    private readonly List<OrderItem> items =
        new();



    public int Id { get; }



    public IReadOnlyList<OrderItem> Items
        => items;



    public Order(int id)
    {
        Id = id;
    }



    public void AddItem(OrderItem item)
    {
        if(item == null)
        {
            throw new ArgumentNullException(
                nameof(item));
        }


        items.Add(item);
    }



    public void RemoveItem(OrderItem item)
    {
        items.Remove(item);
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
            new Order(100);



        order.AddItem(
            new OrderItem(
                "Laptop",
                1000));



        Console.WriteLine(
            order.Items.Count);
    }
}
```

---

# Output

```text
1
```

---

# Invalid Test

```csharp
order.Items.Clear();
```

Compilation error:

```text
IReadOnlyList does not support Clear()
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Order

Private List

+

Public Reference
```

Although the field is private, the list escapes.

---

# After

```text
Order

Private List

+

Read-only View

+

Controlled Methods
```

---

# Why Use IReadOnlyList?

Before:

```csharp
public List<OrderItem> Items
```

External code can:

```csharp
Items.Add()

Items.Remove()

Items.Clear()
```

---

After:

```csharp
public IReadOnlyList<OrderItem> Items
```

External code can only:

```csharp
Read

Count

Access items
```

---

# Why Does This Matter in Production?

Imagine:

```text
Order
   |
   |
Items
```

Business rules:

* Paid orders cannot change.
* Maximum item limit.
* Stock validation.

If the list is exposed:

```csharp
order.Items.Add(item);
```

all rules are bypassed.

---

# 🎤 Interview Discussion

---

## Q1: What is leaking internal state?

### Answer:

When an object exposes references to its internal mutable data, allowing external code to modify its state directly.

---

## Q2: Is returning a private list safe?

### Answer:

No.

Returning the reference exposes the internal collection.

---

## Q3: How do you protect collections in C#?

### Answer:

Use:

* Private collection.
* Public read-only interface.
* Controlled modification methods.

Example:

```csharp
private List<Item> items;

public IReadOnlyList<Item> Items => items;
```

---

## Q4: What is the difference between readonly and immutable?

### Answer:

`readonly` prevents changing the reference.

It does not prevent changing the object's internal state.

---

# 🧠 Reviewer Checklist

When reviewing collections:

```text
☑ Is the collection private?

☑ Is the actual List exposed?

☑ Can external code add/remove items?

☑ Are modifications controlled?

☑ Are collection elements themselves protected?
```

---

# 🏁 Key Takeaways

1. Private fields alone do not guarantee encapsulation.
2. References to mutable objects can leak internal state.
3. Collections should usually be exposed as read-only.
4. `readonly` does not mean immutable.
5. Objects should control changes to their owned data.
6. Ownership boundaries are essential in OOP design.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 06 Completed ✅
</p>

---

