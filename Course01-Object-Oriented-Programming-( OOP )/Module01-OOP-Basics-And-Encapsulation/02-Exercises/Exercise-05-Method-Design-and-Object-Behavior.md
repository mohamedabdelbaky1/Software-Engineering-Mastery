

# 🧩 Exercise 05 — Method Design and Object Behavior

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Method design
* Object behavior
* Command methods
* Query methods
* Behavior ownership
* Avoiding procedural programming inside OOP
* Designing expressive APIs

---

## Why This Matters

A common beginner mistake is creating classes that only store data:

```csharp
public class ShoppingCart
{
    public List<Product> Products;
    public decimal Total;
}
```

Then all logic moves somewhere else:

```csharp
ShoppingCartService.CalculateTotal(cart);

ShoppingCartService.AddProduct(cart);

ShoppingCartService.RemoveProduct(cart);
```

This creates procedural code disguised as OOP.

Professional OOP asks:

> "Which object owns this behavior?"

The answer is usually:

> "The object that owns the data required to perform that behavior."

---

# 🏢 Real-World Scenario

## Shopping Cart System

You are building the cart functionality of an e-commerce platform.

A shopping cart should allow customers to:

* Add products
* Remove products
* Calculate total price
* Apply discounts
* Clear the cart

---

# 📌 Requirements

Create a `ShoppingCart` class.

---

## Cart State

The cart should contain:

```text
Items
Customer Information
```

---

## Cart Behavior

The cart should support:

### Add Product

```csharp
AddProduct(Product product)
```

---

### Remove Product

```csharp
RemoveProduct(Product product)
```

---

### Calculate Total

```csharp
CalculateTotal()
```

---

### Apply Discount

```csharp
ApplyDiscount(decimal percentage)
```

---

### Clear Cart

```csharp
Clear()
```

---

# 🧠 Engineering Focus

Before writing code, think about responsibility.

---

# Question 1

## Who owns adding products?

Bad thinking:

```text
CartService adds products to cart.
```

Better thinking:

```text
ShoppingCart owns its items.
```

Because:

```text
Cart
 |
 └── Items
```

---

# Question 2

## Should external code modify Items directly?

Example:

```csharp
cart.Items.Add(product);
```

Problems:

* No validation.
* No rules.
* No control.

What if:

```text
Product is unavailable?
Quantity is invalid?
Duplicate item?
```

The cart cannot protect itself.

---

# Question 3

## Is CalculateTotal a cart responsibility?

Yes.

Why?

Because the cart owns:

```text
The collection of items
```

and the total depends on them.

---

# ❌ Bad Design Example

```csharp
public class ShoppingCart
{
    public List<Product> Items;
    public decimal Total;
}
```

External code:

```csharp
cart.Items.Add(product);

cart.Total += product.Price;
```

---

# Why This Is Poor Design

## 1. Logic Lives Outside the Object

The caller decides:

```text
How total is calculated.
How items are added.
How discounts work.
```

---

## 2. State Can Become Incorrect

Example:

```csharp
cart.Total = 100;

cart.Items.Add(
    new Product("Laptop",500));
```

Now:

```text
Items value != Total value
```

---

## 3. No Business Rules

The cart cannot enforce:

```text
Maximum items.
Valid products.
Discount rules.
```

---

# ✅ Expected Design Direction

The cart should own its behavior.

---

## ShoppingCart Responsibilities

```text
ShoppingCart

Owns:
- Items

Controls:
- Adding items
- Removing items
- Calculating total
- Applying discounts
```

---

## Product Responsibilities

```text
Product

Owns:
- Name
- Price
```

---

## Relationship

```text
Customer

   |
   ▼

ShoppingCart

   |
   ▼

Products
```

---

# 💻 Solution

## Product Class

```csharp
public class Product
{
    public string Name { get; }

    public decimal Price { get; }


    public Product(
        string name,
        decimal price)
    {
        Name = name;
        Price = price;
    }
}
```

---

