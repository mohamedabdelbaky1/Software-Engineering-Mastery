
# Lesson 08 — Compile-Time Polymorphism in C#

> **Module:** Inheritance and Polymorphism
> **Topic:** Compile-Time Polymorphism
> **Language:** C#
> **Level:** Intermediate
> **Focus:** Understanding Method Resolution Before Runtime

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

* What compile-time polymorphism means.
* How the compiler selects methods.
* Method overloading in C#.
* Constructor overloading.
* Optional parameters vs overloading.
* Overloading rules.
* Valid and invalid overloads.
* Operator overloading basics.
* Common mistakes when using overloading.
* When compile-time polymorphism improves design.

---

# 1. Introduction to Compile-Time Polymorphism

In the previous lesson, we discussed two types of polymorphism:

```text
1. Compile-Time Polymorphism

2. Runtime Polymorphism
```

Runtime polymorphism depends on:

```text
The actual object created at runtime
```

Example:

```csharp
Animal animal = new Dog();

animal.MakeSound();
```

The runtime decides which method executes.

---

Compile-time polymorphism is different.

The compiler decides which method should be called **before the program runs**.

The most common example:

```text
Method Overloading
```

---

# 2. What Is Method Overloading?

Method overloading means:

> Having multiple methods with the same name but different parameters.

Example:

```csharp
public class Calculator
{
    public int Add(int a, int b)
    {
        return a + b;
    }


    public int Add(int a, int b, int c)
    {
        return a + b + c;
    }
}
```

Both methods are called:

```csharp
Add()
```

But their parameters are different.

---

Usage:

```csharp
Calculator calculator = new Calculator();


calculator.Add(5, 10);


calculator.Add(5, 10, 15);
```

The compiler knows which method to call.

---

# 3. How Does the Compiler Choose the Method?

The compiler looks at:

```text
Method Name

+

Number of Parameters

+

Parameter Types

+

Parameter Order
```

---

Example:

```csharp
public void Print(int number)
{

}


public void Print(string text)
{

}
```

Calling:

```csharp
Print(100);
```

The compiler chooses:

```csharp
Print(int)
```

---

Calling:

```csharp
Print("Hello");
```

The compiler chooses:

```csharp
Print(string)
```

---

# 4. Method Signature in C#

For overloading, methods must have different signatures.

A method signature includes:

✅ Method name

✅ Number of parameters

✅ Parameter types

✅ Parameter order

---

Example:

Valid:

```csharp
public void Display(int number)
{

}


public void Display(string text)
{

}
```

Different parameter types.

---

Valid:

```csharp
public void Display(int x, int y)
{

}


public void Display(int x)
{

}
```

Different number of parameters.

---

Valid:

```csharp
public void Display(int x, string name)
{

}


public void Display(string name, int x)
{

}
```

Different parameter order.

---

# 5. Invalid Overloading Examples

## Example 1 — Only Changing Return Type

This is NOT valid:

```csharp
public int Calculate()
{

}


public double Calculate()
{

}
```

Why?

Because the compiler does not use return type to select methods.

The call:

```csharp
Calculate();
```

is ambiguous.

---

# Example 2 — Only Changing Access Modifier

Invalid:

```csharp
public void Print()
{

}


private void Print()
{

}
```

Access modifiers are not part of the method signature.

---

# Example 3 — Parameter Names

Invalid:

```csharp
public void Save(string name)
{

}


public void Save(string username)
{

}
```

Both have:

```text
Save(string)
```

The compiler sees them as the same method.

---

# 6. Real-World Example — Logging System

Imagine a logging service.

Without overloading:

```csharp
logger.LogMessage("Error");
```

Another method:

```csharp
logger.LogNumber(500);
```

This creates many method names.

---

With overloading:

```csharp
public class Logger
{
    public void Log(string message)
    {
        Console.WriteLine(message);
    }


    public void Log(int errorCode)
    {
        Console.WriteLine(errorCode);
    }
}
```

Usage:

```csharp
logger.Log("Database failed");

logger.Log(404);
```

The API is cleaner.

---

# 7. Constructor Overloading

Constructors can also be overloaded.

Example:

```csharp
public class Employee
{
    public string Name { get; set; }


    public Employee()
    {

    }


    public Employee(string name)
    {
        Name = name;
    }
}
```

Now we can create:

```csharp
Employee employee1 =
    new Employee();


Employee employee2 =
    new Employee("Ahmed");
```

---

The compiler chooses the correct constructor based on arguments.

---

# 8. Constructor Overloading Example

Real scenario:

A User can be created in different ways.

