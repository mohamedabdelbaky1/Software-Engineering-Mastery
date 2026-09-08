
# Lesson 01 — Why Inheritance Exists

> **Module:** Inheritance and Polymorphism  
> **Topic:** Inheritance Fundamentals  
> **Language:** C#  
> **Focus:** Object-Oriented Design Thinking

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

- Why inheritance was introduced in Object-Oriented Programming.
- The real problems inheritance tries to solve.
- Why inheritance is not just a code reuse mechanism.
- The relationship between parent and child classes.
- The meaning of the "is-a" relationship.
- How experienced engineers decide whether inheritance is appropriate.
- The advantages and risks of using inheritance.

---

# 1. What Problem Does Inheritance Solve?

Before understanding inheritance, we need to understand the problem that led to its creation.

In real software systems, we often have multiple objects that share common characteristics.

Example:

Imagine an employee management system.

We have different types of employees:

```text
Employee

 ├── Developer

 ├── Manager

 └── Designer
````

All employees have common information:

```text
Name

Employee ID

Department

Email

Work()
```

But each employee type has specialized behavior.

Developer:

```text
WriteCode()
```

Manager:

```text
ManageTeam()
```

Designer:

```text
CreateDesign()
```

---

# 2. The Problem Without Inheritance

A beginner approach is to create separate classes.

## Developer

```csharp
public class Developer
{
    public string Name { get; set; }


    public void Work()
    {
        Console.WriteLine("Writing code");
    }


    public void WriteCode()
    {
        Console.WriteLine("Creating software");
    }
}
```

---

## Manager

```csharp
public class Manager
{
    public string Name { get; set; }


    public void Work()
    {
        Console.WriteLine("Managing team");
    }


    public void ManageTeam()
    {
        Console.WriteLine("Planning tasks");
    }
}
```

---

The code works.

But we have problems.

---

# ❌ Problem 1 — Code Duplication

Both classes contain:

```csharp
public string Name { get; set; }
```

and:

```csharp
public void Work()
```

The same logic exists in multiple places.

---

# ❌ Problem 2 — Maintenance Problems

Imagine the company requires every employee to have:

```text
Phone Number

Address

Hire Date
```

Without inheritance:

You must modify:

```text
Developer

Manager

Designer

Tester

Accountant
```

Every new employee type increases the maintenance cost.

---

# ❌ Problem 3 — Missing Domain Relationship

The code does not express an important business concept:

```text
Developer is an Employee

Manager is an Employee
```

The relationship exists in reality but not in our code.

---

# 3. What Is Inheritance?

Inheritance allows one class to reuse and extend another class.

The class providing common behavior is called:

* Base Class
* Parent Class
* Super Class

The class receiving and extending that behavior is called:

* Derived Class
* Child Class
* Subclass

The relationship:

```
        Base Class

             ↓

      Derived Class
```

---

# 4. Basic Inheritance Example in C#

## Base Class

```csharp
public class Employee
{
    public string Name { get; private set; }


    public Employee(string name)
    {
        Name = name;
    }


    public void ClockIn()
    {
        Console.WriteLine($"{Name} started work");
    }
}
```

---

## Derived Class

```csharp
public class Developer : Employee
{
    public Developer(string name)
        : base(name)
    {

    }


    public void WriteCode()
    {
        Console.WriteLine("Writing code");
    }
}
```

---

## Using The Object

```csharp
Developer developer =
    new Developer("Ahmed");


developer.ClockIn();

developer.WriteCode();
```

Output:

```
Ahmed started work
Writing code
```

---

Notice something important:

The `Developer` class does not contain:

```csharp
ClockIn()
```

but it can use it.

Why?

Because it inherited it from:

```text
Employee
```

---

# 5. Inheritance Is About Modeling, Not Saving Code

A common beginner misunderstanding:

> "I should use inheritance whenever I have duplicate code."

This is wrong.

Inheritance is mainly about representing a relationship between concepts.

The important question is:

> Does the child represent a specialized version of the parent?

---

# 6. The "IS-A" Relationship

Inheritance usually represents:

```
IS-A relationship
```

Meaning:

The child is a type of the parent.

---

## Good Example

```
Developer IS-A Employee
```

A developer is an employee.

Therefore:

```csharp
public class Developer : Employee
{

}
```

makes sense.

---

Another example:

```
Car IS-A Vehicle
```

A car is a type of vehicle.

---
# 7. Bad Inheritance Examples

A common mistake is using inheritance because two classes share some data or behavior.

Inheritance should represent a real:

```

