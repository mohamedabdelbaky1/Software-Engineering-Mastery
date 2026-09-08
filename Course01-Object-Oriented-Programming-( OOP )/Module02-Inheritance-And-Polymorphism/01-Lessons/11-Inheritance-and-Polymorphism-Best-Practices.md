
# Lesson 11 — Inheritance and Polymorphism Best Practices

> **Module:** Inheritance and Polymorphism\
> **Topic:** Professional Design Guidelines\
> **Language:** C#\
> **Focus:** Designing Maintainable Inheritance Hierarchies

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* How professional developers design inheritance hierarchies.
* When inheritance is appropriate and when it is not.
* The problems caused by bad inheritance design.
* The concept of the fragile base class problem.
* Introduction to the Liskov Substitution Principle.
* How polymorphism can be broken by incorrect designs.
* How to avoid common inheritance mistakes.
* Professional guidelines for using inheritance.

---

# 1. Introduction

Inheritance is a powerful feature.

However, powerful features can create problems when used incorrectly.

A beginner often thinks:

> "If two classes have something in common, they should use inheritance."

This is not always true.

Professional developers ask:

> "Does this relationship represent a true behavioral relationship?"

Before creating inheritance.

---

# 2. The Goal of Good Inheritance

Good inheritance should create:

```text
A stable and predictable hierarchy
```

The derived class should:

* Naturally represent the base class.
* Preserve expected behavior.
* Extend functionality without breaking existing code.

---

Example:

```text
        Vehicle

           |

          Car
```

A car is a vehicle.

This relationship makes sense.

---

Bad example:

```text
        Employee

           |

          Database
```

A database is not an employee.

The relationship is artificial.

---

# 3. The "Is-A" Relationship

Inheritance represents:

```text
IS-A relationship
```

Example:

```text
Dog IS-A Animal

Developer IS-A Employee

Car IS-A Vehicle
```

---

It does not represent:

```text
HAS-A relationship
```

Example:

A car:

```text
Car HAS-A Engine
```

Not:

```text
Engine IS-A Car
```

---

# 4. Inheritance vs Composition

One of the most important design decisions:

Should we use:

```text
Inheritance
```

or:

```text
Composition
```

---

## Inheritance

Represents:

```text
IS-A
```

Example:

```text
Developer → Employee
```

---

## Composition

Represents:

```text
HAS-A
```

Example:

```text
Car

has an

Engine
```

---

Example:

Bad inheritance:

```csharp
public class Car : Engine
{

}
```

A car is not an engine.

---

Correct composition:

```csharp
public class Car
{
    private Engine engine;
}
```

---

# 5. Prefer Composition Over Inheritance

A common professional principle:

> Prefer composition over inheritance when possible.

Why?

Because composition creates less dependency.

---

Inheritance creates strong coupling:

```text
Child depends on Parent
```

Changes in the parent can affect many children.

---

Composition creates flexibility:

```text
Object uses another object
```

The relationship can change more easily.

---

# 6. Fragile Base Class Problem

One of the biggest inheritance problems.

Definition:

> A change in a base class can unexpectedly break derived classes.

---

Example:

Base class:

```csharp
public class Account
{
    public virtual void Withdraw(decimal amount)
    {
        Console.WriteLine("Withdraw money");
    }
}
```

Derived class:

```csharp
public class SavingsAccount : Account
{

}
```

Everything works.

---

Later:

The base class changes:

```csharp
public virtual void Withdraw(decimal amount)
{
    ValidateBalance();

    Console.WriteLine("Withdraw money");

    LogTransaction();
}
```

Now every child inherits this behavior.

A small parent change affects many classes.

---

# 7. Avoid Deep Inheritance Hierarchies

Bad:

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

 ↓

TeamLead
```

Problems:

* Hard to understand.
* Hard to modify.
* Difficult debugging.
* Unexpected inherited behavior.

---

Prefer:

```text
Employee

 /        \

Developer  Manager
```

A shallow hierarchy is easier to maintain.

---

# 8. The Liskov Substitution Principle (LSP)

LSP is one of the SOLID principles.

Definition:

> Objects of a derived class should be replaceable with objects of the base class without breaking the application.

Meaning:

If code expects:

```csharp
Employee
```

it should work correctly with:

```csharp
Developer
```

---

Example:

Base:

```csharp
public class Employee
{
    public virtual decimal CalculateSalary()
    {
        return 5000;
    }
}
```

Derived:

```csharp
public class Developer : Employee
{
    public override decimal CalculateSalary()
    {
        return 8000;
    }
}
```

Works correctly.

---

# 9. Breaking LSP Example

Example:

```text
        Bird

          |

       Penguin
