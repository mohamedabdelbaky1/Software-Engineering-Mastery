🧩 Exercise 03 — Designing Class Responsibilities

Course: Object-Oriented Programming (OOP)
Module: 01 — OOP Basics & Encapsulation
Exercise Level: 🟡 Design Thinking
Language: C#

🎯 Objective
Concepts Practiced

This exercise focuses on:

Class responsibility
Single responsibility thinking
Object ownership
Separating concerns
Avoiding "God Classes"
Modeling real-world entities correctly
Why This Matters

One of the biggest differences between beginner and professional developers is:

Beginners ask:

"What data should this class contain?"

Experienced developers ask:

"What responsibility should this class own?"

A class should not exist just because we can create one.

A class should represent a meaningful responsibility in the system.

🏢 Real-World Scenario
Online Shopping System

You are designing an e-commerce application.

The system needs to manage customer orders.

Initially, a developer created this class:

OrderManager

The class currently does everything:

Creates orders
Calculates prices
Saves orders
Sends emails
Processes payments
Generates reports

The system works.

But the design is becoming difficult to maintain.

Your task is to redesign the responsibilities.

📌 Requirements

The system needs the following responsibilities:

Order Management

The system should represent:

Order information
Order items
Order status
Price Calculation

The system should calculate:

Item totals
Order total
Payment Processing

The system should handle:

Payment operation
Payment result
Notification

The system should send:

Confirmation messages
Customer notifications
Data Persistence

The system should save:

Orders
Customer data
🧠 Engineering Focus

Before writing code, think about responsibility ownership.

Question 1
Does everything belong inside Order?

A beginner may create:

Order

- Items
- CalculateTotal()
- Save()
- SendEmail()
- ProcessPayment()

But ask:

Does an order know how to:

send emails?

No.

Email is a separate responsibility.

Question 2
Who owns the data?

Example:

Order owns:

OrderId
Items
Status

Payment owns:

PaymentStatus
TransactionId

Notification owns:

Message
Recipient
Question 3
What changes together?

A useful design question:

If this requirement changes, which class should change?

Example:

Email provider changes:

SMTP
     ↓
SendGrid
     ↓
AWS SES

Should Order change?

No.

Therefore email logic should not live inside Order.

❌ Bad Design Example
public class OrderManager
{
    public int OrderId;

    public List<string> Items;


    public decimal CalculateTotal()
    {
        return 100;
    }


    public void SaveToDatabase()
    {
        Console.WriteLine("Saving...");
    }


    public void SendEmail()
    {
        Console.WriteLine("Sending email...");
    }


    public void ProcessPayment()
    {
        Console.WriteLine("Processing payment...");
    }
}
Why This Is Poor Design
1. Too Many Responsibilities

This class handles:

Order Domain
+
Database
+
Email
+
Payment
+
Calculation
2. Hard to Change

Imagine:

Database changes:

SQL Server
     ↓
MongoDB

Now:

OrderManager

changes.

Why?

Because unrelated responsibilities are mixed.

3. Hard to Test

Testing order logic requires:

Database setup
Email setup
Payment setup

Even when you only want to test:

CalculateTotal()
4. Low Cohesion

The methods do not naturally belong together.

✅ Expected Design Direction

Separate responsibilities.

A possible design:

Order

Responsible for:
- Order state
- Order behavior


OrderCalculator

Responsible for:
- Price calculations


PaymentService

Responsible for:
- Payments


EmailService

Responsible for:
- Notifications


OrderRepository

Responsible for:
- Saving orders
Design Relationship
                Order
                  |
        --------------------
        |                  |
        ▼                  ▼

 OrderCalculator     PaymentService


        |
        ▼

 EmailService


        |
        ▼

 OrderRepository
💻 Solution
Order Class
using System;
using System.Collections.Generic;

public class Order
{
    private readonly List<OrderItem> items = new();


    public int Id { get; }

    public string CustomerName { get; }

    public string Status { get; private set; }


    public IReadOnlyList<OrderItem> Items => items;


    public Order(
        int id,
        string customerName)
    {
        Id = id;
        CustomerName = customerName;

        Status = "Created";
    }


    public void AddItem(OrderItem item)
    {
        items.Add(item);
    }


