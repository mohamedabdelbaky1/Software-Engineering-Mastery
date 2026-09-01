
# 🧩 Exercise 19 — Module 01 Final Assessment

## Food Delivery Domain System

> **Module:** OOP Basics & Encapsulation
> **Difficulty:** 🔴 Final Challenge
> **Language:** C#

---

# 🎯 Objective

Build a complete object-oriented domain model for a food delivery system.

This exercise evaluates your understanding of:

* Classes and Objects
* State and Behavior
* Constructors
* Access Modifiers
* Encapsulation
* Invariants
* Controlled State Transitions
* Collection Protection
* Domain Modeling

---

# 🏢 Real-World Scenario

You are building the core domain of a food delivery application similar to Uber Eats.

The system contains:

* Customers
* Restaurants
* Orders
* Order Items
* Payments
* Delivery

The system must protect business rules and prevent invalid states.

---

# 📌 Business Requirements

## Customer

A customer has:

```
Id
Name
Orders
```

Rules:

* Customer orders cannot be modified externally.
* Customer information cannot be invalid.

---

## Restaurant

A restaurant has:

```
Id
Name
Availability Status
Menu Items
```

Rules:

* Unavailable restaurants cannot accept orders.
* Menu cannot be modified externally.

---

## Order

An order has:

```
Id
Customer
Restaurant
Items
Status
Total Price
```

Rules:

* Order cannot be empty.
* Items cannot be changed after confirmation.
* Paid orders cannot be modified.
* Delivered orders cannot be cancelled.

---

## Order Lifecycle

```
Created
   |
   v
Confirmed
   |
   v
Preparing
   |
   v
ReadyForDelivery
   |
   v
Delivered


Created
   |
   v
Cancelled
```

---

## Payment

Rules:

* Payment only happens after order confirmation.
* Payment amount cannot be negative.

---

## Delivery

Rules:

* Delivery starts only when order is ready.

---

# 🧠 Engineering Analysis

Before coding:

## Main Objects

From the requirements:

```
Customer

Restaurant

Order

OrderItem

Payment

Delivery
```

---

# Responsibility Assignment

## Customer

Owns:

```
Customer information
Customer orders
```

---

## Restaurant

Owns:

```
Restaurant availability
Menu
```

---

## Order

Owns:

```
Order lifecycle
Items
Order rules
```

---

## Payment

Owns:

```
Payment state
```

---

## Delivery

Owns:

```
Delivery process
```

---

# ❌ Bad Design Example

```csharp
public class FoodDeliverySystem
{
    public List<string> Orders;

    public List<string> Restaurants;


    public void ChangeStatus()
    {

    }


    public void ProcessPayment()
    {

    }


    public void Deliver()
    {

    }
}
```

---

# Problems

## 1. God Class

One class controls everything.

---

## 2. No Encapsulation

Any code can modify data.

---

## 3. No Domain Responsibility

Objects are only containers.

---

# ✅ Expected Design

Architecture:

```
Customer
    |
    |
    v
Order
   |
   +------------+
   |            |
Restaurant   Payment
   |
Delivery
```

---

# 💻 Solution

## Order Status

```csharp
public enum OrderStatus
{
    Created,
    Confirmed,
    Preparing,
    ReadyForDelivery,
    Delivered,
    Cancelled
}
```

---

# Restaurant

```csharp
public class Restaurant
{
    public int Id { get; }

    public string Name { get; }

    public bool IsAvailable { get; private set; }


    public Restaurant(
        int id,
        string name)
    {
        Id = id;
        Name = name;

        IsAvailable = true;
    }


    public void Disable()
    {
        IsAvailable = false;
    }


    public void Enable()
    {
        IsAvailable = true;
    }
}
```

---

# Customer

```csharp
using System.Collections.Generic;


public class Customer
{
    private readonly List<Order> orders = new();


    public int Id { get; }

    public string Name { get; }


    public IReadOnlyList<Order> Orders
        => orders;



    public Customer(
        int id,
        string name)
    {
        Id = id;
        Name = name;
    }


    public void AddOrder(Order order)
    {
        orders.Add(order);
    }
}
```

---

# Order Item

```csharp
public class OrderItem
{
    public string Name { get; }

    public int Quantity { get; }

    public decimal Price { get; }



    public OrderItem(
        string name,
        int quantity,
        decimal price)
    {
        if(quantity <= 0)
            throw new ArgumentException(
                "Invalid quantity");


        if(price < 0)
            throw new ArgumentException(
                "Invalid price");


        Name = name;
        Quantity = quantity;
        Price = price;
    }


    public decimal Total()
    {
        return Quantity * Price;
    }
}
```

---

