

# 🎤 Interview Questions 01 — OOP Basics

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What is Object-Oriented Programming (OOP)?

## Answer

Object-Oriented Programming is a programming paradigm that organizes software around **objects** that contain:

* State (data)
* Behavior (methods)

Instead of thinking only about functions and data separately, OOP models real-world entities as objects.

Example:

```csharp
public class BankAccount
{
    public decimal Balance { get; private set; }


    public void Deposit(decimal amount)
    {
        Balance += amount;
    }
}
```

Here:

State:

```text
Balance
```

Behavior:

```text
Deposit()
```

---

# Why does OOP exist?

## Problem without OOP:

Large systems become difficult to maintain because:

* Data is exposed everywhere.
* Logic is duplicated.
* Changes affect many places.

OOP tries to solve this by:

* Grouping related data and behavior.
* Protecting object state.
* Creating reusable models.

---

# Q2 — What are the main principles of OOP?

## Answer

The four fundamental principles are:

---

## 1. Encapsulation

Protecting object state and controlling access.

Example:

```csharp
private decimal balance;


public void Deposit(decimal amount)
{
    balance += amount;
}
```

---

## 2. Abstraction

Showing only important details while hiding complexity.

Example:

You use:

```csharp
car.Start();
```

You do not need to know:

* Fuel system
* Engine mechanics
* Electrical details

---

## 3. Inheritance

Allowing one class to reuse another class behavior.

Example:

```csharp
class Animal
{
    public void Eat()
    {

    }
}


class Dog : Animal
{

}
```

---

## 4. Polymorphism

Allowing different objects to respond differently to the same behavior.

Example:

```csharp
animal.MakeSound();
```

Dog:

```text
Bark
```

Cat:

```text
Meow
```

---

# Q3 — What is the difference between OOP and Procedural Programming?

## Answer

Procedural programming focuses on:

```text
Functions
+
Data
```

Example:

```csharp
CalculateSalary(employee);
```

---

OOP focuses on:

```text
Objects

=
Data

+

Behavior
```

Example:

```csharp
employee.CalculateSalary();
```

---

## Main Difference

| Procedural                | OOP                      |
| ------------------------- | ------------------------ |
| Function-oriented         | Object-oriented          |
| Data separated from logic | Data + behavior together |
| Less protection           | Encapsulation            |
| Harder for large systems  | Better modeling          |

---

# Q4 — What is an Object?

## Answer

An object is an instance of a class.

It represents a real entity with:

* Identity
* State
* Behavior

Example:

Class:

```csharp
public class Car
{
    public string Model {get;}


    public void Drive()
    {

    }
}
```

Object:

```csharp
Car car =
    new Car();
```

---

The class is the blueprint.

The object is the actual thing created from that blueprint.

---

# Q5 — What is a Class?

## Answer

A class is a blueprint that defines:

* What data an object has.
* What actions an object can perform.

Example:

```csharp
public class Employee
{
    public string Name {get;}


    public void Work()
    {

    }
}
```

The class itself does not represent an actual employee.

It defines how employees should look.

---

# Q6 — Class vs Object?

## Answer

| Class               | Object              |
| ------------------- | ------------------- |
| Blueprint           | Instance            |
| Definition          | Actual entity       |
| Exists conceptually | Exists in memory    |
| Defines structure   | Holds actual values |

Example:

Class:

```csharp
class Student
{

}
```

Objects:

```csharp
Student ahmed = new Student();

Student mohamed = new Student();
```

---

# Q7 — Why do we create classes?

## Answer

To:

* Model real concepts.
* Organize code.
* Reduce duplication.
* Encapsulate behavior.

Example:

Instead of:

```text
customerName
customerBalance
customerAddress
```

everywhere.

Create:

```csharp
Customer
```

that owns its data and behavior.

---

# Q8 — Is OOP only about creating classes?

## Answer

No.

This is a common misconception.

Bad OOP:

```csharp
class Customer
{
    public string Name;
}
```

This is only a data container.

Good OOP:

```csharp
class Customer
{
    private decimal balance;


    public void Pay(decimal amount)
    {

    }
}
```

The object owns behavior and rules.

---

# Q9 — What makes a good object?

## Answer

A good object:

✅ Has a clear responsibility
✅ Protects its state
✅ Contains related behavior
✅ Prevents invalid states
✅ Provides meaningful operations

Example:

Good:

```csharp
account.Withdraw(500);
```

Bad:

```csharp
account.Balance -= 500;
```

---

# Q10 — What are the advantages of OOP?

## Answer

### 1. Maintainability

Changes are isolated.

---

### 2. Reusability

Objects can be reused.

---

### 3. Security

State is protected.

---

### 4. Scalability

Large systems become easier to manage.

---

### 5. Better Collaboration

Different developers can work on separate components.

---

# 🎯 Senior Interview Follow-up

## Question:

"Many developers say OOP means using classes. Do you agree?"

## Strong Answer:

No.

Classes are only a tool.

The real goal of OOP is creating objects that model responsibilities, protect their state, and expose meaningful behavior.

A system full of classes can still have poor OOP design if objects are just data containers.

---

# Key Takeaways

```text
OOP = Objects

Object =
State + Behavior + Identity


Good OOP =
Responsible objects
+
Protected state
+
Clear behavior
```

---

