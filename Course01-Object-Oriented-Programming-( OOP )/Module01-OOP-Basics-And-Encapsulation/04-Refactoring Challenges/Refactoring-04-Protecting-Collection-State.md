

# 🔧 Refactoring Challenge 04 — Protecting Collection State

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on an online shopping system.

The team created an `Order` class.

The developer tried to apply encapsulation:

> "The list is private, so nobody can modify it directly."

However, bugs started appearing:

* Items disappear from orders.
* External code adds invalid products.
* Business rules are bypassed.
* Paid orders are modified.

Your task:

Protect the internal collection state.

---

# 🔴 Original Code

```csharp id="w7m2kp"
using System.Collections.Generic;


public class Order
{
    private readonly List<Product> products =
        new();



    public int Id { get; }



    public List<Product> Products
    {
        get
        {
            return products;
        }
    }



    public Order(int id)
    {
        Id = id;
    }



    public void AddProduct(Product product)
    {
        products.Add(product);
    }
}
```

---

# Product Class

```csharp id="2x9m4q"
public class Product
{
    public string Name { get; set; }

    public decimal Price { get; set; }
}
```

---

# Example Usage

```csharp id="9q5m1x"
Order order =
    new Order(100);



order.AddProduct(
    new Product
    {
        Name = "Laptop",
        Price = 2000
    });



order.Products.Clear();
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Internal Collection Is Exposed

The field is private:

```csharp
private readonly List<Product> products;
```

Looks good.

But the property returns:

```csharp
public List<Product> Products
```

The caller receives the actual list.

---

External code can do:

```csharp
order.Products.Clear();
```

The order loses control.

---

# ❌ Problem 2 — Readonly Does Not Mean Immutable

Many developers misunderstand:

```csharp
readonly List<Product> products;
```

It means:

✅ The reference cannot be replaced.

It does NOT mean:

❌ The list cannot change.

Example:

Allowed:

```csharp
products.Add(product);
```

Not allowed:

```csharp
products = new List<Product>();
```

---

# ❌ Problem 3 — Business Rules Can Be Bypassed

Imagine future requirements:

```text
Paid orders cannot be modified.

Maximum 20 items per order.

Product validation required.
```

But external code can do:

```csharp
order.Products.Add(product);
```

All rules are bypassed.

---

# ❌ Problem 4 — Product Also Has Weak Encapsulation

Current:

```csharp
public decimal Price {get;set;}
```

Allows:

```csharp
product.Price = -500;
```

Invalid product.

---

# 🧠 Senior Engineer Thinking

A senior engineer asks:

---

## Question 1

Who owns the products?

Answer:

```text
Order
```

The order manages its items.

---

## Question 2

Who should control adding products?

Answer:

```text
Order
```

Because adding a product may require rules.

---

## Question 3

Should callers modify internal collections?

Answer:

No.

They should request operations.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Keep collection private.

---

## Step 2

Expose read-only access.

---

## Step 3

Control modifications through methods.

---

## Step 4

Protect product state.

---

# ✅ Refactored Code

---

# Product

```csharp
using System;


public class Product
{
    public string Name { get; }

    public decimal Price { get; }



    public Product(
        string name,
        decimal price)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Product name required.");
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
    private readonly List<Product> products =
        new();



    public int Id { get; }



    public IReadOnlyList<Product> Products
        => products;



    public Order(int id)
    {
        Id = id;
    }



    public void AddProduct(Product product)
    {
        if(product == null)
        {
            throw new ArgumentNullException(
                nameof(product));
        }


        products.Add(product);
    }



    public void RemoveProduct(Product product)
    {
        products.Remove(product);
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
        Order order =
            new Order(100);



        Product product =
            new Product(
                "Laptop",
                2000);



        order.AddProduct(product);



        Console.WriteLine(
            order.Products.Count);
    }
}
```

---

# Output

```text
1
```

---

# Invalid Usage

```csharp
order.Products.Clear();
```

Compilation Error:

```text
'IReadOnlyList<Product>' does not contain a definition for 'Clear'
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Order

Private List

       ↓

Returns actual List

       ↓

External modification
```

---

# After

```text
Order

Private List

       ↓

Read-only view

       ↓

Controlled methods
```

---

# Why Use IReadOnlyList?

Before:

```csharp
public List<Product> Products
```

Allows:

```text
Add()

Remove()

Clear()

Insert()
```

---

After:

```csharp
public IReadOnlyList<Product> Products
```

Allows:

```text
Read

Count

Access items
```

but not modification.

---

# Why Is This Important?

Imagine:

```text
Order Status = Paid
```

Business rule:

```text
Paid order cannot change.
```

Without protection:

```csharp
order.Products.Add(product);
```

The rule is broken.

---

# Why Does Order Need AddProduct()?

Because adding products is not just a list operation.

Future rules:

```text
Check stock

Check maximum quantity

Check order status

Apply discounts
```

all belong near the owner.

---

# 🎤 Interview Discussion

---

## Q1: Why is returning a private List dangerous?

### Answer:

Because it exposes the internal reference and allows external code to modify object state directly.

---

## Q2: What is the difference between readonly and immutable?

### Answer:

`readonly` prevents changing the reference.

It does not prevent modifying the object's contents.

---

## Q3: How do you protect collections in C#?

### Answer:

Keep the collection private and expose a read-only interface:

```csharp
private List<T> items;

public IReadOnlyList<T> Items => items;
```

---

## Q4: Why should objects control their collections?

### Answer:

Because the object owns the rules related to those collections.

---

# 🧠 Refactoring Checklist

```text
☑ Is the collection private?

☑ Is the actual List exposed?

☑ Can external code bypass rules?

☑ Are modifications controlled?

☑ Are collection elements protected?
```

---

# 🏁 Key Takeaways

1. Private collections can still leak state.
2. Returning mutable references breaks encapsulation.
3. Use read-only views for external access.
4. Objects should control modifications to owned data.
5. Encapsulation protects business rules, not only variables.
6. Ownership is a fundamental OOP concept.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 04 Completed ✅
</p>

---

