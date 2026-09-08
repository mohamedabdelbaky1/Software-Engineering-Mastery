

# Lesson 09 — Runtime Polymorphism Deep Dive in C#

> **Module:** Inheritance and Polymorphism
> **Topic:** Runtime Polymorphism and Dynamic Behavior
> **Language:** C#
> **Focus:** Understanding How C# Chooses Methods at Runtime

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* What runtime polymorphism really means.
* How runtime method dispatch works.
* The relationship between inheritance and polymorphism.
* How base references can point to derived objects.
* How C# decides which overridden method executes.
* The role of `virtual`, `override`, and `base`.
* How polymorphism is implemented internally.
* The difference between static binding and dynamic binding.
* How professional systems use runtime polymorphism.
* Common runtime polymorphism mistakes.

---

# 1. Introduction to Runtime Polymorphism

Runtime polymorphism is one of the most important concepts in Object-Oriented Programming.

It allows a program to decide which behavior should execute while the application is running.

The decision is based on:

```text
The actual object type
```

not:

```text
The reference variable type
```

---

Example:

```csharp
Employee employee = new Developer();

employee.Work();
```

The variable type is:

```text
Employee
```

But the actual object is:

```text
Developer
```

At runtime, C# chooses:

```text
Developer.Work()
```

---

# 2. Why Do We Need Runtime Polymorphism?

Without runtime polymorphism, code often depends on conditions.

Example:

```csharp
public void StartWork(Employee employee)
{
    if(employee is Developer)
    {
        Console.WriteLine("Writing code");
    }
    else if(employee is Manager)
    {
        Console.WriteLine("Managing team");
    }
}
```

This approach has problems:

* The method knows every employee type.
* Adding new types requires modifying existing code.
* The code becomes difficult to maintain.

---

With polymorphism:

```csharp
employee.Work();
```

The object itself decides the behavior.

---

# 3. The Basic Runtime Polymorphism Structure

Runtime polymorphism requires:

## 1. Base Class

Defines common behavior.

## 2. Virtual Method

Allows replacement.

## 3. Derived Class

Overrides the behavior.

---

Example:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Employee working");
    }
}
```

---

Derived class:

```csharp
public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Developer writing code");
    }
}
```

---

Usage:

```csharp
Employee employee = new Developer();

employee.Work();
```

Output:

```text
Developer writing code
```

---

# 4. Reference Type vs Object Type

This is the foundation of runtime polymorphism.

Consider:

```csharp
Employee employee = new Developer();
```

There are two different types.

---

# 4.1 Reference Type

The type on the left side:

```csharp
Employee
```

It controls:

* Which members you can access.
* What the compiler allows.

Example:

```csharp
employee.Work();
```

Allowed because Employee has Work().

---

# 4.2 Object Type

The type created with `new`:

```csharp
Developer
```

It controls:

* Which overridden implementation runs.

---

Visual representation:

```text
Reference:

Employee


Object:

Developer
```

---

# 5. Method Dispatch Process

When this code executes:

```csharp
employee.Work();
```

C# performs several steps.

---

## Step 1

Compiler checks:

Does Employee have Work()?

Yes.

The code compiles.

---

## Step 2

Runtime checks:

What is the actual object?

```text
Developer
```

---

## Step 3

Runtime executes:

```text
Developer.Work()
```

---

This process is called:

```text
Dynamic Dispatch
```

or:

```text
Late Binding
```

---

# 6. Virtual Method Dispatch

The `virtual` keyword tells C#:

> This method can have different implementations in derived classes.

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

---

Derived classes:

```csharp
public class Dog : Animal
{
    public override void MakeSound()
    {
        Console.WriteLine("Bark");
    }
}
```

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

Now:

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

Same method call.

Different behavior.

---

# 7. Polymorphism with Collections

This is where polymorphism becomes extremely powerful.

Example:

```csharp
List<Employee> employees =
new List<Employee>()
{
    new Developer(),
    new Manager(),
    new Designer()
};
```

Now:

```csharp
foreach(Employee employee in employees)
{
    employee.Work();
}
```

The loop does not know:

* Developer
* Manager
* Designer

It only knows:

```text
Employee
```

Each object provides its own behavior.

---

# 8. Real-World Example — Notification System

Imagine:

```text
Notification

        |

