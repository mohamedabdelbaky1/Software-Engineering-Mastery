

# Lesson 10 — Polymorphism Design Patterns and Real-World Usage

> **Module:** Inheritance and Polymorphism
> **Topic:** Applying Polymorphism in Real Software Design
> **Language:** C#
> **Focus:** Using Polymorphism to Build Flexible and Extensible Systems

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* How polymorphism is used in professional software systems.
* Why polymorphism is more than just using `virtual` and `override`.
* How polymorphism improves software extensibility.
* How to remove conditional logic using polymorphic design.
* Introduction to the Strategy Pattern.
* How large systems depend on polymorphic behavior.
* Common architecture mistakes related to polymorphism.
* How FAANG-level systems use polymorphism.

---

# 1. Introduction — Polymorphism as a Design Tool

In previous lessons, we learned the technical side of polymorphism:

* `virtual`
* `override`
* Base references
* Derived objects
* Runtime dispatch

However, professional developers do not use polymorphism only because the language supports it.

They use it because it solves a design problem.

The main goal:

```text
Allow the system to support different behaviors
without changing existing code.
```

---

# 2. Polymorphism Beyond Inheritance

Many beginners think:

```text
Polymorphism = Override a method
```

But this is only the mechanism.

The real idea is:

```text
The caller should depend on a common behavior,
not on specific implementations.
```

---

Example:

Bad design:

```csharp
public class OrderService
{
    public void Pay(string paymentType)
    {
        if(paymentType == "CreditCard")
        {
            // Credit card logic
        }
        else if(paymentType == "PayPal")
        {
            // PayPal logic
        }
        else if(paymentType == "Cash")
        {
            // Cash logic
        }
    }
}
```

The service knows every payment type.

---

Better design:

```csharp
public class OrderService
{
    public void Pay(Payment payment)
    {
        payment.Process();
    }
}
```

Now:

```text
OrderService
      |
      |
    Payment

      |
------------------

CreditCardPayment

PayPalPayment

CashPayment
```

The service does not care about the implementation.

---

# 3. The Open/Closed Principle Connection

Polymorphism is strongly connected to:

```text
Open/Closed Principle
```

Meaning:

> Software entities should be open for extension but closed for modification.

---

Without polymorphism:

Adding a new payment method requires changing:

```csharp
if(paymentType == "NewPayment")
```

---

With polymorphism:

Add a new class:

```csharp
public class CryptoPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Processing crypto payment");
    }
}
```

Existing code remains unchanged.

---

# 4. Example — Notification System

Imagine a notification system.

Requirements:

The application can send:

* Email notifications.
* SMS notifications.
* Push notifications.

---

## Bad Approach

```csharp
public class NotificationService
{
    public void Send(string type, string message)
    {
        if(type == "Email")
        {
            SendEmail(message);
        }
        else if(type == "SMS")
        {
            SendSMS(message);
        }
    }
}
```

Problems:

* Every new notification requires modifying this class.
* The class becomes large.
* Testing becomes harder.

---

# 5. Polymorphic Solution

Base class:

```csharp
public abstract class Notification
{
    public abstract void Send(string message);
}
```

---

Email:

```csharp
public class EmailNotification : Notification
{
    public override void Send(string message)
    {
        Console.WriteLine("Sending Email");
    }
}
```

---

SMS:

```csharp
public class SMSNotification : Notification
{
    public override void Send(string message)
    {
        Console.WriteLine("Sending SMS");
    }
}
```

---

Service:

```csharp
public class NotificationService
{
    public void Notify(Notification notification)
    {
        notification.Send("Hello");
    }
}
```

---

Adding:

```text
PushNotification
WhatsAppNotification
SlackNotification
```

does not require changing:

```text
NotificationService
```

---

# 6. Strategy Pattern Introduction

One of the most common uses of polymorphism is:

```text
Strategy Pattern
```

The idea:

> Define multiple interchangeable behaviors and choose one at runtime.

---

Example:

Shipping system.

Different shipping methods:

```text
ShippingStrategy

        |
--------------------

AirShipping

SeaShipping

GroundShipping
```

---

Base:

```csharp
public abstract class ShippingStrategy
{
    public abstract decimal CalculateCost(decimal weight);
}
```

---

Air shipping:

```csharp
public class AirShipping : ShippingStrategy
{
    public override decimal CalculateCost(decimal weight)
    {
        return weight * 10;
    }
}
```

---

Sea shipping:

```csharp
public class SeaShipping : ShippingStrategy
{
    public override decimal CalculateCost(decimal weight)
    {
        return weight * 3;
    }
}
```

---

Usage:

