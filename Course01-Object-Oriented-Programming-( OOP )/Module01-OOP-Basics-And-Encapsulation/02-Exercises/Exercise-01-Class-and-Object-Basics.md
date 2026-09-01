

# 🧩 Exercise 01 — Class and Object Basics

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟢 Foundation
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Classes
* Objects
* Instances
* Object creation
* Object state
* Basic responsibility modeling

---

## Why This Matters

In professional software development, everything starts with correctly identifying:

* What objects exist in the system?
* What information does each object own?
* What responsibilities belong to each object?

A common beginner mistake is writing classes based on database tables or random data containers.

A professional developer starts by modeling **real-world responsibilities**.

---

# 🏢 Real-World Scenario

## Online Book Store System

You are building a simple part of an online bookstore.

The system needs to represent books available for customers.

A book has:

* A title
* An author
* A price
* An availability status

The system should allow creating multiple books because a bookstore contains many different books.

---

# 📌 Requirements

The system should:

### Book Entity

Create a `Book` class that represents a real book.

The book should contain:

* Title
* Author
* Price
* Availability status

---

### Object Creation

The system should allow creating multiple book objects.

Example:

```text
Book 1:
Title: Clean Code
Author: Robert Martin

Book 2:
Title: The Pragmatic Programmer
Author: David Thomas
```

Each book object should maintain its own data.

---

### Behavior

The book should have a behavior:

```
DisplayInformation()
```

This method should display:

* Title
* Author
* Price
* Availability

---

# 🧠 Engineering Focus

Before writing code, think like a software engineer.

---

## 1. What is the Object?

Ask:

> What thing exists in this domain?

Answer:

```
Book
```

---

## 2. What is the State?

Ask:

> What does the object need to remember?

Possible state:

```text
Title
Author
Price
Availability
```

---

## 3. What is the Responsibility?

The `Book` class should:

✅ Know its own information
✅ Display its own information

It should not:

❌ Manage customers
❌ Process payments
❌ Handle database operations

---

## 4. Object Independence

Consider:

```csharp
Book book1 = new Book();
Book book2 = new Book();
```

These should be:

```text
Two different objects

with

Two different states
```

Changing one book should not affect another.

---

# ❌ Bad Design Example

```csharp
public class Book
{
    public string Data;
}
```

Usage:

```csharp
Book book = new Book();

book.Data =
"Clean Code, Robert Martin, 500, Available";
```

---

## Why This Works Technically

The compiler accepts it.

The program can store information.

---

## Why This Is Poor Design

The class does not communicate meaning.

Problems:

### 1. No clear state

What is `Data`?

```text
Title?
Author?
Price?
Status?
```

Nobody knows.

---

### 2. No object responsibility

The object is just a storage box.

---

### 3. Hard to maintain

Imagine adding:

```text
ISBN
Publisher
Category
Rating
```

Now the string format becomes difficult to manage.

---

# ✅ Expected Design Direction

Before coding, think about the design.

---

## Required Class

Create:

```text
Book
```

---

## Suggested State

The object should own:

```text
Title
Author
Price
IsAvailable
```

---

## Suggested Behavior

The object should provide:

```text
DisplayInformation()
```

---

## Relationship

The design should look like:

```text
Book Class

      |
      |
      ↓

Book Object 1
Book Object 2
Book Object 3
```

Each object has independent state.

---

# 💻 Solution

```csharp
using System;

public class Book
{
    public string Title;
    public string Author;
    public decimal Price;
    public bool IsAvailable;


    public void DisplayInformation()
    {
        Console.WriteLine($"Title: {Title}");
        Console.WriteLine($"Author: {Author}");
        Console.WriteLine($"Price: {Price}");
        Console.WriteLine($"Available: {IsAvailable}");
    }
}
```

---

## Creating Objects

```csharp
public class Program
{
    public static void Main()
    {
        Book book1 = new Book();

        book1.Title = "Clean Code";
        book1.Author = "Robert Martin";
        book1.Price = 50;
        book1.IsAvailable = true;


        Book book2 = new Book();

        book2.Title = "The Pragmatic Programmer";
        book2.Author = "David Thomas";
        book2.Price = 60;
        book2.IsAvailable = false;


        book1.DisplayInformation();

        Console.WriteLine();

        book2.DisplayInformation();
    }
}
```