IS-A relationship

```

Not just:

```

Has similar code

````

---

# Example 1 — Database Inherits From File ❌

A beginner might think:

"Both store information, so Database can inherit from File."

```csharp
public class File
{
    public string Name { get; set; }


    public void Open()
    {
        Console.WriteLine("Opening file");
    }
}


public class Database : File
{

}
````

## Why Is This Bad?

A database is not a type of file.

Although both may:

* Store data.
* Have a name.
* Be accessed.

They represent different concepts.

The relationship is wrong:

```
Database IS-A File ❌
```

---

# Example 2 — Square Inherits From Rectangle ❌

This is a famous design problem.

```csharp
public class Rectangle
{
    public int Width { get; set; }

    public int Height { get; set; }


    public int Area()
    {
        return Width * Height;
    }
}


public class Square : Rectangle
{

}
```

## Why Is This Problematic?

A square technically is a rectangle mathematically.

But in software design, their behaviors are different.

Rectangle:

```text
Width can change independently.

Height can change independently.
```

Square:

```text
Width and Height must always be equal.
```

The child cannot always respect the parent's behavior.

---

# Example 3 — Bird Inherits From FlyingBird ❌

```csharp
public class FlyingBird
{
    public void Fly()
    {
        Console.WriteLine("Flying");
    }
}


public class Penguin : FlyingBird
{

}
```

## Problem

A penguin is a bird, but it cannot fly.

The parent class provides behavior that does not apply to all children.

The hierarchy is wrong.

```
Penguin IS-A FlyingBird ❌
```

---


# Example 4 — Car Inherits From Engine ❌

```csharp
public class Engine
{
    public void Start()
    {

    }
}


public class Car : Engine
{

}
```

## Why Is This Wrong?

A car is not an engine.

The correct relationship is:

```
Car HAS-A Engine
```

Not:

```
Car IS-A Engine
```

This should be composition:

```csharp
public class Car
{
    private Engine engine;
}
```

---


# Senior Engineer Rule

Before creating inheritance, ask:

## Question 1

Can I complete this sentence?

```
Child IS-A Parent
```

Example:

```
Developer IS-A Employee ✅
```

```
Car IS-A Engine ❌
```

---

## Question 2

Does the child need all parent behavior?

If the child inherits unnecessary behavior, the hierarchy is probably wrong.

---

## Question 3

Am I using inheritance because of a real relationship or only because of shared code?

Shared code alone is not enough reason.



# 8. Code Reuse vs Relationship Modeling

These two ideas are often confused.

---

## Wrong Thinking

> "These two classes have similar code, therefore inheritance is needed."

Example:

```
Invoice

Report
```

Both contain:

```
CreatedDate

CreatedBy
```

Does this mean:

```
Invoice inherits Report
```

No.

The relationship does not exist.

---

## Correct Thinking

Use inheritance when:

```
Child IS-A Parent
```

Example:

```
Employee

    ↓

Developer
```

---

# 9. Benefits of Inheritance

Inheritance provides several advantages.

---

# 9.1 Code Reuse

Common behavior exists in one place.

Example:

```csharp
public class Employee
{
    public void ClockIn()
    {

    }
}
```

Every employee receives this behavior.

---

# 9.2 Better Domain Representation

The code reflects real business concepts.

Instead of unrelated classes:

```
Developer
Manager
Designer
```

we express:

```
Employee

   |
----------------

Developer

Manager

