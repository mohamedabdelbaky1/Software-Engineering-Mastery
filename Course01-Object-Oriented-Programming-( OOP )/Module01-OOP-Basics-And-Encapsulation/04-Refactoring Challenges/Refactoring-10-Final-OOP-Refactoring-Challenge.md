

This is the **final challenge of Module 01 — OOP Basics → Encapsulation**.

Here you will combine everything you learned:

✅ Classes and Objects
✅ State and Behavior
✅ Constructors
✅ Access Modifiers
✅ Properties
✅ Valid Objects
✅ Invariants
✅ Encapsulation
✅ Controlled State Transitions

The goal is to think like a professional engineer reviewing legacy code.

---

# 🔧 Refactoring Challenge 10 — Final OOP Refactoring Challenge

> **Module:** OOP Basics & Encapsulation
> **Category:** Final Refactoring Challenge
> **Difficulty:** 🔴 Advanced Module 01 Challenge
> **Language:** C#

---

# 📌 Scenario

You joined a software company maintaining a library management system.

The system works, but developers complain:

* Books can have invalid data.
* Members can borrow unlimited books.
* External code changes internal lists.
* Rules are duplicated.
* Objects cannot protect themselves.

Your task:

Refactor the system using professional OOP principles.

---

# 🔴 Legacy Code

## Library Class

```csharp id="4m9xqa"
using System.Collections.Generic;


public class Library
{
    public List<Book> Books { get; set; }

    public List<Member> Members { get; set; }



    public void BorrowBook(
        Book book,
        Member member)
    {
        book.IsBorrowed = true;

        member.BorrowedBooks.Add(book);
    }
}
```

---

# Book Class

```csharp id="8q1mvd"
public class Book
{
    public string Title { get; set; }

    public string Author { get; set; }

    public bool IsBorrowed { get; set; }
}
```

---

# Member Class

```csharp id="7n3kxp"
using System.Collections.Generic;


public class Member
{
    public string Name { get; set; }


    public List<Book> BorrowedBooks { get; set; }
}
```

---

# Example Usage

```csharp id="q9m2vx"
Library library =
    new Library();



Book book =
    new Book();



book.Title =
    "Clean Code";


book.Author =
    "Robert Martin";



Member member =
    new Member();



member.Name =
    "Ahmed";



library.BorrowBook(
    book,
    member);
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Public Mutable Collections

Current:

```csharp
public List<Book> Books {get;set;}
```

Anyone can do:

```csharp
library.Books.Clear();
```

The library loses control.

---

# ❌ Problem 2 — Invalid Book Objects

Current:

```csharp
Book book =
    new Book();
```

Creates:

```text id="1c7q4m"
Title = null

Author = null
```

A book without identity exists.

---

# ❌ Problem 3 — Public State Modification

Current:

```csharp
book.IsBorrowed = true;
```

Anyone can do:

```csharp
book.IsBorrowed = true;
```

without borrowing rules.

---

# ❌ Problem 4 — Library Controls Other Objects' State

Current:

```csharp
book.IsBorrowed = true;

member.BorrowedBooks.Add(book);
```

The library reaches inside objects and modifies them.

---

Better:

```csharp
book.Borrow();

member.AddBook(book);
```

---

# ❌ Problem 5 — No Business Rules

Missing rules:

```text id="0t2kmq"
Can unavailable books be borrowed?

Can member borrow unlimited books?

Can empty names exist?
```

---

# 🧠 Senior Engineer Analysis

---

## Question 1

Who owns book availability?

Answer:

```text id="k8m2qa"
Book
```

Because availability belongs to the book.

---

## Question 2

Who owns borrowed books?

Answer:

```text id="m4q7xp"
Member
```

Because membership owns borrowing information.

---

## Question 3

Who coordinates borrowing?

Answer:

```text id="x2v8qm"
Library
```

But it should ask objects to perform actions.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Make objects valid during creation.

---

## Step 2

Protect internal collections.

---

## Step 3

Move behavior into the correct classes.

---

## Step 4

Create controlled state changes.

---

# ✅ Refactored Solution

---

# Book Class

```csharp id="q7m2px"
using System;


public class Book
{
    public string Title { get; }


    public string Author { get; }


    public bool IsBorrowed { get; private set; }



    public Book(
        string title,
        string author)
    {
        if(string.IsNullOrWhiteSpace(title))
        {
            throw new ArgumentException(
                "Title required.");
        }


        if(string.IsNullOrWhiteSpace(author))
        {
            throw new ArgumentException(
                "Author required.");
        }


        Title = title;

        Author = author;

        IsBorrowed = false;
    }



