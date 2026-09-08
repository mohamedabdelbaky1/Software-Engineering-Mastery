

# Lesson 06 — Method Hiding vs Method Overriding in C#

> **Module:** Inheritance and Polymorphism
> **Topic:** Method Hiding and Overriding Differences
> **Language:** C#
> **Focus:** Understanding `new` vs `override` and Runtime Behavior

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* The difference between method overriding and method hiding.
* How the `new` keyword works.
* Why method hiding exists in C#.
* How compile-time and runtime behavior differ.
* How C# decides which method is executed.
* Why overriding is usually preferred over hiding.
* Common interview traps related to `virtual`, `override`, and `new`.

---

# 1. Introduction

In the previous lesson, we learned:

* A derived class can replace inherited behavior using `override`.
* The base class method must be marked as `virtual`.

Example:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Employee working");
    }
}


public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Developer writing code");
    }
}
```

This is **method overriding**.

---

But C# also allows another behavior:

```csharp
new
```

This is called:

```text
Method Hiding
```

Although both techniques look similar, they behave very differently.

---

# 2. Method Overriding Recap

Before comparing, let's review overriding.

## Base Class

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

> Derived classes are allowed to replace this behavior.

---

## Derived Class

```csharp
public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Developer writing code");
    }
}
```

The keyword:

```csharp
override
```

means:

> Replace the parent implementation.

---

Example:

```csharp
Employee employee = new Developer();

employee.Work();
```

Output:

```
Developer writing code
```

Why?

Because overriding uses:

```text
Runtime polymorphism
```

The runtime checks the actual object type.

---

# 3. What Is Method Hiding?

Method hiding happens when a derived class creates a method with the same name as a method in the parent class.

It uses:

```csharp
new
```

Example:

```csharp
public class Employee
{
    public void Work()
    {
        Console.WriteLine("Employee working");
    }
}


public class Developer : Employee
{
    public new void Work()
    {
        Console.WriteLine("Developer writing code");
    }
}
```

The child method does not replace the parent method.

It hides it.

---

# 4. Understanding The Difference

Let's compare.

---

## Method Overriding

```csharp
public override void Work()
```

Means:

> "I am replacing the parent's behavior."

---

## Method Hiding

```csharp
public new void Work()
```

Means:

> "I am creating another method with the same name."

The parent method still exists.

---

# 5. The Most Important Example

Consider:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("Employee working");
    }
}


public class Developer : Employee
{
    public override void Work()
    {
        Console.WriteLine("Developer coding");
    }
}
```

Now:

```csharp
Employee employee = new Developer();

employee.Work();
```

Output:

```
Developer coding
```

Because:

```text
Runtime object = Developer
```

---

Now let's use hiding.

```csharp
public class Employee
{
    public void Work()
    {
        Console.WriteLine("Employee working");
    }
}


public class Developer : Employee
{
    public new void Work()
    {
        Console.WriteLine("Developer coding");
    }
}
```

Now:

```csharp
Employee employee = new Developer();

employee.Work();
```

Output:

```
Employee working
```

Why?

Because hiding depends on the:

```text
Reference Type
```

not the actual object.

---

# 6. Reference Type vs Object Type

This is the key difference.

Example:

```csharp
Employee employee = new Developer();
```

There are two types:

---

## Reference Type

The variable type:

```text
Employee
```

Controls:

* Accessible members.
* Method selection in hiding.

---

## Object Type

The actual created object:

```text
Developer
```

Controls:

* Method selection in overriding.

---

# 7. Complete Comparison

| Feature                | Overriding | Hiding |
| ---------------------- | ---------- | ------ |
| Keyword                | override   | new    |
| Requires virtual       | Yes        | No     |
| Runtime polymorphism   | Yes        | No     |
| Parent method replaced | Yes        | No     |
| Uses object type       | Yes        | No     |
| Uses reference type    | No         | Yes    |

---

# 8. Why Does Method Hiding Exist?

A common question:

Why did C# create method hiding?

Sometimes a derived class needs to introduce a method with the same name without changing the behavior of the parent.

Example:

Imagine a library:

```csharp
public class OldLibrary
{
    public void Process()
    {

    }
}
```

A new version adds:

```csharp
public class NewLibrary : OldLibrary
{
    public new void Process()
    {

    }
}
```

The developer intentionally hides the old behavior.

---

# 9. Why Is Hiding Usually Dangerous?

Method hiding can create confusion.

Example:

```csharp
Developer developer = new Developer();

developer.Work();
```

Output:

```
Developer coding
```

But:

```csharp
Employee employee = developer;

employee.Work();
```

Output:

```
Employee working
```

Same object.

Different result.

This makes the code harder to understand.

---

# 10. Real-World Example

Imagine:

```text
Payment

    |
    |
CreditCardPayment
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

Correct:

```csharp
public class CreditCardPayment : Payment
{
    public override void Process()
    {
        Console.WriteLine("Validating card");
    }
}
```

The payment system can work with:

```csharp
Payment payment = new CreditCardPayment();

payment.Process();
```

and still execute:

```
Validating card
```

---

Using hiding:

```csharp
public class CreditCardPayment : Payment
{
    public new void Process()
    {
        Console.WriteLine("Validating card");
    }
}
```

Now:

```csharp
Payment payment = new CreditCardPayment();

payment.Process();
```

executes:

```
Processing payment
```

The specialized behavior disappears.

---

# 11. Common Mistakes

---

# Mistake 1 — Using new Instead of override

Bad:

```csharp
public new void Calculate()
{

}
```

when the intention is replacing behavior.

Correct:

```csharp
public override void Calculate()
{

}
```

---

# Mistake 2 — Ignoring Compiler Warning

C# warns when hiding happens accidentally.

Example:

```csharp
public void Work()
{

}
```

The compiler says:

> Member hides inherited member.

Because you probably intended:

```csharp
override
```

or you should explicitly write:

```csharp
new
```

---

# Mistake 3 — Mixing Both Concepts

Example:

```csharp
public class Developer : Employee
{
    public new void Work()
    {
    }

    public override void Code()
    {
    }
}
```

Possible technically.

But the design must be clear.

---

# 12. Senior Engineer Perspective

When reviewing code:

Ask:

## Is this method replacing behavior?

Use:

```csharp
override
```

---

## Is this intentionally creating another method with the same name?

Use:

```csharp
new
```

---

Most business applications prefer overriding because it provides predictable polymorphic behavior.

---

# 🧠 Interview Questions

## Q1

What is the difference between overriding and hiding?

### Answer:

Overriding replaces parent behavior using runtime polymorphism.

Hiding creates another method with the same name and uses compile-time reference selection.

---

## Q2

What happens here?

```csharp
Employee employee = new Developer();

employee.Work();
```

with override?

### Answer:

The Developer implementation runs.

---

## Q3

What happens with new?

### Answer:

The Employee implementation runs because the reference type is Employee.

---

## Q4

Why is method hiding risky?

### Answer:

Because the same object can produce different behavior depending on the reference type.

---

# 📝 Practice Questions

1. What is method hiding?
2. What keyword is used for hiding?
3. What keyword is used for overriding?
4. Does hiding require virtual?
5. Which one uses runtime polymorphism?
6. Explain reference type vs object type.
7. Why is overriding preferred in most cases?
8. When might hiding be intentional?

---

# ✅ Key Takeaways

```text
Override:

virtual + override

Uses runtime polymorphism.

Behavior depends on actual object type.


Hide:

new

Uses compile-time selection.

Behavior depends on reference type.


Example:

Employee employee = new Developer();


Override:
Developer method runs.


Hide:
Employee method runs.
```