```csharp
public class User
{
    public string Name { get; }
    public string Email { get; }


    public User(string name)
    {
        Name = name;
    }


    public User(string name, string email)
    {
        Name = name;
        Email = email;
    }
}
```

Usage:

```csharp
User user1 =
    new User("Mohamed");


User user2 =
    new User("Mohamed", "test@email.com");
```

---

# 9. Constructor Chaining with this()

When constructors share logic, we can use:

```csharp
this()
```

Example:

```csharp
public class Product
{
    public string Name { get; }
    public decimal Price { get; }


    public Product()
        : this("Unknown", 0)
    {

    }


    public Product(string name, decimal price)
    {
        Name = name;
        Price = price;
    }
}
```

The empty constructor calls:

```csharp
Product(string, decimal)
```

This avoids duplicate initialization code.

---

# 10. Overloading vs Optional Parameters

Another way to handle different inputs:

```csharp
public void Print(string message = "Hello")
{
    Console.WriteLine(message);
}
```

Usage:

```csharp
Print();

Print("Welcome");
```

---

Difference:

## Overloading

Creates multiple methods:

```csharp
Print()

Print(string)
```

---

## Optional Parameters

Creates one method:

```csharp
Print(string message = "Hello")
```

---

When to use?

Use overloading when:

* Different behaviors exist.
* Different parameter types are needed.

Use optional parameters when:

* Only default values change.

---

# 11. Operator Overloading

C# allows changing how operators work with custom classes.

Example:

Normally:

```csharp
5 + 10
```

works with numbers.

But we can define:

```csharp
Point + Point
```

---

Example:

```csharp
public class Point
{
    public int X { get; }
    public int Y { get; }


    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }


    public static Point operator +
        (Point a, Point b)
    {
        return new Point(
            a.X + b.X,
            a.Y + b.Y
        );
    }
}
```

Now:

```csharp
Point p1 = new Point(1,2);

Point p2 = new Point(3,4);


Point result = p1 + p2;
```

The `+` operator now has custom behavior.

---

# 12. Operator Overloading Guidelines

Operator overloading should make code more natural.

Good:

```text
Money + Money
```

Makes sense.

Bad:

```text
Employee + Employee
```

Usually unclear.

---

# 13. Compile-Time vs Runtime Polymorphism

| Feature       | Compile-Time     | Runtime            |
| ------------- | ---------------- | ------------------ |
| Decision Time | Compilation      | Execution          |
| Example       | Overloading      | Overriding         |
| Uses          | Method signature | Object type        |
| Keywords      | None             | virtual / override |
| Flexibility   | Lower            | Higher             |

---

# 14. Common Mistakes

---

## Mistake 1 — Creating Too Many Overloads

Example:

```csharp
Save()

Save(string)

Save(string,int)

Save(string,int,bool)

Save(string,int,bool,string)
```

The API becomes confusing.

---

## Mistake 2 — Overloads With Similar Meaning

Bad:

```csharp
Calculate(int)

Calculate(double)
```

when both behave completely differently.

---

## Mistake 3 — Using Overloading Instead of Good Design

Sometimes developers create many overloads to hide a design problem.

---

# 15. Senior Engineer Perspective

A good API should be:

* Easy to understand.
* Predictable.
* Consistent.

Overloading should make code simpler.

Example:

Good:

```csharp
SendEmail(string address)
```

```csharp
SendEmail(string address, Attachment file)
```

Both represent the same action.

---

Bad:

```csharp
SendEmail(string address)

SendEmail(string address, bool isAdmin)
```

The meaning is unclear.

---

# 🧠 Interview Questions

## Q1

What is compile-time polymorphism?

**Answer:**

A type of polymorphism where the compiler determines which method to execute before runtime.

---

## Q2

What is method overloading?

**Answer:**

Creating multiple methods with the same name but different parameters.

---

## Q3

Can you overload a method by changing only the return type?

**Answer:**

No.

Return type is not part of method signature.

---

## Q4

What is constructor overloading?

**Answer:**

Creating multiple constructors with different parameter lists.

---

## Q5

Difference between overloading and overriding?

**Answer:**

Overloading:

* Same name.
* Different parameters.
* Compile-time.

Overriding:

* Same signature.
* Different implementation.
* Runtime.

---

# 📝 Practice Questions

1. Explain compile-time polymorphism.
2. What makes two methods valid overloads?
3. Why can't return type be used for overloading?
4. Explain constructor overloading.
5. Difference between `this()` and `base()`.
6. When should you avoid overloading?
7. Explain operator overloading.
8. Compare compile-time and runtime polymorphism.



