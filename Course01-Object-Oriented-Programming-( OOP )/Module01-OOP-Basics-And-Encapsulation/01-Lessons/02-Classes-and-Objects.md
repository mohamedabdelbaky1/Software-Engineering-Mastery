# 🏗️ Lesson 02 — Classes and Objects

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ From Concepts to Code](#1️⃣-from-concepts-to-code)
- [2️⃣ What Is a Class?](#2️⃣-what-is-a-class)
- [3️⃣ What Is an Object?](#3️⃣-what-is-an-object)
- [4️⃣ Class vs Object](#4️⃣-class-vs-object)
- [5️⃣ What Does Instance Mean?](#5️⃣-what-does-instance-mean)
- [6️⃣ Creating Objects with `new`](#6️⃣-creating-objects-with-new)
- [7️⃣ Multiple Objects from the Same Class](#7️⃣-multiple-objects-from-the-same-class)
- [8️⃣ Independent Object State](#8️⃣-independent-object-state)
- [9️⃣ Reference Variables in C#](#9️⃣-reference-variables-in-c)
- [🔟 Reference Assignment](#-reference-assignment)
- [1️⃣1️⃣ Object Identity](#1️⃣1️⃣-object-identity)
- [1️⃣2️⃣ `null` References](#1️⃣2️⃣-null-references)
- [1️⃣3️⃣ Basic Memory Mental Model](#1️⃣3️⃣-basic-memory-mental-model)
- [1️⃣4️⃣ Classes Are Definitions, Not Objects](#1️⃣4️⃣-classes-are-definitions-not-objects)
- [1️⃣5️⃣ Object Creation Is Not Object Design](#1️⃣5️⃣-object-creation-is-not-object-design)
- [1️⃣6️⃣ Common Mistakes](#1️⃣6️⃣-common-mistakes)
- [1️⃣7️⃣ Junior vs Senior Thinking](#1️⃣7️⃣-junior-vs-senior-thinking)
- [🎤 Interview Perspective](#-interview-perspective)
- [🧩 Mental Models](#-mental-models)
- [📝 Cheat Sheet](#-cheat-sheet)
- [✅ Key Takeaways](#-key-takeaways)
- [➡️ Next Lesson](#️-next-lesson)

---

# 🎯 Learning Goals

By the end of this lesson, you should understand:

- What a **class** represents.
- What an **object** represents.
- The difference between a class and an object.
- What the word **instance** means.
- How objects are created in C# using `new`.
- Why multiple objects created from the same class can hold different state.
- What a **reference variable** means in C#.
- What happens when two variables reference the same object.
- Why object identity matters.
- What `null` means for reference types.
- A simple mental model for how objects and references behave in memory.
- Why knowing class syntax is not the same as knowing object-oriented design.

---

# 1️⃣ From Concepts to Code

In Lesson 01, we introduced the idea that an object can conceptually have:

```text
Object
├── State
├── Behavior
└── Responsibilities
```

Now we need a way to describe such objects in C#.

Suppose our domain contains a car.

Conceptually:

```text
Car
│
├── Brand
├── Color
├── Speed
│
├── Start()
└── Accelerate()
```

In C#, we can represent this concept using a **class**.

---

# 2️⃣ What Is a Class?

A **class** defines the structure and behavior that objects created from it can have.

Example:

```csharp
public class Car
{
    public string Brand;
    public string Color;
    public int Speed;

    public void Start()
    {
        Console.WriteLine("Car started.");
    }

    public void Accelerate()
    {
        Speed += 10;
    }
}
```

The class describes:

### State

```text
Brand
Color
Speed
```

### Behavior

```text
Start()
Accelerate()
```

But the class itself is not a specific BMW, Mercedes, or Toyota.

It is a **definition**.

---

## 🧠 A Useful Analogy

Think of a class as a blueprint:

```text
             Car Class
                │
                │ defines
                ▼
       ┌───────────────────┐
       │ Brand             │
       │ Color             │
       │ Speed             │
       │ Start()           │
       │ Accelerate()      │
       └───────────────────┘
```

From this definition, we can create many actual objects.

> [!IMPORTANT]
> A class describes what its objects can contain and do.  
> It is not itself one of those objects.

---

# 3️⃣ What Is an Object?

An **object** is a concrete instance created from a class.

Given:

```csharp
public class Car
{
    public string Brand;
    public int Speed;
}
```

we can create an object:

```csharp
Car car1 = new Car();
```

Now `car1` refers to an actual `Car` object.

We can give it state:

```csharp
car1.Brand = "BMW";
car1.Speed = 100;
```

Another object can hold different state:

```csharp
Car car2 = new Car();

car2.Brand = "Mercedes";
car2.Speed = 70;
```

The same class created two different objects.

---

# 4️⃣ Class vs Object

This distinction must be completely clear.

| Class | Object |
|---|---|
| A definition | A concrete instance |
| Describes structure | Holds actual state |
| Declared once | Can be created many times |
| Defines behavior | Executes behavior |
| Example: `Car` | Example: `car1` |

Example:

```csharp
public class Car
{
    public string Brand;
}
```

This:

```csharp
Car
```

is the **class**.

This:

```csharp
new Car()
```

creates an **object**.

This:

```csharp
Car car1 = new Car();
```

creates one object and stores a reference to it in `car1`.

---

## Visual Model

```text
              Class
               Car
                │
        ┌───────┼───────┐
        │       │       │
        ▼       ▼       ▼
      Object  Object  Object
      car1    car2    car3
```

One class can be used to create many objects.

---

# 5️⃣ What Does Instance Mean?

The word **instance** means:

> A specific object created from a particular class.

Example:

```csharp
Car car1 = new Car();
Car car2 = new Car();
```

Both `car1` and `car2` refer to instances of `Car`.

So these phrases are closely related:

```text
Object
Instance
Instance of a class
```

Example:

> `car1` refers to an instance of `Car`.

---

# 6️⃣ Creating Objects with `new`

In C#, we commonly create an object using the `new` operator.

```csharp
Car car1 = new Car();
```

Break this statement down:

```text
Car        car1        =        new Car();
│           │                     │
│           │                     └─ create a new Car object
│           │
│           └─ variable that can reference a Car
│
└─ type
```

The expression:

```csharp
new Car()
```

creates a new object.

The variable:

```csharp
car1
```

stores a **reference** to that object.

> [!NOTE]
> We are using a simplified mental model here.  
> Detailed CLR memory behavior, stack/heap internals, and garbage collection will come later.

---

# 7️⃣ Multiple Objects from the Same Class

A class can produce many independent objects.

```csharp
Car car1 = new Car();
Car car2 = new Car();
Car car3 = new Car();
```

These are three different objects.

We can assign different state:

```csharp
car1.Brand = "BMW";
car1.Speed = 100;

car2.Brand = "Mercedes";
car2.Speed = 80;

car3.Brand = "Toyota";
car3.Speed = 60;
```

Conceptually:

```text
Car Class
   │
   ├── car1
   │    ├── Brand = BMW
   │    └── Speed = 100
   │
   ├── car2
   │    ├── Brand = Mercedes
   │    └── Speed = 80
   │
   └── car3
        ├── Brand = Toyota
        └── Speed = 60
```

All three share the same class definition.

But each object has its own state.

---

# 8️⃣ Independent Object State

Consider:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Speed = 100;
car2.Speed = 40;
```

If we change:

```csharp
car1.Speed = 120;
```

the result is:

```text
car1.Speed = 120
car2.Speed = 40
```

Why?

Because `car1` and `car2` refer to two different objects.

Their instance state is independent.

---

## Visual Model

```text
car1 ─────► Car Object #1
            Speed = 120

car2 ─────► Car Object #2
            Speed = 40
```

Changing Object #1 does not automatically change Object #2.

---

# 9️⃣ Reference Variables in C#

This is one of the most important ideas in C# object behavior.

Given:

```csharp
Car car1 = new Car();
```

a useful mental model is:

```text
car1
  │
  │ reference
  ▼
Car Object
```

The variable `car1` is not conceptually the object itself.

It stores a **reference** that allows us to reach the object.

This becomes important when references are copied.

---

# 🔟 Reference Assignment

Consider:

```csharp
Car car1 = new Car();

car1.Brand = "BMW";

Car car2 = car1;
```

A beginner may imagine that a second object has been created.

It has not.

No `new Car()` appears on the last line.

Instead:

```csharp
Car car2 = car1;
```

copies the reference.

Now both variables refer to the same object.

```text
car1 ───┐
        │
        ▼
      Car Object
      Brand = BMW
        ▲
        │
car2 ───┘
```

Now:

```csharp
car2.Brand = "Mercedes";
```

If we print:

```csharp
Console.WriteLine(car1.Brand);
```

we get:

```text
Mercedes
```

Why?

Because `car1` and `car2` both refer to the same object.

---

## Compare the Two Cases

### Case 1 — Two Objects

```csharp
Car car1 = new Car();
Car car2 = new Car();
```

Conceptually:

```text
car1 ───► Object #1

car2 ───► Object #2
```

### Case 2 — One Object, Two References

```csharp
Car car1 = new Car();
Car car2 = car1;
```

Conceptually:

```text
car1 ───┐
        ▼
      Object #1
        ▲
car2 ───┘
```

This distinction is extremely important.

---

# 1️⃣1️⃣ Object Identity

Two objects can contain exactly the same data and still be different objects.

Example:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car2.Brand = "BMW";
```

Both contain:

```text
Brand = BMW
```

But they are still two distinct objects.

Conceptually:

```text
car1 ───► Object #1
          Brand = BMW

car2 ───► Object #2
          Brand = BMW
```

This is related to **object identity**.

Two objects can have:

```text
Same state
```

without being:

```text
The same object
```

> [!IMPORTANT]
> **Same data does not automatically mean same identity.**

We will study equality more deeply later in the OOP course.

---

# 1️⃣2️⃣ `null` References

A reference variable does not always have to point to an object.

Example:

```csharp
Car car = null;
```

Conceptually:

```text
car
 │
 └──► no Car object
```

If we then attempt:

```csharp
car.Start();
```

the program cannot call `Start()` because `car` does not reference an object.

This can result in:

```text
NullReferenceException
```

---

## Modern C# Note

With nullable reference types enabled, C# can help detect some potential null problems at compile time.

For example:

```csharp
Car? car = null;
```

The `?` communicates:

> This reference is allowed to be null.

We will cover nullable reference types in more detail later.

---

# 1️⃣3️⃣ Basic Memory Mental Model

For now, use a deliberately simple model.

Consider:

```csharp
Car car = new Car();
```

Think:

```text
Variable
  car
   │
   │ reference
   ▼
Object
 Car
```

For two independent objects:

```csharp
Car car1 = new Car();
Car car2 = new Car();
```

Think:

```text
car1 ─────► Car Object #1

car2 ─────► Car Object #2
```

For two references to the same object:

```csharp
Car car1 = new Car();
Car car2 = car1;
```

Think:

```text
car1 ───┐
        ▼
      Car Object
        ▲
car2 ───┘
```

> [!WARNING]
> Do not overlearn the phrase:
>
> `reference variable = stack` and `object = heap`
>
> as a universal rule.
>
> That is an oversimplification of CLR behavior and can become misleading.
> For now, focus on **reference semantics**.

---

# 1️⃣4️⃣ Classes Are Definitions, Not Objects

A common beginner mistake is to mentally treat the class itself as if it were one object.

Consider:

```csharp
public class Student
{
    public string Name;
}
```

There is no actual student's name yet.

Only after creating an instance:

```csharp
Student student1 = new Student();
student1.Name = "Ali";
```

do we have an object with real state.

Then we can create another:

```csharp
Student student2 = new Student();
student2.Name = "Sara";
```

Conceptually:

```text
Student Class
     │
     ├── Student Object #1
     │      Name = Ali
     │
     └── Student Object #2
            Name = Sara
```

The class defines what a student object can look like.

The objects contain actual state.

---

# 1️⃣5️⃣ Object Creation Is Not Object Design

Knowing how to write:

```csharp
Car car = new Car();
```

does not mean we know how to design a good `Car` class.

For example:

```csharp
public class Car
{
    public string A;
    public int B;
    public string C;

    public void DoSomething()
    {
    }
}
```

This is valid C#.

But the design is unclear.

Questions still remain:

```text
What does this object represent?

What state should it own?

What behavior belongs here?

What rules should it protect?

Why does this class exist?
```

This distinction matters throughout the course:

```text
C# OOP Syntax
        ≠
Object-Oriented Design Skill
```

---

# 1️⃣6️⃣ Common Mistakes

## ❌ Mistake 1 — Class and Object Are the Same Thing

They are not.

```text
Class  → Definition
Object → Instance
```

---

## ❌ Mistake 2 — Every Variable of a Class Type Is a New Object

Consider:

```csharp
Car car1 = new Car();
Car car2 = car1;
```

There is only one `new`.

Therefore, only one `Car` object was created here.

There are two references.

---

## ❌ Mistake 3 — Same State Means Same Object

This is false:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car2.Brand = "BMW";
```

They can contain equal-looking state while remaining separate objects.

---

## ❌ Mistake 4 — `new` Is Just Syntax with No Design Meaning

`new` means a new instance is being created.

Uncontrolled object creation can matter in larger designs.

Later we will study ideas such as:

```text
Factories
Dependency Injection
Object Lifetime
```

But not yet.

---

## ❌ Mistake 5 — Public Fields Are Good Because They Are Easy

Example:

```csharp
public class BankAccount
{
    public decimal Balance;
}
```

This is easy to use:

```csharp
account.Balance = -5000;
```

But easy access can destroy valid object state.

We will address this through Encapsulation.

---

## ❌ Mistake 6 — Memorizing Stack vs Heap Instead of Understanding References

The key lesson now is:

```text
A reference can point to an object.

Multiple references can point to the same object.

Multiple `new` expressions can create distinct objects.
```

That mental model is more useful at this stage.

---

# 1️⃣7️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> I can create objects using `new`.

## 👨‍💻 Intermediate Thinking

> I understand that objects have independent state and reference semantics.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
Why should this object exist?

Who should create it?

Who should own it?

Who is allowed to modify it?

What state must remain valid?

What other objects should reference it?

Can multiple components share this object safely?

What happens if this object is mutable?
```

Not all of these questions need answers yet.

But they show how simple class/object syntax eventually connects to real design decisions.

---

# 🎤 Interview Perspective

When asked:

> **What is the difference between a class and an object?**

A weak answer is:

> A class is a blueprint and an object is an instance.

That is technically correct, but incomplete.

A stronger explanation is:

> A class defines the structure and behavior available to its instances, while an object is a concrete runtime instance with its own identity and state. Multiple objects can be created from the same class, and reference variables can refer to those objects.

Similarly, if asked:

> **What happens when you assign one class variable to another in C#?**

The key idea is:

```text
The reference is copied.

The object is not automatically cloned.
```

---

# 🧩 Mental Models

## Class → Objects

```text
                  Car Class
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
      Object #1   Object #2   Object #3
         BMW       Mercedes      Toyota
```

---

## Variable → Object Reference

```text
car
 │
 ▼
Car Object
```

---

## Two Independent Objects

```text
car1 ─────► Object #1

car2 ─────► Object #2
```

---

## Two References to One Object

```text
car1 ───┐
        │
        ▼
      Object #1
        ▲
        │
car2 ───┘
```

---

## Core Relationship

```text
Class
  │
  │ defines
  ▼
Object
  │
  ├── State
  ├── Behavior
  └── Identity
```

---

# 📝 Cheat Sheet

| Concept | Meaning |
|---|---|
| **Class** | Definition of structure and behavior |
| **Object** | Concrete instance created from a class |
| **Instance** | Another term for an object created from a class |
| **`new`** | Creates a new instance |
| **Reference Variable** | Holds a reference used to reach an object |
| **Object State** | Actual data stored for a specific instance |
| **Object Identity** | Distinguishes one object from another |
| **Reference Assignment** | Copies a reference, not automatically the object |
| **`null`** | The reference currently points to no object |
| **Independent Instances** | Different objects created by separate `new` expressions |

---

# ✅ Key Takeaways

1. A **class** is a definition; an **object** is an instance.
2. One class can create many objects.
3. Each object can maintain independent state.
4. `new` creates a new object instance.
5. A variable such as `car1` holds a reference to an object.
6. Assigning one reference variable to another does not automatically clone the object.
7. Multiple variables can reference the same object.
8. Two objects can contain the same values while having different identities.
9. `null` means a reference currently points to no object.
10. Understanding reference semantics is essential before studying more advanced OOP.
11. Knowing how to create objects is not the same as knowing how to design good objects.

---

# ➡️ Next Lesson

## 🧩 Lesson 03 — State, Behavior, and Identity

Next, we will study these three characteristics in depth:

- Object state
- Object behavior
- Object identity
- Independent state
- State transitions
- Behavior that changes state
- Object responsibility
- Object interaction
- Why identity matters even when two objects contain the same data

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 02 of 08 ✅
</p>