# Order

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class Order
{
    private readonly List<OrderItem> items = new();


    public int Id { get; }

    public Customer Customer { get; }

    public Restaurant Restaurant { get; }


    public OrderStatus Status { get; private set; }


    public IReadOnlyList<OrderItem> Items
        => items;


    public decimal TotalPrice =>
        items.Sum(x => x.Total());



    public Order(
        int id,
        Customer customer,
        Restaurant restaurant)
    {
        if(customer == null)
            throw new ArgumentNullException();


        if(restaurant == null)
            throw new ArgumentNullException();


        Id = id;

        Customer = customer;

        Restaurant = restaurant;

        Status = OrderStatus.Created;
    }



    public void AddItem(OrderItem item)
    {
        if(Status != OrderStatus.Created)
        {
            throw new InvalidOperationException(
                "Cannot modify order.");
        }


        items.Add(item);
    }



    public void Confirm()
    {
        if(items.Count == 0)
        {
            throw new InvalidOperationException(
                "Order is empty.");
        }


        if(!Restaurant.IsAvailable)
        {
            throw new InvalidOperationException(
                "Restaurant unavailable.");
        }


        Status = OrderStatus.Confirmed;
    }



    public void StartPreparing()
    {
        if(Status != OrderStatus.Confirmed)
            throw new InvalidOperationException();


        Status = OrderStatus.Preparing;
    }



    public void Ready()
    {
        if(Status != OrderStatus.Preparing)
            throw new InvalidOperationException();


        Status = OrderStatus.ReadyForDelivery;
    }



    public void Deliver()
    {
        if(Status != OrderStatus.ReadyForDelivery)
            throw new InvalidOperationException();


        Status = OrderStatus.Delivered;
    }



    public void Cancel()
    {
        if(Status == OrderStatus.Delivered)
        {
            throw new InvalidOperationException(
                "Delivered order cannot cancel.");
        }


        Status = OrderStatus.Cancelled;
    }
}
```

---

# Payment

```csharp
public class Payment
{
    public decimal Amount { get; }

    public bool IsPaid { get; private set; }



    public Payment(decimal amount)
    {
        if(amount < 0)
            throw new ArgumentException();


        Amount = amount;
    }



    public void Pay(Order order)
    {
        if(order.Status != OrderStatus.Confirmed)
        {
            throw new InvalidOperationException(
                "Order must be confirmed.");
        }


        IsPaid = true;
    }
}
```

---

# Delivery

```csharp
public class Delivery
{
    public string DriverName { get; }


    public bool Started { get; private set; }



    public Delivery(string driverName)
    {
        DriverName = driverName;
    }



    public void Start(Order order)
    {
        if(order.Status != 
           OrderStatus.ReadyForDelivery)
        {
            throw new InvalidOperationException(
                "Order is not ready.");
        }


        Started = true;
    }
}
```

---

# 🧪 Test Application

```csharp
public class Program
{
    public static void Main()
    {

        Customer customer =
            new Customer(
                1,
                "Mohamed");



        Restaurant restaurant =
            new Restaurant(
                1,
                "Pizza House");



        Order order =
            new Order(
                100,
                customer,
                restaurant);



        order.AddItem(
            new OrderItem(
                "Pizza",
                2,
                100));



        customer.AddOrder(order);



        order.Confirm();


        Payment payment =
            new Payment(
                order.TotalPrice);


        payment.Pay(order);



        order.StartPreparing();


        order.Ready();


        Delivery delivery =
            new Delivery(
                "Ahmed");


        delivery.Start(order);


        order.Deliver();



        Console.WriteLine(
            order.Status);

    }
}
```

---

# Output

```
Delivered
```

---

# 🔍 Solution Explanation

## Why Order Controls Status?

Because:

```
Order owns order lifecycle
```

Only Order knows:

```
Created
Confirmed
Preparing
Delivered
```

---

## Why Items Are Private?

Because external code should not do:

```csharp
order.Items.Add(item);
```

This bypasses rules.

---

## Why TotalPrice Is Calculated?

Because storing:

```csharp
TotalPrice
```

creates duplicated state.

Example:

```
Items = 500

TotalPrice = 700
```

Which one is correct?

---

## Why Payment Is Separate?

Because:

```
Order responsibility:
Order lifecycle

Payment responsibility:
Money transaction
```

---

# 🏆 Module 01 Completion Skills

After finishing this exercise, you should be able to:

✅ Design classes from requirements
✅ Assign responsibilities
✅ Protect object state
✅ Build valid objects
✅ Use constructors correctly
✅ Encapsulate collections
✅ Model lifecycle transitions
✅ Explain OOP decisions in interviews

---


