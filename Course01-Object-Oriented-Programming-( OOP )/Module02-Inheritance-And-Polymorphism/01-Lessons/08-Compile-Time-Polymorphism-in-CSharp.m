
# Lesson 08 — Compile-Time Polymorphism in C#

> **Module:** Inheritance and Polymorphism  
> **Topic:** Compile-Time Polymorphism  
> **Language:** C#  
> **Level:** Intermediate  
> **Focus:** Understanding Method Resolution Before Runtime

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

- What compile-time polymorphism means.
- How the compiler selects methods.
- Method overloading in C#.
- Constructor overloading.
- Optional parameters vs overloading.
- Overloading rules.
- Valid and invalid overloads.
- Operator overloading basics.
- Common mistakes when using overloading.
- When compile-time polymorphism improves design.

---

# 1. Introduction to Compile-Time Polymorphism

In the previous lesson, we discussed two types of polymorphism:

```text
1. Compile-Time Polymorphism

2. Runtime Polymorphism
````

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

```text
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