Designer
```

---

# 9.3 Easier Extension

New employee types can be added.

Example:

```text
Employee

 ├── Developer

 ├── Manager

 ├── Designer

 └── Tester
```

Common behavior stays in one place.

---

# 10. Problems With Inheritance

Although inheritance is powerful, it creates risks.

Professional developers must understand these risks.

---

# 10.1 Tight Coupling

A child class depends heavily on its parent.

Example:

```
Employee

    ↓

Developer
```

If Employee changes:

```text
New behavior

Removed method

Changed logic
```

Developer may be affected.

---

# 10.2 Fragile Base Class Problem

A change in the parent class can unexpectedly break child classes.

Example:

Today:

```csharp
public class Employee
{
    public virtual void Work()
    {

    }
}
```

Many classes depend on it:

```
Developer

Manager

Designer
```

Changing `Work()` behavior may impact all children.

---

# 10.3 Deep Inheritance Hierarchies

Example:

```
Vehicle

    ↓

Car

    ↓

ElectricCar

    ↓

LuxuryElectricCar

    ↓

LuxuryElectricCarWithAutopilot
```

Problems:

* Hard to understand.
* Hard to debug.
* Changes become risky.

---

# 11. Common Beginner Mistakes

---

## Mistake 1 — Using Inheritance Only For Duplication

Bad reason:

> "Two classes have similar fields."

Similarity does not always mean inheritance.

---

## Mistake 2 — Creating Huge Parent Classes

Example:

```text
Employee

Name

Email

Address

Salary

Drive()

Cook()

Manage()

Code()
```

Problem:

Not every employee has every behavior.

---

## Mistake 3 — Wrong Parent Responsibility

A parent class should contain behavior shared by all children.

---

# 12. Senior Engineer Decision Process

Before creating inheritance, ask:

---

## Question 1

Does the child represent a real specialization of the parent?

Example:

```
Manager → Employee
```

Yes.

---

## Question 2

Does the child naturally have the parent's behavior?

Example:

Employee:

```
Work()
```

Developer:

```
Work()
```

Makes sense.

---

## Question 3

Will future changes in the parent affect many children?

If yes, inheritance may create maintenance problems.

---

# 13. Real-World Example — Banking System

Consider:

```
BankAccount

       |
----------------

SavingsAccount

CheckingAccount
```

Why is this reasonable?

Because:

```
SavingsAccount IS-A BankAccount
```

Both have:

```
Account Number

Balance

Deposit()

Withdraw()
```

But they may have different rules.

---

# 14. When Should You Avoid Inheritance?

Avoid inheritance when:

* The relationship is not naturally "is-a".
* You only want code reuse.
* The hierarchy becomes too deep.
* Parent behavior does not apply to all children.
* Changes in the parent frequently break children.

---

# 🧠 Interview Discussion

## Question 1

Is inheritance mainly used for code reuse?

### Strong Answer:

No.

Code reuse is a benefit, but the main purpose is modeling relationships between objects.

---

## Question 2

What is the main question before creating inheritance?

### Strong Answer:

Ask:

> "Is this object truly a specialized version of the parent?"

---

## Question 3

Why can inheritance create coupling?

### Strong Answer:

Because child classes depend on the parent implementation and behavior.

Changes in the parent may affect multiple children.

---

# 📝 Practice Questions

1. Why was inheritance introduced?
2. What problems exist without inheritance?
3. Explain the difference between code reuse and relationship modeling.
4. What does "IS-A" relationship mean?
5. Why is `Developer : Employee` a good inheritance example?
6. Why is `Database : File` a bad example?
7. What are the risks of deep inheritance hierarchies?
8. When should inheritance be avoided?
9. Why does inheritance create coupling?
10. How does inheritance improve domain modeling?

---

# ✅ Key Takeaways

```
Inheritance is a design tool.

It represents relationships between objects.

Use inheritance when:

Child IS-A Parent.


Good:

Employee → Developer

Vehicle → Car


Bad:

File → Database


Do not use inheritance only to remove duplication.

Always think about:

- Relationship
- Responsibility
- Maintainability