## ShoppingCart Class

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class ShoppingCart
{
    private readonly List<Product> items = new();


    public IReadOnlyList<Product> Items => items;


    private decimal discount;


    public void AddProduct(Product product)
    {
        if (product == null)
        {
            throw new ArgumentNullException(
                nameof(product));
        }

        items.Add(product);
    }


    public void RemoveProduct(Product product)
    {
        items.Remove(product);
    }


    public decimal CalculateTotal()
    {
        decimal subtotal =
            items.Sum(product => product.Price);


        return subtotal - discount;
    }


    public void ApplyDiscount(decimal percentage)
    {
        if (percentage <= 0 ||
            percentage > 100)
        {
            throw new ArgumentException(
                "Invalid discount.");
        }


        decimal subtotal =
            items.Sum(product => product.Price);


        discount =
            subtotal * percentage / 100;
    }


    public void Clear()
    {
        items.Clear();
        discount = 0;
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
                1000);


        Product mouse =
            new Product(
                "Mouse",
                50);


        ShoppingCart cart =
            new ShoppingCart();


        cart.AddProduct(laptop);

        cart.AddProduct(mouse);


        Console.WriteLine(
            cart.CalculateTotal());


        cart.ApplyDiscount(10);


        Console.WriteLine(
            cart.CalculateTotal());


        cart.RemoveProduct(mouse);


        Console.WriteLine(
            cart.CalculateTotal());
    }
}
```

---

# Expected Output

```text
1050

945

900
```

---

# 🔍 Solution Explanation

## Why Does ShoppingCart Own AddProduct()?

Because the cart owns:

```text
Its items
```

Therefore it should control:

```text
How items enter the cart.
```

---

## Why Is Items Read-Only?

Instead of:

```csharp
public List<Product> Items {get;set;}
```

we use:

```csharp
public IReadOnlyList<Product> Items
```

because external code can view items but cannot directly manipulate internal state.

---

## Why Is Total Calculated Instead of Stored?

Bad:

```csharp
public decimal Total;
```

because:

```text
Items change
      ↓
Total may become outdated
```

Better:

```csharp
CalculateTotal()
```

because total is derived from current state.

---

## Why Are Methods Better Than Direct Modification?

Compare:

```csharp
cart.Items.Add(product);
```

with:

```csharp
cart.AddProduct(product);
```

The second allows the cart to enforce rules.

---

# 💡 Senior Engineer Notes

## Command vs Query Thinking

A useful design distinction:

---

## Command

Changes state.

Examples:

```text
AddProduct()
RemoveProduct()
Clear()
ApplyDiscount()
```

---

## Query

Returns information.

Example:

```text
CalculateTotal()
```

Queries should usually not modify object state.

---

## Good Method Names Express Intent

Weak:

```csharp
ChangeValue()
UpdateData()
Process()
```

Strong:

```csharp
AddProduct()
CancelOrder()
Withdraw()
ApplyDiscount()
```

The method name should communicate domain meaning.

---

# Production Improvements

A real shopping system may introduce:

```text
ShoppingCart
CartItem
PricingService
DiscountPolicy
InventoryService
```

depending on complexity.

---

# 🎤 Interview Connection

## Question 1

### Where should a method belong?

Answer:

A method should belong to the object that has the responsibility and the data required to perform that behavior.

---

## Question 2

### What is the difference between command and query methods?

Answer:

A command changes object state.

A query returns information without changing state.

---

## Question 3

### Why is putting all logic in services sometimes problematic?

Answer:

Because objects become passive data containers while business behavior moves elsewhere, reducing encapsulation and increasing coupling.

---

## Question 4

### Why should objects expose behavior instead of raw data?

Answer:

Because behavior allows objects to protect their rules and maintain valid state.

---

# 🧠 Engineering Reflection

Before moving forward:

```text
1. Why does AddProduct belong to ShoppingCart?

2. Why should Items not be publicly editable?

3. Why is Total calculated instead of stored?

4. What makes a method a good method?

5. How do methods help encapsulation?
```

---

# 🏁 Key Takeaways

1. Methods should represent meaningful object behavior.
2. Objects should own the operations that affect their state.
3. Avoid creating classes that only store data.
4. Good methods express intent.
5. Commands change state; queries return information.
6. Derived values should often be calculated instead of stored.
7. Encapsulation depends on controlling behavior, not only hiding fields.
8. Method design is a major part of professional OOP.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 05 of 19 ✅
</p>
```

ning.
