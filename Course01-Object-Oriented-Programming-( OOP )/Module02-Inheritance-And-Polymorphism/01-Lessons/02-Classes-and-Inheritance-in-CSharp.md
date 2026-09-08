
# Lesson 02 — Classes and Inheritance in C#

> **Module:** Inheritance and Polymorphism  
> **Topic:** Classes and Inheritance Mechanics  
> **Language:** C#  
> **Focus:** Understanding How Inheritance Works Internally in C#

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

- How inheritance is implemented in C#.
- How base classes and derived classes are created.
- How C# handles inherited members.
- What members are inherited and what members are not.
- How access modifiers affect inheritance.
- The difference between `public`, `protected`, and `private`.
- How constructors behave in inheritance.
- How constructor chaining works.
- How the `base` keyword is used.
- Common C# inheritance mistakes.

---

# 1. Creating Inheritance in C#

In C#, inheritance is created using the colon (`:`) syntax.

Example:

```csharp
public class Developer : Employee
{

}
````

This means:

```text
Developer inherits from Employee
```

The class before the colon is the derived class.

The class after the colon is the base class.

Structure:

```text
Derived Class : Base Class
```

Example:

```csharp
public class Car : Vehicle
{

}
```

Meaning:

```text
Car inherits Vehicle
```

---

# 2. Base Class and Derived Class

A base class contains members that can be shared with derived classes.

Example:

```csharp
public class Employee
{
    public string Name { get; set; }


    public void ClockIn()
    {
        Console.WriteLine("Employee started work");
    }
}
```

Derived class:

```csharp
public class Developer : Employee
{

}
```

The `Developer` class can use:

```csharp
Developer developer = new Developer();

developer.Name = "Mohamed";

developer.ClockIn();
```

Even though these members are not declared inside `Developer`.

---

# 3. How Inheritance Works Inside an Object

Consider:

```csharp
public class Person
{
    public string Name { get; set; }
}


public class Employee : Person
{
    public decimal Salary { get; set; }
}


public class Developer : Employee
{
    public string ProgrammingLanguage { get; set; }
}
```

Creating:

```csharp
Developer developer = new Developer();
```

The object contains:

```
Developer Object

+----------------------+
| Person Part          |
|                      |
| Name                 |
+----------------------+
| Employee Part        |
|                      |
| Salary               |
+----------------------+
| Developer Part       |
|                      |
| ProgrammingLanguage  |
+----------------------+
```

The derived object contains all inherited parts.

This is why:

```csharp
developer.Name;
```

is valid.

---

# 4. Inheritance and Object References

A derived object can be stored in a base class reference.

Example:

```csharp
Employee employee = new Developer();
```

This is valid because:

```
Developer IS an Employee
```

The object is still a `Developer`.

The reference type is:

```text
Employee
```

The actual object type is:

```text
Developer
```

---

However:

```csharp
Developer developer = new Employee();
```

is invalid.

Why?

Because:

```
Every Developer is an Employee

But

Every Employee is not a Developer
```

Example:

A Manager is an Employee.

But a Manager is not a Developer.

---

# 5. What Members Are Inherited?

Inheritance does not mean every member behaves the same way.

We need to understand:

* Fields
* Properties
* Methods
* Constructors

---

# 5.1 Fields

Example:

```csharp
public class Person
{
    public string Name;
}


public class Employee : Person
{

}
```

The derived class can access:

```csharp
Employee employee = new Employee();

employee.Name = "Ahmed";
```

Because `Name` is public.

---

# 5.2 Methods

Example:

```csharp
public class Employee
{
    public void Work()
    {
        Console.WriteLine("Working");
    }
}


public class Developer : Employee
{

}
```

Usage:

```csharp
Developer developer = new Developer();

