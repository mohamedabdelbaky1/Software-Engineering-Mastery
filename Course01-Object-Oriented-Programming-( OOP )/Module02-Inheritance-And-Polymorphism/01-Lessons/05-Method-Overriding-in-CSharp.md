
# Lesson 05 — Method Overriding in C#

> **Module:** Inheritance and Polymorphism
> **Topic:** Method Overriding and Runtime Behavior
> **Language:** C#
> **Focus:** Changing and Extending Inherited Behavior

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* What method overriding means.
* Why overriding exists.
* The difference between inherited methods and overridden methods.
* The purpose of `virtual` and `override` keywords.
* How runtime method selection works.
* The difference between compile-time and runtime decisions.
* How the `base` keyword works with overriding.
* Common overriding mistakes.
* How professionals use overriding in object-oriented design.

---

# 1. Introduction to Method Overriding

In inheritance, a derived class receives behavior from its base class.

Example:

```csharp
public class Employee
{
    public void Work()
    {
        Console.WriteLine("Employee is working");
    }
}
```

Derived class:

```csharp
public class Developer : Employee
{

}
```

Now:

```csharp
Developer developer = new Developer();

developer.Work();
```

Output:

```
Employee is working
```

The derived class uses the parent's behavior.

---

But sometimes the child class needs a **different implementation**.

Example:

All employees work, but:

```text
Employee:
General work

Developer:
Writing code

Manager:
Managing team
```

The behavior is different.

This is where **method overriding** is used.

---

# 2. What Is Method Overriding?

Method overriding allows a derived class to provide a new implementation for a method that already exists in the base class.

The parent defines a behavior.

The child replaces or extends that behavior.

Concept:

```
Base Class Behavior

        ↓

Derived Class Behavior
```

---

# 3. Why Do We Need Overriding?

Without overriding:

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

The Developer can only use:

```
Working
```

But in reality:

```
Developer → Writing Code

Manager → Managing Team

Designer → Creating Designs
```

Different objects need different behavior.

---

# 4. The virtual Keyword

Before a method can be overridden, the base class must allow it.

C# uses:

```csharp
virtual
```

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

The keyword:

```csharp
virtual
```

means:

> This method can be replaced by a derived class.

---

# 5. The override Keyword

The child class uses:

```csharp
override
```

to replace the parent's implementation.

Example:

Base class:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Employee working");
    }
}
```

Derived class:

```csharp
public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Writing code");
    }
}
```

Now:

```csharp
Developer developer = new Developer();

developer.Work();
```

Output:

```
Writing code
```

The Developer behavior replaced the Employee behavior.

---

# 6. Rules of Method Overriding

For overriding to work:

## Rule 1

The parent method must be:

```csharp
virtual
```

or:

```csharp
abstract
```

(later topic)

---

## Rule 2

The child method must use:

```csharp
override
```

---

## Rule 3

The method signature must match.

Example:

Parent:

```csharp
public virtual void Work()
{

}
```

Child:

```csharp
public override void Work()
{

}
```

Correct.

---

But:

```csharp
public override void Work(string task)
{

}
```

is not overriding.

It is a different method.

---

# 7. Runtime Method Selection

This is the most important concept.

Consider:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Employee Work");
    }
}


public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Developer Work");
    }
}
```

Now:

```csharp
Employee employee = new Developer();

employee.Work();
```

What is the output?

Many beginners think:

```
Employee Work
```

because the variable type is Employee.

But the output is:

```
Developer Work
```

Why?

Because C# uses the **actual object type at runtime**.

---

The difference:

Reference type:

```csharp
Employee
```

Actual object:

```csharp
Developer
```

Runtime chooses:

```
Developer.Work()
```

---

# 8. Understanding Reference Type vs Object Type

Example:

```csharp
Employee employee = new Developer();
```

Two identities exist:

## Reference Type

The type of the variable:

```
Employee
```

Controls:

* What members are accessible.

---

## Object Type

The actual created object:

```
Developer
```

Controls:

* Which overridden method executes.

---

Example:

```csharp
employee.Work();
```

Allowed because:

Employee has Work().

Execution:

Developer.Work()

because the object is Developer.

---

# 9. Calling Parent Behavior Using base

Sometimes we do not want to completely replace the parent's behavior.

We want:

```
Parent behavior

+

Child behavior
```

Example:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Starting work");
    }
}
```

Child:

```csharp
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
Starting work

Writing code
```

---

The child says:

"Execute the parent's behavior first, then add my behavior."

---

# 10. Real-World Example — Payment Processing

Imagine:

```text
Payment

    |
----------------

CreditCardPayment

CashPayment
```

Base:

```csharp
public class Payment
{
    public virtual void Process()
    {
        Console.WriteLine("Processing payment");
    }
}
```

Credit Card:

```csharp
public class CreditCardPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Validating card");

        Console.WriteLine("Processing credit payment");
    }
}
```

Cash:

```csharp
public class CashPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Counting cash");

        Console.WriteLine("Processing cash payment");
    }
}
```

Each payment type has its own behavior.

---

# 11. Overriding vs Normal Method

Compare:

## Normal Method

```csharp
public void Work()
{

}
```

The child cannot replace it.

---

## Virtual Method

```csharp
public virtual void Work()
{

}
```

The child can replace it.

---

# 12. Common Mistakes

---

# Mistake 1 — Forgetting virtual

Wrong:

```csharp
public void Work()
{

}
```

Child:

```csharp
public override void Work()
{

}
```

Compilation error.

---

# Mistake 2 — Changing Method Signature

Parent:

```csharp
public virtual void Print()
{

}
```

Child:

```csharp
public override void Print(string name)
{

}
```

Not overriding.

---

# Mistake 3 — Using Override Everywhere

Not every inherited method should be overridden.

Override only when the child genuinely needs different behavior.

---

# Mistake 4 — Removing Parent Behavior Accidentally

Example:

Parent:

```csharp
Save()
```

does:

```
Validate data
Save database record
Create log
```

Child overrides:

```csharp
public override void Save()
{
    SaveData();
}
```

Now validation and logging disappear.

Sometimes:

```csharp
base.Save();
```

is required.

---

# 13. Professional Design Considerations

## Use overriding when:

The child is a specialized version of the parent behavior.

Example:

```
Employee.Work()

Developer.Work()
```

---

## Avoid overriding when:

The child behavior is completely unrelated.

Example:

```
Animal.Move()

Database.Move()
```

---

## Keep overridden methods predictable

A child should not surprise users of the parent class.

Example:

Bad:

```csharp
Account.Withdraw()
```

Parent:

```
Remove money
```

Child:

```
Delete account
```

The behavior is unexpected.

---

# 🧠 Interview Questions

## Q1

What is method overriding?

### Answer:

Providing a new implementation for an inherited method in a derived class.

---

## Q2

Why do we use the virtual keyword?

### Answer:

To allow derived classes to override a method.

---

## Q3

What is the difference between override and overload?

### Override:

Same method signature, different implementation.

### Overload:

Same method name, different parameters.

---

## Q4

What happens here?

```csharp
Employee employee = new Developer();

employee.Work();
```

### Answer:

The overridden Developer method executes because runtime uses the actual object type.

---

## Q5

Why use base.MethodName()?

### Answer:

To call the parent implementation from the overridden child method.

---

# 📝 Practice Questions

1. What problem does method overriding solve?
2. What is the purpose of `virtual`?
3. What is the purpose of `override`?
4. Explain runtime method selection.
5. Difference between reference type and object type.
6. When should you use `base.Method()`?
7. What happens if the base method is not virtual?
8. Difference between overriding and overloading.

---

# ✅ Key Takeaways

```text
Method overriding allows child classes
to provide specialized behavior.


Base class:

virtual method


Derived class:

override method


Runtime chooses the method based on:

Actual object type


Example:

Employee employee = new Developer();

employee.Work();

Runs:

Developer.Work()
```