    public void Borrow()
    {
        if(IsBorrowed)
        {
            throw new InvalidOperationException(
                "Book already borrowed.");
        }


        IsBorrowed = true;
    }



    public void Return()
    {
        IsBorrowed = false;
    }
}
```

---

# Member Class

```csharp id="r5m8qx"
using System;
using System.Collections.Generic;


public class Member
{
    private readonly List<Book> borrowedBooks =
        new();



    public string Name { get; }


    public IReadOnlyList<Book> BorrowedBooks =>
        borrowedBooks;



    public Member(
        string name)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name required.");
        }


        Name = name;
    }



    public void AddBook(Book book)
    {
        if(book == null)
        {
            throw new ArgumentNullException(
                nameof(book));
        }


        borrowedBooks.Add(book);
    }



    public void RemoveBook(Book book)
    {
        borrowedBooks.Remove(book);
    }
}
```

---

# Library Class

```csharp id="w2n8mv"
using System;
using System.Collections.Generic;


public class Library
{
    private readonly List<Book> books =
        new();



    private readonly List<Member> members =
        new();



    public IReadOnlyList<Book> Books =>
        books;



    public IReadOnlyList<Member> Members =>
        members;



    public void AddBook(Book book)
    {
        books.Add(book);
    }



    public void AddMember(Member member)
    {
        members.Add(member);
    }



    public void BorrowBook(
        Book book,
        Member member)
    {
        if(!books.Contains(book))
        {
            throw new InvalidOperationException(
                "Book does not belong to library.");
        }


        book.Borrow();


        member.AddBook(book);
    }
}
```

---

# 🧪 Test Cases

```csharp id="8v2mqa"
public class Program
{
    public static void Main()
    {
        Library library =
            new Library();



        Book book =
            new Book(
                "Clean Code",
                "Robert Martin");



        Member member =
            new Member(
                "Ahmed");



        library.AddBook(book);

        library.AddMember(member);



        library.BorrowBook(
            book,
            member);



        Console.WriteLine(
            book.IsBorrowed);
    }
}
```

---

# Output

```text id="1a9mvp"
True
```

---

# Invalid Test

Borrow same book twice:

```csharp id="9k2mfx"
library.BorrowBook(
    book,
    member);


library.BorrowBook(
    book,
    member);
```

Result:

```text id="q4m8xa"
Exception:

Book already borrowed.
```

---

# 🔍 Final Refactoring Explanation

---

# Before

```text id="z3m8qx"
Library

controls everything

↓

Book

data only

↓

Member

data only
```

---

# After

```text id="m9x2qa"
Library

coordinates


Book

owns availability


Member

owns borrowed books
```

---

# Encapsulation Improvements

Before:

```text id="7xq2mp"
Anyone can modify anything
```

After:

```text id="k4m8vx"
Objects protect themselves
```

---

# Constructor Improvements

Before:

```csharp
new Book();
```

Possible.

After:

```csharp
new Book(
    "Title",
    "Author");
```

Required data is enforced.

---

# Behavior Improvements

Before:

```csharp
book.IsBorrowed = true;
```

After:

```csharp
book.Borrow();
```

The object controls its own transition.

---

# State Ownership

| State              | Owner   |
| ------------------ | ------- |
| Book availability  | Book    |
| Borrowed books     | Member  |
| Library collection | Library |

---

# 🎤 Interview Discussion

---

## Q1: What was the biggest design problem?

### Answer:

Objects were only data containers, while external classes controlled their state and behavior.

---

## Q2: Why should Book control borrowing?

### Answer:

Because Book owns the rule related to availability.

---

## Q3: Why protect collections?

### Answer:

To prevent external code from bypassing business rules.

---

## Q4: What makes the final design better?

### Answer:

Each object owns its state, protects its invariants, and exposes meaningful operations.

---

# 🧠 Final Refactoring Checklist

```text id="q8m3xp"
☑ Are objects valid after creation?

☑ Is important state private?

☑ Are changes controlled?

☑ Does each class own its behavior?

☑ Can invalid states happen?

☑ Are responsibilities clear?
```

---

# 🏁 Module 01 Refactoring Challenges Completed 🎉

You have now practiced:

✅ Encapsulation
✅ Constructors
✅ Properties
✅ Access Modifiers
✅ Valid State
✅ Invariants
✅ State Ownership
✅ Controlled Behavior
✅ Collection Protection
✅ Responsibility Assignment

---