developer.Work();
```

The method belongs to `Employee`, but is available to `Developer`.

---

# 5.3 Properties

Example:

```csharp
public class Employee
{
    public string Name { get; set; }
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

developer.Name = "Mohamed";
```

The property is inherited.

---

# 6. Access Modifiers and Inheritance

Access modifiers control who can access members.

The three important modifiers:

* public
* protected
* private

---

# 6.1 Public Members

Example:

```csharp
public class Employee
{
    public string Name;
}
```

A public member can be accessed by:

| Location         | Access |
| ---------------- | ------ |
| Same class       | ✅      |
| Derived class    | ✅      |
| External classes | ✅      |

Example:

```csharp
employee.Name = "Ahmed";
```

---

# 6.2 Protected Members

`protected` is designed for inheritance.

Example:

```csharp
public class Employee
{
    protected decimal salary;
}
```

Derived class:

```csharp
public class Developer : Employee
{
    public void IncreaseSalary()
    {
        salary += 1000;
    }
}
```

The child class can access it.

However:

```csharp
Employee employee = new Employee();

employee.salary = 5000;
```

is not allowed.

---

## Why Use Protected?

Sometimes the parent class needs to expose something to children without exposing it publicly.

Example:

```text
Public:
Everyone can access

Protected:
Only inheritance hierarchy

Private:
Only the declaring class
```

---

# 6.3 Private Members

Example:

```csharp
public class Employee
{
    private string password;
}
```

The derived class cannot access:

```csharp
public class Developer : Employee
{
    void Test()
    {
        password = "123";
    }
}
```

This causes a compilation error.

---

Important concept:

The private field exists inside the object.

But the child class cannot access it.

There is a difference between:

```
Existence
```

and:

```
Accessibility
```

---

# 7. Access Modifier Comparison

| Modifier  | Same Class | Derived Class | Outside Class |
| --------- | ---------- | ------------- | ------------- |
| public    | ✅          | ✅             | ✅             |
| protected | ✅          | ✅             | ❌             |
| private   | ✅          | ❌             | ❌             |

---

# 8. Constructor Behavior in Inheritance

Constructors are responsible for creating valid objects.

When inheritance exists, constructor execution follows a specific order.

Example:

```csharp
public class Employee
{
    public Employee()
    {
        Console.WriteLine("Employee Constructor");
    }
}


public class Developer : Employee
{
    public Developer()
    {
        Console.WriteLine("Developer Constructor");
    }
}
```

Creating:

```csharp
Developer developer = new Developer();
```

Output:

```
Employee Constructor

Developer Constructor
```

---

# 9. Why Does the Parent Constructor Run First?

Because the derived object contains the base class part.

Before creating:

```
Developer Part
```

C# must initialize:

```
Employee Part
```

The order is:

```
Base Constructor

        ↓

Derived Constructor
```

---

# 10. Constructor Chaining

If the base class requires parameters:

```csharp
public class Employee
{
    public Employee(string name)
    {

    }
}
```

The child must call the parent constructor:

```csharp
public class Developer : Employee
{
    public Developer(string name)
        : base(name)
    {

    }
}
```

The keyword:

```csharp
base()
```

calls the parent constructor.

---

# 11. The base Keyword

The `base` keyword allows access to the parent class.

It has two common uses:

---

## 11.1 Calling Base Constructor

```csharp
public Developer(string name)
    : base(name)
{

}
```

---

## 11.2 Calling Base Method

Example:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("General work");
    }
}


public class Developer : Employee
{
    public override void Work()
    {
        base.Work();

        Console.WriteLine("Writing code");
    }
}
```

Output:

```
General work

Writing code
```

The child extends the parent's behavior.

---

# 12. Multi-Level Inheritance

C# supports multiple levels of inheritance.

Example:

```
Person

 ↓

Employee

 ↓

Developer

 ↓

SeniorDeveloper
```

Example:

```csharp
public class SeniorDeveloper : Developer
{

}
```

The final class receives members from all parent classes.

---

# 13. What Is Not Inherited?

## Constructors

Constructors are not inherited.

The child must define its own constructors.

---

## Private Members

Private members belong only to the class that declares them.

---

# 14. Common Beginner Mistakes

## Mistake 1 — Making Everything Public

Bad:

```csharp
public decimal Balance;
```

Problem:

Any object can modify the value.

---

## Mistake 2 — Making Everything Protected

Bad:

```csharp
protected string Name;
protected decimal Salary;
protected string Email;
```

Problem:

Creates strong dependency between parent and children.

---

## Mistake 3 — Forgetting Base Constructor

Example:

Parent:

```csharp
public Employee(string name)
{

}
```

Child:

```csharp
public Developer()
{

}
```

This fails because the parent requires initialization.

---

# 15. Senior Engineer Considerations

When designing inheritance in C#:

Ask:

## Are inherited members really needed?

Not everything should be exposed to child classes.

---

## Is the base class stable?

A frequently changing base class can break many derived classes.

---

## Are access modifiers carefully chosen?

Prefer the minimum required access.

Example:

Instead of:

```csharp
public
```

consider:

```csharp
protected
```

or:

```csharp
private
```

when appropriate.

---

# 🧠 Interview Questions

## Q1 — Are constructors inherited?

**Answer:**

No. Constructors belong to the class that defines them.

Derived classes must call base constructors explicitly when required.

---

## Q2 — Can a child class access private members?

**Answer:**

No.

Private members exist in the object but are only accessible inside the declaring class.

---

## Q3 — What is the difference between protected and private?

**Answer:**

`protected` allows derived classes to access the member.

`private` restricts access only to the declaring class.

---

## Q4 — Why does the base constructor execute first?

**Answer:**

Because the base part of the object must be initialized before the derived part.

---

# 📝 Practice Questions

1. How do you create inheritance in C#?
2. What is the difference between base and derived classes?
3. Which members are inherited?
4. Why are constructors not inherited?
5. What is the purpose of the `base` keyword?
6. When should you use protected?
7. Why can too many protected members create problems?
8. Explain constructor execution order.

---

# ✅ Key Takeaways


Inheritance creates a relationship between classes.

Base Class:
Provides common functionality.

Derived Class:
Extends existing functionality.


Access modifiers:

public:
Accessible everywhere.

protected:
Accessible inside derived classes.

private:
Accessible only inside the declaring class.


Object creation order:

Base Constructor

        ↓

Derived Constructor


The base keyword allows communication with the parent class.


