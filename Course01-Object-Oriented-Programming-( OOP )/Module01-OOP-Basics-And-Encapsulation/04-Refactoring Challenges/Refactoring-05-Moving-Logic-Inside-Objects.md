

# 🔧 Refactoring Challenge 05 — Moving Logic Inside Objects

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on a shopping system.

The team created a `ShoppingCart` class.

However, all cart logic was placed inside a separate service.

Developers noticed:

* The cart object is only a data container.
* Business rules are scattered.
* Multiple services calculate totals differently.
* Changes require modifying many places.

Your task:

Move the correct logic into the object that owns the data.

---

# 🔴 Original Code

## ShoppingCart

```csharp
using System.Collections.Generic;


public class ShoppingCart
{
    public List<CartItem> Items { get; set; }
}
```

---

## CartItem

```csharp
public class CartItem
{
    public string Name { get; set; }

    public decimal Price { get; set; }

    public int Quantity { get; set; }
}
```

---

## ShoppingCartService

```csharp
using System.Linq;


public class ShoppingCartService
{

    public decimal CalculateTotal(
        ShoppingCart cart)
    {
        decimal total = 0;


        foreach(var item in cart.Items)
        {
            total += 
                item.Price * item.Quantity;
        }


        return total;
    }



    public void AddItem(
        ShoppingCart cart,
        CartItem item)
    {
        cart.Items.Add(item);
    }



    public void RemoveItem(
        ShoppingCart cart,
        CartItem item)
    {
        cart.Items.Remove(item);
    }
}
```

---

# Example Usage

```csharp
ShoppingCart cart =
    new ShoppingCart();


cart.Items =
    new List<CartItem>();


ShoppingCartService service =
    new ShoppingCartService();



service.AddItem(
    cart,
    new CartItem
    {
        Name = "Laptop",
        Price = 2000,
        Quantity = 1
    });



decimal total =
    service.CalculateTotal(cart);
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — ShoppingCart Has No Behavior

Current design:

```text
ShoppingCart

=
Data only
```

It knows:

* Items

But it does not know:

* How to add items.
* How to remove items.
* How to calculate total.

---

The real owner of this logic is:

```text
ShoppingCart
```

because the cart owns:

```text
Items
```

---

# ❌ Problem 2 — External Logic Controls Internal State

Current:

```csharp
service.AddItem(cart,item);
```

The service modifies the cart.

The relationship is backwards.

---

Better:

```csharp
cart.AddItem(item);
```

The object controls itself.

---

# ❌ Problem 3 — Duplicate Business Logic Risk

Imagine another developer creates:

```text
CheckoutService.CalculateTotal()

InvoiceService.CalculateTotal()

ReportService.CalculateTotal()
```

Now total calculation exists in many places.

---

A rule should have one owner.

---

# ❌ Problem 4 — Weak Encapsulation

Current:

```csharp
public List<CartItem> Items {get;set;}
```

Allows:

```csharp
cart.Items.Clear();
```

without rules.

---

# 🧠 Senior Engineer Thinking

A senior engineer asks:

---

## Question 1

Who owns the data?

Answer:

```text
ShoppingCart
```

It owns:

```text
Items
```

---

## Question 2

Who should calculate the total?

Answer:

The object that knows all items:

```text
ShoppingCart
```

---

## Question 3

Should services manipulate objects directly?

Only when the logic does not belong to the object.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Move item management into `ShoppingCart`.

---

## Step 2

Move total calculation into `ShoppingCart`.

---

## Step 3

Protect the internal collection.

---

## Step 4

Make `CartItem` a valid object.

---

# ✅ Refactored Code

---

# CartItem

```csharp
using System;


public class CartItem
{
    public string Name { get; }


    public decimal Price { get; }


    public int Quantity { get; }



    public CartItem(
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

# ShoppingCart

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class ShoppingCart
{
    private readonly List<CartItem> items =
        new();



    public IReadOnlyList<CartItem> Items
        => items;



    public void AddItem(CartItem item)
    {
        if(item == null)
        {
            throw new ArgumentNullException(
                nameof(item));
        }


        items.Add(item);
    }



    public void RemoveItem(CartItem item)
    {
        items.Remove(item);
    }



    public decimal CalculateTotal()
    {
        return items.Sum(
            item => item.GetTotal());
    }
}
```

---

# 🧪 Test Cases

---

## Valid Usage

```csharp
public class Program
{
    public static void Main()
    {
        ShoppingCart cart =
            new ShoppingCart();



        CartItem item =
            new CartItem(
                "Laptop",
                2000,
                2);



        cart.AddItem(item);



        Console.WriteLine(
            cart.CalculateTotal());
    }
}
```

---

# Output

```text
4000
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
ShoppingCart

      |
      |
      ↓

ShoppingCartService

owns all logic
```

---

# After

```text
ShoppingCart

owns:

- Items
- Add
- Remove
- Calculate total
```

---

# Why Move CalculateTotal()?

Because:

```text
Total depends on cart items.
```

The cart has the required information.

The service does not own that responsibility.

---

# Why Is This Better?

## 1. Better Encapsulation

Before:

```csharp
cart.Items.Add(item);
```

Anyone changes the cart.

After:

```csharp
cart.AddItem(item);
```

The cart controls changes.

---

## 2. Better Maintainability

Future rule:

```text
10% discount for orders above $5000
```

Where should it go?

Before:

Search all services.

After:

```text
ShoppingCart
```

---

## 3. Better Domain Model

Before:

```text
ShoppingCart

=
Data container
```

After:

```text
ShoppingCart

=
Real business object
```

---

# 🎤 Interview Discussion

---

## Q1: What is the "Tell, Don't Ask" principle?

### Answer:

Objects should be told what to do instead of having their data extracted and manipulated externally.

Bad:

```csharp
if(cart.Items.Count > 0)
{
    ...
}
```

Better:

```csharp
cart.Checkout();
```

---

## Q2: When should logic move inside an object?

### Answer:

When the logic primarily operates on that object's own state.

---

## Q3: Are service classes always bad?

### Answer:

No.

Services are useful for operations that do not naturally belong to one object.

---

## Q4: What is an anemic object?

### Answer:

An object that contains only data while all behavior exists elsewhere.

---

# 🧠 Refactoring Checklist

```text
☑ Does the class own the data?

☑ Does it own the related behavior?

☑ Is logic duplicated elsewhere?

☑ Are external classes modifying internal state?

☑ Does the object represent a real domain concept?
```

---

# 🏁 Key Takeaways

1. Data and behavior should usually live together.
2. Objects should control their own state.
3. External services should not replace domain objects.
4. Encapsulation is about ownership of rules.
5. Good OOP creates objects that know what they can do.
6. A class should represent a meaningful concept, not just a storage container.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 05 Completed ✅
</p>

---

