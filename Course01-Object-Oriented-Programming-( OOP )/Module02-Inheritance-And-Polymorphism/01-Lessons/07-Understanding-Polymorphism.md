
# Lesson 07 — Understanding Polymorphism

> **Module:** Inheritance and Polymorphism
> **Topic:** Polymorphism Fundamentals
> **Language:** C#
> **Focus:** Understanding Polymorphism as a Design Concept

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* What polymorphism really means.
* Why polymorphism is one of the most important OOP concepts.
* The difference between compile-time and runtime polymorphism.
* How polymorphism works with inheritance.
* How polymorphism changes the way we design software.
* Why polymorphism reduces conditional logic.
* How professional developers use polymorphism in real systems.

---

# 1. Introduction to Polymorphism

The word **Polymorphism** comes from two words:

```text
Poly = Many

Morph = Forms
```

Meaning:

```text
Many Forms
```

In programming:

> Polymorphism allows the same operation to behave differently depending on the object that receives it.

---

Example:

Imagine a method:

```csharp
ProcessPayment();
```

Different payment types behave differently:

```text
Credit Card Payment

        ↓

ProcessPayment()
```

```text
Cash Payment

        ↓

ProcessPayment()
```

```text
Bank Transfer

        ↓

ProcessPayment()
```

Same action:

```text
ProcessPayment()
```

Different behavior.

---

# 2. The Problem Without Polymorphism

Imagine we build a payment system.

We have:

```text
Payment Types:

1. Credit Card

2. PayPal

3. Cash
```

A beginner solution:

```csharp
public void ProcessPayment(string type)
{
    if(type == "CreditCard")
    {
        Console.WriteLine("Processing credit card");
    }
    else if(type == "PayPal")
    {
        Console.WriteLine("Processing PayPal");
    }
    else if(type == "Cash")
    {
        Console.WriteLine("Processing cash");
    }
}
```

This works.

But problems appear.

---

# 3. Problems With Conditional Logic

## Problem 1 — Growing Complexity

Today:

```text
3 payment types
```

Tomorrow:

```text
20 payment types
```

The method becomes:

```csharp
if(...)
else if(...)
else if(...)
else if(...)
else if(...)
```

---

## Problem 2 — Violates Open for Extension

Every time we add a new payment type:

Example:

```text
Apple Pay
Google Pay
Crypto
```

We must modify existing code.

---

## Problem 3 — The Method Knows Too Much

The payment processor knows:

* How credit cards work.
* How cash works.
* How PayPal works.

Too many responsibilities.

---

# 4. Polymorphism Solution

Instead of asking:

```text
"What type is this object?"
```

we tell the object:

```text
"Perform your behavior."
```

---

Example:

Base class:

```csharp
public class Payment
{
    public virtual void Process()
    {
        Console.WriteLine("Processing payment");
    }
}
```

---

Credit Card:

```csharp
public class CreditCardPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Processing credit card payment");
    }
}
```

---

Cash:

```csharp
public class CashPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Processing cash payment");
    }
}
```

---

Now:

```csharp
Payment payment;

payment = new CreditCardPayment();

payment.Process();


payment = new CashPayment();

payment.Process();
```

Output:

```text
Processing credit card payment

Processing cash payment
```

Same method:

```csharp
payment.Process();
```

Different behavior.

This is polymorphism.

---

# 5. The Core Idea of Polymorphism

Without polymorphism:

```text
Controller decides behavior
```

Example:

```csharp
if(paymentType == "Card")
{
    CardPayment();
}
```

---

With polymorphism:

```text
Object decides behavior
```

Example:

```csharp
payment.Process();
```

The object knows how to process itself.

---

# 6. Polymorphism Through Inheritance

In C#, runtime polymorphism usually happens through:

```text
Base reference

+

Derived object
```

Example:

```csharp
Payment payment = new CreditCardPayment();
```

The variable type:

```text
Payment
```

The actual object:

```text
CreditCardPayment
```

When calling:

```csharp
payment.Process();
```

C# executes:

```text
CreditCardPayment.Process()
```

---

# 7. Compile-Time vs Runtime Polymorphism

Polymorphism has two main types:

```text
1. Compile-Time Polymorphism

2. Runtime Polymorphism
```

---

# Part 1 — Compile-Time Polymorphism

Compile-time polymorphism means:

> The compiler decides which method to call before the program runs.

The common example:

```text
Method Overloading
```

---

## Method Overloading

Example:

```csharp
public class Printer
{
    public void Print(string text)
    {
        Console.WriteLine(text);
    }


    public void Print(int number)
    {
        Console.WriteLine(number);
    }
}
```

Usage:

```csharp
Printer printer = new Printer();

printer.Print("Hello");

printer.Print(100);
```

The compiler knows which method to call.

---

How?

Based on:

```text
Method name

+

Parameters
```

