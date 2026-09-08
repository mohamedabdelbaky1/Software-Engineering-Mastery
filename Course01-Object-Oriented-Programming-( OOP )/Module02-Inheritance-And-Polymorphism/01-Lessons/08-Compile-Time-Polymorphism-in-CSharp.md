# Lesson 08 --- Compile-Time Polymorphism in C

> **Module:** Inheritance and Polymorphism\
> **Topic:** Compile-Time Polymorphism\
> **Language:** C#\
> **Focus:** Understanding Method Resolution Before Runtime

------------------------------------------------------------------------

# Learning Objectives

By the end of this lesson, you should understand:

-   What compile-time polymorphism means.
-   How the compiler selects methods.
-   Method overloading in C#.
-   Constructor overloading.
-   Optional parameters vs overloading.
-   Overloading rules.
-   Valid and invalid overloads.
-   Operator overloading basics.
-   Common mistakes when using overloading.
-   When compile-time polymorphism improves design.

------------------------------------------------------------------------

# 1. Introduction to Compile-Time Polymorphism

Compile-time polymorphism means that the compiler decides which method
should be called before the program runs.

The most common example:

``` text
Method Overloading
```

------------------------------------------------------------------------

# 2. What Is Method Overloading?

Method overloading means:

> Having multiple methods with the same name but different parameters.

Example:

``` csharp
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

The compiler chooses the correct method based on:

-   Method name
-   Number of parameters
-   Parameter types
-   Parameter order

------------------------------------------------------------------------

# 3. Method Signature

A method signature includes:

-   Method name
-   Number of parameters
-   Parameter types
-   Parameter order

Return type alone cannot create an overload.

------------------------------------------------------------------------

# 4. Constructor Overloading

Constructors can also be overloaded.

``` csharp
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

------------------------------------------------------------------------

# 5. Constructor Chaining with this()

When constructors share logic, we can use:

``` csharp
this()
```

Example:

``` csharp
public Product()
    : this("Unknown", 0)
{

}
```

------------------------------------------------------------------------

# 6. Operator Overloading

C# allows changing how operators work with custom classes.

Example:

``` csharp
public static Point operator +(Point a, Point b)
{
    return new Point(
        a.X + b.X,
        a.Y + b.Y
    );
}
```

------------------------------------------------------------------------

# 7. Compile-Time vs Runtime Polymorphism

  Feature         Compile-Time       Runtime
  --------------- ------------------ --------------------
  Decision Time   Compilation        Execution
  Example         Overloading        Overriding
  Uses            Method signature   Object type
  Keywords        None               virtual / override

------------------------------------------------------------------------

# 8. Common Mistakes

## Mistake 1 --- Creating Too Many Overloads

Too many overloads make APIs difficult to understand.

## Mistake 2 --- Overloads With Similar Meaning

Overloads should represent the same operation with different inputs.

## Mistake 3 --- Using Overloading Instead of Good Design

Sometimes many overloads hide a design problem.

------------------------------------------------------------------------

# Interview Questions

## What is compile-time polymorphism?

A type of polymorphism where the compiler determines which method to
execute before runtime.

## What is method overloading?

Creating multiple methods with the same name but different parameters.

## Can you overload a method by changing only the return type?

No. Return type is not part of method signature.

------------------------------------------------------------------------

# Practice Questions

1.  Explain compile-time polymorphism.
2.  What makes two methods valid overloads?
3.  Why can't return type be used for overloading?
4.  Explain constructor overloading.
5.  Difference between this() and base().
6.  When should you avoid overloading?
7.  Explain operator overloading.
8.  Compare compile-time and runtime polymorphism.

------------------------------------------------------------------------

# Key Takeaways

``` text
Compile-Time Polymorphism:

The compiler decides behavior.

Main examples:

1. Method Overloading

2. Constructor Overloading

3. Operator Overloading

Overloading requires:

Same name

+

Different parameters

Return type alone is not enough.
```
