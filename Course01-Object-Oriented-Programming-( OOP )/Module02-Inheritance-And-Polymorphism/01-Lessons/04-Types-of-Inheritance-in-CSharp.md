
# Lesson 04 — Types of Inheritance in C#

> **Module:** Inheritance and Polymorphism
> **Topic:** Inheritance Structures in C#
> **Language:** C#
> **Focus:** Understanding Different Inheritance Models and Their Limitations

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* The different types of inheritance.
* How inheritance hierarchies are structured.
* How C# supports inheritance.
* Why C# does not support multiple inheritance between classes.
* The difference between inheritance types.
* The advantages and risks of each inheritance structure.
* How to design inheritance hierarchies professionally.

---

# 1. Introduction

Inheritance is not only about one class inheriting from another.

In real systems, inheritance relationships can form different structures.

Example:

```text
        Person

          |

       Employee

          |

       Developer
```

or:

```text
          Vehicle

       /     |      \

     Car   Truck  Motorcycle
```

The structure of inheritance affects:

* Code organization.
* Maintainability.
* Complexity.
* Future changes.

---

# 2. Single Inheritance

## Definition

Single inheritance means:

> One derived class inherits from one base class.

Structure:

```text
        Base Class

             |

       Derived Class
```

---

Example:

```csharp
public class Employee
{
    public string Name { get; set; }


    public void Work()
    {
        Console.WriteLine("Working");
    }
}
```

Derived class:

```csharp
public class Developer : Employee
{

}
```

Usage:

```csharp
Developer developer = new Developer();

developer.Work();
```

---

## What Happens?

The `Developer` class receives:

```text
Employee Members

+
Developer Members
```

Example:

```text
Developer

-----------------

Name

Work()

WriteCode()
```

---

## Real Example

Banking system:

```text
        Account

           |

     SavingsAccount
```

`SavingsAccount` inherits:

* Account number.
* Balance.
* Deposit behavior.

And adds:

* Interest calculation.

---

# 3. Multilevel Inheritance

## Definition

Multilevel inheritance means:

> A class inherits from a class that already inherits from another class.

Structure:

```text
        A

        |

        B

        |

        C
```

---

Example:

```csharp
public class Person
{
    public string Name { get; set; }
}
```

---

```csharp
public class Employee : Person
{
    public decimal Salary { get; set; }
}
```

---

```csharp
public class Developer : Employee
{
    public string Language { get; set; }
}
```

---

Now:

```csharp
Developer developer = new Developer();
```

The object contains:

```text
Person

+
Employee

+
Developer
```

---

## Constructor Execution

When creating:

```csharp
Developer developer =
    new Developer();
```

Execution:

```text
Person Constructor

        ↓

Employee Constructor

        ↓

Developer Constructor
```

---

# Advantages of Multilevel Inheritance

## 1. Progressive Specialization

Each level adds more specific behavior.

Example:

```text
Vehicle

   ↓

Car

   ↓

ElectricCar
```

---

## 2. Code Organization

Common behavior stays in higher levels.

---

# Problems With Multilevel Inheritance

Deep hierarchies can become difficult.

Example:

```text
Object

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
* Changes affect many levels.
* Debugging becomes harder.

---

# 4. Hierarchical Inheritance

## Definition

Hierarchical inheritance means:

> Multiple classes inherit from the same base class.

Structure:

```text
              Animal

          /      |       \

        Dog     Cat     Bird
```

---

Example:

Base class:

```csharp
public class Employee
{
    public string Name { get; set; }


    public void ClockIn()
    {
        Console.WriteLine("Clock in");
    }
}
```

Derived classes:

```csharp
public class Developer : Employee
{

}


public class Manager : Employee
{

}


public class Designer : Employee
{

}
```

---

All classes share:

```text
Employee

Name

ClockIn()
```

But each can add specific behavior.

---

Example:

Developer:

```csharp
WriteCode()
```

Manager:

```csharp
ManageTeam()
```

Designer:

```csharp
CreateDesign()
```

---

# Advantages of Hierarchical Inheritance

## 1. Common Behavior Centralization

Shared logic exists in one place.

---

## 2. Easy Extension

New employee types can be added:

```text
Employee

 |
 ----------------

Developer

Manager

Designer

Tester
```

---

# Problems With Hierarchical Inheritance

The base class must be carefully designed.

Bad example:

```csharp
public class Employee
{
    public void Drive()
    {

    }

    public void WriteCode()
    {

    }

    public void ManageTeam()
    {

    }
}
```

Problem:

Every child receives behavior it may not need.

---

# 5. Multiple Inheritance

## Definition

Multiple inheritance means:

> A class inherits from more than one class.

Structure:

```text
        A

       /

      C

       \

        B