---------------------

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

---

Email:

```csharp
public class EmailNotification : Notification
{
    public override void Send()
    {
        Console.WriteLine("Sending email");
    }
}
```

---

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

Usage:

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
Sending email

Sending SMS
```

---

# 9. Static Binding vs Dynamic Binding

## Static Binding

Decision happens at compile time.

Examples:

* Method overloading.
* Normal method calls.

---

## Dynamic Binding

Decision happens at runtime.

Examples:

* Method overriding.

---

Comparison:

| Feature       | Static Binding   | Dynamic Binding |
| ------------- | ---------------- | --------------- |
| Decision Time | Compile Time     | Runtime         |
| Example       | Overloading      | Overriding      |
| Based On      | Method signature | Object type     |

---

# 10. Runtime Polymorphism and Extensibility

One of the biggest advantages:

You can add new behavior without changing existing code.

Example:

Existing:

```text
Payment

 |

CreditCardPayment
CashPayment
```

Later:

```text
CryptoPayment
```

Add:

```csharp
public class CryptoPayment : Payment
{
    public override void Process()
    {

    }
}
```

Existing code:

```csharp
payment.Process();
```

does not change.

---

# 11. Common Mistakes

---

## Mistake 1 — Forgetting virtual

Wrong:

```csharp
public void Work()
{

}
```

Child cannot override it.

---

## Mistake 2 — Using Type Checking Instead of Polymorphism

Bad:

```csharp
if(employee is Developer)
{

}
```

Repeated type checks usually indicate missing polymorphism.

---

## Mistake 3 — Overusing Base References

Example:

```csharp
Employee employee = new Developer();
```

is useful.

But if you constantly cast:

```csharp
Developer developer = (Developer)employee;
```

you may have a design problem.

---

## Mistake 4 — Breaking Parent Expectations

A derived class should respect the behavior expected from the parent.

---

# 12. Senior Engineer Perspective

A junior developer thinks:

> "How do I call different methods?"

A senior developer thinks:

> "How do I design objects so the correct behavior happens automatically?"

---

Good design:

```csharp
payment.Process();
```

Not:

```csharp
if(paymentType == "CreditCard")
```

---

# 🧠 Interview Questions

## Q1

What is runtime polymorphism?

### Answer:

The ability of a program to select the correct method implementation during runtime based on the actual object type.

---

## Q2

What enables runtime polymorphism in C#?

### Answer:

Inheritance, virtual methods, and overriding.

---

## Q3

What happens here?

```csharp
Animal animal = new Dog();

animal.MakeSound();
```

### Answer:

The Dog implementation executes.

---

## Q4

What is dynamic dispatch?

### Answer:

The runtime process of selecting the correct overridden method.

---

## Q5

Why is polymorphism important?

### Answer:

It allows flexible and extensible designs where new behaviors can be added without modifying existing code.

---

# 📝 Practice Questions

1. Explain runtime polymorphism.
2. What is the difference between reference type and object type?
3. How does C# choose an overridden method?
4. What is dynamic dispatch?
5. Difference between static and dynamic binding.
6. Why are virtual and override needed?
7. Explain polymorphism using collections.
8. Why is type checking often a bad design?

---

# ✅ Key Takeaways

```text
Runtime Polymorphism:

The runtime decides behavior.

Requires:

- Inheritance
- virtual
- override


Example:

Employee employee = new Developer();

employee.Work();


The executed method depends on:

Actual Object Type


Benefits:

- Less conditional logic.
- Easier extension.
- Cleaner architecture.
```