    public void Confirm()
    {
        if (items.Count == 0)
        {
            throw new InvalidOperationException(
                "Cannot confirm empty order.");
        }

        Status = "Confirmed";
    }
}
Order Item
public class OrderItem
{
    public string Name { get; }

    public decimal Price { get; }


    public OrderItem(
        string name,
        decimal price)
    {
        Name = name;
        Price = price;
    }
}
Order Calculator
using System.Linq;

public class OrderCalculator
{
    public decimal CalculateTotal(Order order)
    {
        return order.Items.Sum(
            item => item.Price);
    }
}
Payment Service
public class PaymentService
{
    public bool ProcessPayment(decimal amount)
    {
        Console.WriteLine(
            $"Processing payment: {amount}");

        return true;
    }
}
Notification Service
public class NotificationService
{
    public void SendOrderConfirmation(
        Order order)
    {
        Console.WriteLine(
            $"Confirmation sent for order {order.Id}");
    }
}
Repository
public class OrderRepository
{
    public void Save(Order order)
    {
        Console.WriteLine(
            $"Order {order.Id} saved.");
    }
}
🧪 Test Cases
public class Program
{
    public static void Main()
    {
        Order order =
            new Order(
                1001,
                "Mohamed");


        order.AddItem(
            new OrderItem(
                "Laptop",
                500));


        order.AddItem(
            new OrderItem(
                "Mouse",
                50));


        OrderCalculator calculator =
            new OrderCalculator();


        decimal total =
            calculator.CalculateTotal(order);


        PaymentService payment =
            new PaymentService();


        payment.ProcessPayment(total);


        order.Confirm();


        NotificationService notification =
            new NotificationService();


        notification.SendOrderConfirmation(order);


        OrderRepository repository =
            new OrderRepository();


        repository.Save(order);
    }
}
Expected Output
Processing payment: 550

Confirmation sent for order 1001

Order 1001 saved.
🔍 Solution Explanation
Why Does Order Not Save Itself?

Because saving data is persistence responsibility.

Order should not know:

Database
File system
API
Storage technology
Why Does PaymentService Exist?

Payment has its own complexity:

Payment gateway
Transaction
Validation
Failure handling

It should have its own responsibility.

Why Does Order Own Items?

Because items are part of the order.

An order cannot exist meaningfully without knowing its contents.

Why Is OrderCalculator Separate?

There are multiple possible pricing rules:

Discounts
Coupons
Taxes
Membership pricing

Keeping calculation separate allows easier evolution.

💡 Senior Engineer Notes
Important Design Principle

A class should have:

One clear reason to change

Not:

One class does everything.
Real Production Considerations

A real system may introduce:

Order
OrderItem
PricingService
PaymentGateway
NotificationSender
Repository

depending on complexity.

Avoid Overengineering

Do not create:

100 tiny classes

without reason.

The goal is:

Clear responsibility boundaries

not maximum number of files.

🎤 Interview Connection
Question 1
What makes a good class?

Answer:

A good class has:

Clear responsibility
High cohesion
Low coupling
Encapsulated state
Meaningful behavior
Question 2
What is the problem with a God Class?

Answer:

A God Class has too many responsibilities, creating:

High coupling
Low maintainability
Difficult testing
Difficult changes
Question 3
How do you decide if a method belongs in a class?

Answer:

Ask:

Does this behavior naturally belong to this object's responsibility?

If not, it probably belongs elsewhere.

🧠 Engineering Reflection

Before moving forward:

1. Why should Order not send emails?

2. Why should Order not save itself?

3. What responsibility belongs to Order?

4. What happens if payment rules become complicated?

5. How does separating responsibilities make changes safer?
🏁 Key Takeaways
Classes should represent responsibilities, not random collections of data.
A class should have a clear purpose.
Related behavior should stay close to the state it manages.
Unrelated responsibilities create fragile designs.
Separating responsibilities reduces coupling.
Good OOP design starts with asking "who owns this responsibility?"
This thinking prepares you for SOLID principles, especially Single Responsibility Principle.
<p align="center"> <strong>Module 01 — OOP Basics & Encapsulation</strong><br> Exercise 03 of 19 ✅ </p> ```