```

A bird can fly.

But penguins cannot fly.

---

Bad design:

```csharp
public class Bird
{
    public virtual void Fly()
    {

    }
}
```

Penguin:

```csharp
public class Penguin : Bird
{
    public override void Fly()
    {
        throw new Exception();
    }
}
```

Problem:

The child cannot behave like the parent.

The inheritance relationship is wrong.

---

# 10. Avoid Overriding Just for the Sake of Overriding

Bad:

```csharp
public override void Process()
{

}
```

with no meaningful behavior change.

---

Every override should answer:

> Why does this class need different behavior?

---

# 11. Keep Base Classes Focused

Bad:

```csharp
public class Employee
{
    public void WriteCode()
    {

    }

    public void ManageTeam()
    {

    }

    public void DesignUI()
    {

    }
}
```

Problem:

Not every employee does all these things.

---

Better:

```text
Employee

   |

----------------

Developer

Manager

Designer
```

---

# 12. Avoid Exposing Protected Members Too Much

Protected members are accessible by child classes.

Example:

```csharp
protected string name;
protected decimal salary;
protected string email;
```

Too many protected members create strong dependency.

---

A child class becomes dependent on parent implementation details.

---

Prefer:

```csharp
private
```

with controlled access when possible.

---

# 13. Use Sealed When Extension Is Not Allowed

Sometimes a class should not be inherited.

Example:

```csharp
public sealed class SecurityManager
{

}
```

Now:

```csharp
public class CustomSecurityManager : SecurityManager
{

}
```

is impossible.

---

Use sealed when:

* The design should not change.
* Extension creates security risks.
* The class represents a final implementation.

---

# 14. Polymorphism Best Practice

Good polymorphism:

```csharp
payment.Process();
```

The object knows what to do.

---

Bad design:

```csharp
if(paymentType == "CreditCard")
{

}
else if(paymentType == "Cash")
{

}
```

The caller should not manage every possible behavior.

---

# 15. Real-World Example — File Processing System

Requirements:

The system processes:

* PDF files.
* Excel files.
* CSV files.

---

Bad design:

```csharp
public class FileProcessor
{
    public void Process(string type)
    {
        if(type == "PDF")
        {

        }

        if(type == "Excel")
        {

        }
    }
}
```

---

Better:

```text
FileProcessor

      |

----------------

PdfProcessor

ExcelProcessor

CsvProcessor
```

Each class handles its own behavior.

---

# 16. Senior Engineer Checklist

Before using inheritance, ask:

## Question 1

Is this a true IS-A relationship?

---

## Question 2

Will the child behave correctly everywhere the parent is expected?

---

## Question 3

Will changes in the parent break many children?

---

## Question 4

Would composition provide more flexibility?

---

## Question 5

Is the hierarchy simple and understandable?

---

# 🧠 Interview Questions

## Q1

Why can inheritance become dangerous?

### Answer:

Because derived classes become tightly coupled to their parent classes.

---

## Q2

What is the fragile base class problem?

### Answer:

A change in a base class can unexpectedly affect derived classes.

---

## Q3

What is the Liskov Substitution Principle?

### Answer:

Derived classes should be replaceable with their base classes without breaking behavior.

---

## Q4

When should you use composition instead of inheritance?

### Answer:

When the relationship is HAS-A rather than IS-A or when flexibility is more important.

---

## Q5

Why avoid deep inheritance hierarchies?

### Answer:

They increase complexity and make changes harder.

---

# 📝 Practice Questions

1. Explain the difference between IS-A and HAS-A relationships.
2. When should inheritance be avoided?
3. Explain the fragile base class problem.
4. Explain Liskov Substitution Principle.
5. Why is composition often preferred?
6. What problems can deep inheritance cause?
7. When should you use sealed classes?
8. How can inheritance break polymorphism?

---

# ✅ Key Takeaways

```text
Good inheritance design requires:

- Clear IS-A relationships.
- Shallow hierarchies.
- Predictable behavior.
- Respect for LSP.
- Avoiding unnecessary coupling.


Inheritance is powerful,
but it should be used carefully.


Composition is often a better choice
when flexibility is required.
```