---

Example:

```csharp
Print(string)
```

and:

```csharp
Print(int)
```

are different methods.

---

# Part 2 — Runtime Polymorphism

Runtime polymorphism means:

> The decision is made while the program is running.

It uses:

* Inheritance.
* Virtual methods.
* Override.

Example:

```csharp
public class Animal
{
    public virtual void MakeSound()
    {
        Console.WriteLine("Animal sound");
    }
}
```

Dog:

```csharp
public class Dog : Animal
{
    public override void MakeSound()
    {
        Console.WriteLine("Bark");
    }
}
```

Cat:

```csharp
public class Cat : Animal
{
    public override void MakeSound()
    {
        Console.WriteLine("Meow");
    }
}
```

---

Usage:

```csharp
Animal animal;


animal = new Dog();

animal.MakeSound();


animal = new Cat();

animal.MakeSound();
```

Output:

```text
Bark

Meow
```

---

# 8. Real-World Example — Notification System

Imagine:

```text
Notification

       |

----------------

EmailNotification

SMSNotification

PushNotification
```

Base:

```csharp
public class Notification
{
    public virtual void Send()
    {
        Console.WriteLine("Sending notification");
    }
}
```

Email:

```csharp
public class EmailNotification : Notification
{
    public override void Send()
    {
        Console.WriteLine("Sending Email");
    }
}
```

SMS:

```csharp
public class SMSNotification : Notification
{
    public override void Send()
    {
        Console.WriteLine("Sending SMS");
    }
}
```

---

Now:

```csharp
List<Notification> notifications =
new List<Notification>()
{
    new EmailNotification(),
    new SMSNotification()
};


foreach(Notification notification in notifications)
{
    notification.Send();
}
```

Output:

```text
Sending Email

Sending SMS
```

The loop does not know the exact type.

It only knows:

```text
Notification
```

This is the power of polymorphism.

---

# 9. Why Polymorphism Is Important in Large Systems

Large applications contain many variations.

Examples:

## E-Commerce

```text
Discount

  |

----------------

PercentageDiscount

FixedDiscount

SeasonalDiscount
```

---

## Shipping

```text
ShippingMethod

 |

----------------

AirShipping

SeaShipping

GroundShipping
```

---

## Logging

```text
Logger

 |

----------------

FileLogger

DatabaseLogger

CloudLogger
```

---

The main code works with the parent type.

It does not care about every implementation.

---

# 10. Common Beginner Mistakes

---

## Mistake 1 — Checking Types Everywhere

Bad:

```csharp
if(payment is CreditCardPayment)
{

}
else if(payment is CashPayment)
{

}
```

This removes the benefit of polymorphism.

---

## Mistake 2 — Using Polymorphism Without a Real Difference

Example:

```csharp
Dog : Animal
```

but Dog has exactly the same behavior.

No benefit.

---

## Mistake 3 — Putting All Logic in Parent Class

Bad:

```csharp
public class Payment
{
    if(type == "Card")
    {

    }
}
```

The parent should not manage every child behavior.

---

# 11. Senior Engineer Thinking

A junior developer asks:

> "How can I call different code?"

A senior developer asks:

> "How can I design objects so the correct behavior happens automatically?"

---

Good polymorphic design:

```csharp
payment.Process();
```

Not:

```csharp
if(paymentType == "Card")
```

---

# 🧠 Interview Questions

## Q1

What does polymorphism mean?

### Answer:

The ability of the same operation to have different implementations depending on the object.

---

## Q2

What are the two types of polymorphism?

### Answer:

* Compile-time polymorphism.
* Runtime polymorphism.

---

## Q3

What is runtime polymorphism in C#?

### Answer:

Using inheritance with virtual and override methods where the runtime chooses the correct implementation.

---

## Q4

Why is polymorphism useful?

### Answer:

It allows flexible designs where new behaviors can be added without changing existing logic.

---

## Q5

What is the difference between overloading and overriding?

### Answer:

Overloading:

* Same method name.
* Different parameters.
* Compile-time decision.

Overriding:

* Same method signature.
* Different implementation.
* Runtime decision.

---

# 📝 Practice Questions

1. Explain the meaning of polymorphism.
2. Why does polymorphism reduce if/else statements?
3. Difference between compile-time and runtime polymorphism.
4. Explain runtime polymorphism with an example.
5. Why is this better?

```csharp
payment.Process();
```

than:

```csharp
if(type=="Card")
```

6. What role does inheritance play in polymorphism?
7. Explain reference type vs actual object type.

---

# ✅ Key Takeaways

```text
Polymorphism means:

One interface/operation,
many possible behaviors.


Compile-Time:

Method Overloading


Runtime:

Inheritance

virtual

override


Good polymorphism:

Object decides behavior.


Bad design:

External code decides every behavior.
```