---

# 🔍 Solution Explanation

## Why Create a Book Class?

Because `Book` represents a meaningful entity in the domain.

Instead of:

```text
Random variables everywhere
```

we have:

```text
Book object
    |
    ├── Title
    ├── Author
    ├── Price
    └── Availability
```

---

# Why Are These Fields Inside Book?

Because the information belongs to the book.

Example:

```text
Book owns:

Title
Author
Price
Availability
```

A different object should not be responsible for storing this information.

---

# Why Does Book Have DisplayInformation()?

Because displaying book information is a behavior related to the book itself.

The object knows its own data.

---

# Why Can We Create Multiple Books?

Because:

```csharp
Book book1 = new Book();

Book book2 = new Book();
```

creates two separate instances.

Conceptually:

```text
book1
 |
 ↓
Book Object #1

book2
 |
 ↓
Book Object #2
```

Each object has independent state.

---

# 🧪 Test Cases

## Test Case 1 — Create a Book

Input:

```csharp
Book book = new Book();

book.Title = "Clean Code";
book.Author = "Robert Martin";
book.Price = 50;
book.IsAvailable = true;
```

Expected:

```text
Title: Clean Code
Author: Robert Martin
Price: 50
Available: True
```

---

## Test Case 2 — Multiple Objects

Code:

```csharp
Book book1 = new Book();

book1.Title = "Book A";


Book book2 = new Book();

book2.Title = "Book B";
```

Expected:

```text
book1.Title = Book A

book2.Title = Book B
```

Changing one should not change the other.

---

## Test Case 3 — Object Identity

Code:

```csharp
Book book1 = new Book();

Book book2 = new Book();
```

Expected:

```text
Two different objects
```

Even if:

```csharp
book1.Title = "C#";
book2.Title = "C#";
```

they are still different instances.

---

# 💡 Senior Engineer Notes

## Current Design Level

This solution is intentionally simple.

It demonstrates:

✅ Class modeling
✅ Object creation
✅ Object state
✅ Object responsibility

---

## Production Improvements

In a production system, we would improve this design by adding:

### 1. Encapsulation

Instead of:

```csharp
public string Title;
```

we may use:

```csharp
public string Title { get; private set; }
```

---

### 2. Constructor Validation

Instead of:

```csharp
Book book = new Book();

book.Title = "";
```

we may require:

```csharp
new Book(title, author, price);
```

---

### 3. Domain Rules

Example:

```text
Price cannot be negative.

Title cannot be empty.
```

---

### 4. Better Behavior

Instead of exposing:

```csharp
IsAvailable = false;
```

we may use:

```csharp
book.MarkAsSold();
```

because selling a book is a domain action.

---

# 🎤 Interview Connection

This exercise prepares you for:

---

## Question 1

### What is the difference between a class and an object?

Answer:

A class is a blueprint that defines structure and behavior.

An object is a runtime instance created from that class with its own state and identity.

---

## Question 2

### Why do we create classes?

Answer:

Classes help organize related state and behavior into meaningful objects with clear responsibilities.

---

## Question 3

### Can multiple objects be created from the same class?

Answer:

Yes.

A class defines the structure, while each object instance maintains its own independent state.

---

## Question 4

### What makes a good class?

Answer:

A good class:

* Represents a meaningful concept.
* Owns related data.
* Has clear responsibilities.
* Avoids unrelated behavior.

---

# 🧠 Engineering Reflection

Before moving to the next exercise, answer:

```text
1. Why does Book need to exist as a class?

2. What data belongs to Book?

3. What behavior belongs to Book?

4. What behavior should NOT belong to Book?

5. What happens if we create 100 Book objects?

6. Why does each object need independent state?
```

---

# 🏁 Key Takeaways

1. A class represents a concept in the domain.
2. An object is a concrete instance of a class.
3. Objects contain their own state.
4. Multiple objects from the same class can have different values.
5. Good classes represent responsibilities, not just data.
6. Object modeling starts by understanding the domain.
7. This exercise introduces the foundation required for professional OOP design.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 01 of 19 ✅
</p>
```

---