```

Meaning:

```text
C inherits A and B
```

---

Example in some languages:

```cpp
class FlyingCar : public Car, public Aircraft
{

}
```

A class receives behavior from two parents.

---

# 6. Does C# Support Multiple Class Inheritance?

No.

C# does not allow:

```csharp
public class FlyingCar : Car, Aircraft
{

}
```

This produces a compilation error.

---

# 7. Why Does C# Avoid Multiple Class Inheritance?

The main problem is ambiguity.

Example:

Two parent classes:

```csharp
class Vehicle
{
    public void Start()
    {
        Console.WriteLine("Vehicle Start");
    }
}
```

Another:

```csharp
class Machine
{
    public void Start()
    {
        Console.WriteLine("Machine Start");
    }
}
```

Now:

```text
        Vehicle       Machine

             \        /

              Robot
```

If Robot calls:

```csharp
Start();
```

Which method should execute?

```text
Vehicle.Start()

or

Machine.Start()
```

This creates ambiguity.

---

# 8. Multiple Inheritance Problem Example

Imagine:

```text
        Animal

       /      \

   Bird       Mammal

       \      /

        Bat
```

Bat inherits:

* Flying behavior from Bird.
* Mammal behavior from Mammal.

But what happens if both parents define:

```text
Move()
```

Which one should Bat use?

---

# 9. C# Alternative

C# solves this problem using:

* Interfaces.
* Composition.

These topics will be covered in future modules.

For now, remember:

```text
C# allows:

Class inheritance:
One base class only.

Multiple behavior contracts:
Handled differently.
```

---

# 10. Sealed Classes and Inheritance Restriction

Sometimes we do not want other classes to inherit from a class.

C# provides:

```csharp
sealed
```

Example:

```csharp
public sealed class SecurityManager
{

}
```

Now:

```csharp
public class CustomManager : SecurityManager
{

}
```

is not allowed.

---

# Why Use Sealed?

Reasons:

## 1. Prevent Modification

The design should not be extended.

---

## 2. Security

Prevent changing important behavior.

---

## 3. Performance Optimization

The compiler can make some optimizations.

---

# 11. Inheritance Hierarchy Design Rules

When creating inheritance structures:

---

## Rule 1

Keep hierarchies shallow.

Prefer:

```text
Animal

 |

Dog
```

over:

```text
Animal

 |

Mammal

 |

DomesticAnimal

 |

Pet

 |

Dog
```

---

## Rule 2

The base class should represent truly common behavior.

---

## Rule 3

Avoid creating parent classes only for grouping.

Bad:

```csharp
class Manager
{

}

class EmployeeManager : Manager
{

}
```

without a real relationship.

---

# 12. Real World Example — E-Commerce

Possible hierarchy:

```text
             Product

          /          \

      Physical     Digital

       Product     Product
```

Physical product:

```text
Weight

Shipping Address
```

Digital product:

```text
Download Link

File Size
```

The hierarchy represents different types of products.

---

# 🧠 Interview Questions

## Q1

What are the types of inheritance?

### Answer:

Common inheritance structures:

* Single inheritance.
* Multilevel inheritance.
* Hierarchical inheritance.
* Multiple inheritance.

C# supports the first three with classes.

---

## Q2

Does C# support multiple class inheritance?

### Answer:

No.

A class can inherit from only one class.

---

## Q3

Why does C# avoid multiple inheritance?

### Answer:

Because it can create ambiguity when multiple parent classes define the same members.

---

## Q4

What is multilevel inheritance?

### Answer:

When a derived class inherits from another derived class.

Example:

```text
A → B → C
```

---

## Q5

What is hierarchical inheritance?

### Answer:

When multiple classes inherit from the same base class.

Example:

```text
Employee

 / | \

Dev Manager Designer
```

---

# 📝 Practice Questions

1. Explain single inheritance with an example.
2. Explain multilevel inheritance.
3. Explain hierarchical inheritance.
4. Why is deep inheritance dangerous?
5. Why does C# not support multiple class inheritance?
6. What problems can multiple inheritance create?
7. What is the purpose of the sealed keyword?
8. How do you design a good inheritance hierarchy?

---

# ✅ Key Takeaways

```text
Inheritance can have different structures.

Single:

A → B


Multilevel:

A → B → C


Hierarchical:

      A

   /  |  \

  B   C   D


C# does not support multiple class inheritance.

Good inheritance design requires:

- Clear hierarchy.
- Shallow structure.
- Meaningful relationships.
```