```csharp
ShippingStrategy strategy;

strategy = new AirShipping();

Console.WriteLine(strategy.CalculateCost(20));
```

The algorithm changes without changing the client code.

---

# 7. Polymorphism in Large Systems

Large applications contain many changing behaviors.

Examples:

---

## Payment System

```text
Payment

 |
----------------

CreditCard

PayPal

BankTransfer

Crypto
```

---

## Logging System

```text
Logger

 |
----------------

FileLogger

DatabaseLogger

CloudLogger
```

---

## Authentication System

```text
AuthenticationProvider

 |
----------------

GoogleAuth

FacebookAuth

MicrosoftAuth
```

---

The main application depends on:

```text
Common behavior
```

not:

```text
Specific implementation
```

---

# 8. Polymorphism with Collections

A very common professional pattern:

```csharp
List<Payment> payments =
new List<Payment>()
{
    new CreditCardPayment(),
    new PayPalPayment(),
    new CashPayment()
};


foreach(Payment payment in payments)
{
    payment.Process();
}
```

The loop does not know:

* Credit card rules.
* PayPal rules.
* Cash rules.

Each object handles itself.

---

# 9. Avoiding Conditional Explosion

A common code smell:

```csharp
if(type == "A")
{

}
else if(type == "B")
{

}
else if(type == "C")
{

}
```

When this grows, the design usually needs polymorphism.

---

Instead of:

```text
Ask the object what it is
```

Prefer:

```text
Tell the object what to do
```

---

Bad:

```csharp
if(employee.Type == "Developer")
{
    employee.WriteCode();
}
```

---

Better:

```csharp
employee.Work();
```

---

# 10. Common Polymorphism Mistakes

---

## Mistake 1 — Creating Empty Base Classes

Bad:

```csharp
public class Animal
{

}
```

with no shared behavior.

Inheritance should represent meaningful common behavior.

---

## Mistake 2 — Putting All Logic in the Parent

Bad:

```csharp
public class Payment
{
    public void Process()
    {
        if(type == "Card")
        {

        }
    }
}
```

The parent should not control every child.

---

## Mistake 3 — Using Inheritance When Composition Is Better

Not every difference requires inheritance.

Sometimes objects should contain other objects.

---

## Mistake 4 — Too Many Levels of Inheritance

Example:

```text
Object

 ↓

Entity

 ↓

Person

 ↓

Employee

 ↓

Developer

 ↓

SeniorDeveloper
```

Deep hierarchies become difficult to maintain.

---

# 11. FAANG-Level Thinking

A common interview question:

> How would you design a system that supports future changes?

Weak answer:

```text
Add more if statements.
```

Strong answer:

```text
Create a common abstraction and allow new implementations through polymorphism.
```

---

Example:

Design a payment system.

Future requirements:

* New payment methods.
* Different validation rules.
* Different currencies.

A scalable design:

```text
Payment

 |
-------------------

CardPayment

WalletPayment

BankPayment
```

The system grows by adding classes.

---

# 12. When NOT To Use Polymorphism

Polymorphism is powerful, but not always needed.

Avoid it when:

* There is no real variation.
* The hierarchy is artificial.
* The behavior is unlikely to change.

Example:

Bad:

```text
Color

 |

Red

Blue

Green
```

if they have no different behavior.

---

# 🧠 Interview Questions

## Q1

Why is polymorphism considered a design principle?

### Answer:

Because it allows systems to support different behaviors without modifying existing code.

---

## Q2

How does polymorphism reduce conditional statements?

### Answer:

The object handles its own behavior instead of external code checking its type.

---

## Q3

What is the Strategy Pattern?

### Answer:

A design pattern that allows different algorithms or behaviors to be selected at runtime using polymorphism.

---

## Q4

Why is polymorphism important in large systems?

### Answer:

Because large systems constantly add new behaviors, and polymorphism allows extension without breaking existing code.

---

## Q5

What is the relationship between polymorphism and Open/Closed Principle?

### Answer:

Polymorphism allows adding new implementations without modifying existing classes.

---

# 📝 Practice Questions

1. Explain polymorphism as a design concept.
2. Why are if/else chains often replaced by polymorphism?
3. Explain Strategy Pattern using an example.
4. Design a notification system using polymorphism.
5. How does polymorphism support scalability?
6. When should you avoid polymorphism?
7. Why is composition sometimes better than inheritance?

---

# ✅ Key Takeaways

```text
Polymorphism is not only a language feature.

It is a design technique.


Good polymorphic design:

- Reduces conditional logic.
- Improves extensibility.
- Separates behavior from implementation.
- Makes systems easier to maintain.


Professional systems depend on:

Common behavior

+

Multiple implementations
```

