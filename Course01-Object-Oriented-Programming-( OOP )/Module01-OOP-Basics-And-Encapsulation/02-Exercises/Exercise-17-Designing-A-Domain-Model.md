

# 🧩 Exercise 17 — Designing a Domain Model

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🔴 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Domain modeling
* Identifying objects from requirements
* Entity design
* Object responsibilities
* Relationships between objects
* Encapsulation decisions
* Separating data from behavior

---

# Why This Matters

A common beginner approach:

```text id="1f5r3v"
Read requirements

↓

Create random classes

↓

Put properties everywhere
```

Professional developers think:

```text id="5m7z8q"
Understand business

↓

Identify domain objects

↓

Assign responsibilities

↓

Design interactions

↓

Write code
```

---

# 🏢 Real-World Scenario

# Library Management System

You are designing a library system.

The system should manage:

* Books
* Members
* Borrowing operations

---

# Business Description

A library contains many books.

Members can borrow books.

A book can only be borrowed if it is available.

A member cannot borrow more than the allowed limit.

When a book is returned, it becomes available again.

---

# 📌 Requirements

Design the domain model.

---

# Book Requirements

A book has:

```text id="7h3k1a"
Book Id

Title

Author

Availability Status
```

Rules:

```text id="9m1v6z"
Book cannot be borrowed twice.

Book availability changes through borrowing actions.
```

---

# Member Requirements

A member has:

```text id="2w6q9b"
Member Id

Name

Borrowed Books
```

Rules:

```text id="3k8x2m"
Member cannot exceed borrowing limit.

Member cannot return a book they did not borrow.
```

---

# Library Requirements

The library should:

```text id="5f9c3a"
Register members.

Add books.

Borrow books.

Return books.
```

---

# 🧠 Engineering Focus

Before coding, analyze the domain.

---

# Question 1

## What Are The Objects?

From the requirements:

```text id="x7n2k4"
Book

Member

Library
```

These are domain concepts.

---

# Question 2

## Who Owns The Behavior?

Example:

Borrowing a book.

Bad:

```text id="8k4z1p"
LibraryService changes everything
```

Better:

```text id="6m9y2r"
Library coordinates

Member owns borrowing rules

Book owns availability rules
```

---

# Question 3

## What Is The Relationship?

```text id="q2k7m5"

Library

 |
 |
 +------ Books

 |
 |
 +------ Members


Member

 |
 |
 +------ Borrowed Books

```

---

# ❌ Bad Design Example

```csharp id="w3q9m1"
public class LibrarySystem
{
    public List<string> Books;

    public List<string> Members;


    public void BorrowBook()
    {
        // Everything happens here
    }


    public void ReturnBook()
    {
        // Everything happens here
    }
}
```

---

# Why This Is Poor Design

---

## 1. No Domain Objects

The system only has:

```text id="h5q7z3"
Strings
Lists
Methods
```

Not real concepts.

---

## 2. Rules Are Centralized

The library knows:

* Book rules.
* Member rules.
* Borrowing rules.

This creates a large class.

---

## 3. Objects Have No Responsibility

A book is just text.

A member is just text.

---

# ✅ Expected Design Direction

Create:

```text id="8c5v2a"
Book

Member

Library
```

Each object owns relevant behavior.

---

# Design Responsibilities

## Book

Owns:

```text id="p3n7x8"
Availability

Borrow state

Return state
```

---

## Member

Owns:

```text id="r8m2q4"
Borrowed books

Borrowing limit
```

---

## Library

Owns:

```text id="v6k1z9"
Coordination

Book/member registration

Borrow workflow
```

---

# 💻 Solution

## Book Status

```csharp id="s8n4k2"
public enum BookStatus
{
    Available,
    Borrowed
}
```

---

# Book Class

```csharp id="m5q9w1"
public class Book
{
    public int Id { get; }

    public string Title { get; }

    public string Author { get; }

    public BookStatus Status { get; private set; }


    public Book(
        int id,
        string title,
        string author)
    {
        Id = id;
        Title = title;
        Author = author;

        Status = BookStatus.Available;
    }


    public void Borrow()
    {
        if (Status == BookStatus.Borrowed)
        {
            throw new InvalidOperationException(
                "Book already borrowed.");
        }

        Status = BookStatus.Borrowed;
    }


    public void Return()
    {
        Status = BookStatus.Available;
    }
}
```

---

# Member Class

```csharp id="k7m2v5"
using System.Collections.Generic;


public class Member
{
    private readonly List<Book> borrowedBooks = new();


    public int Id { get; }

    public string Name { get; }


    public IReadOnlyList<Book> BorrowedBooks 
        => borrowedBooks;


    private const int BorrowLimit = 3;


    public Member(
        int id,
        string name)
    {
        Id = id;
        Name = name;
    }


    public void BorrowBook(Book book)
    {
        if (borrowedBooks.Count >= BorrowLimit)
        {
            throw new InvalidOperationException(
                "Borrow limit reached.");
        }


        borrowedBooks.Add(book);
    }


    public void ReturnBook(Book book)
    {
        if (!borrowedBooks.Remove(book))
        {
            throw new InvalidOperationException(
                "Book not borrowed.");
        }
    }
}
```

---

# Library Class

```csharp id="v4p8s2"
using System.Collections.Generic;


public class Library
{
    private readonly List<Book> books = new();

    private readonly List<Member> members = new();



    public void AddBook(Book book)
    {
        books.Add(book);
    }



    public void RegisterMember(Member member)
    {
        members.Add(member);
    }



    public void BorrowBook(
        Member member,
        Book book)
    {
        book.Borrow();

        member.BorrowBook(book);
    }



    public void ReturnBook(
        Member member,
        Book book)
    {
        member.ReturnBook(book);

        book.Return();
    }
}
```

---

# 🧪 Test Cases

```csharp id="b7m3k9"
public class Program
{
    public static void Main()
    {
        Book book =
            new Book(
                1,
                "Clean Code",
                "Robert Martin");


        Member member =
            new Member(
                1,
                "Mohamed");


        Library library =
            new Library();


        library.AddBook(book);

        library.RegisterMember(member);


        library.BorrowBook(
            member,
            book);


        Console.WriteLine(
            book.Status);
    }
}
```

---

# Expected Output

```text id="w5n8c3"
Borrowed
```

---

# 🔍 Solution Explanation

## Why Does Book Control Availability?

Because availability belongs to the book.

The book knows:

```text id="g8m2z1"
Available

Borrowed
```

---

## Why Does Member Control Borrowing Limit?

Because borrowing rules belong to the member.

The member knows:

```text id="c4x7v2"
How many books they have.
```

---

## Why Does Library Exist?

Because the library coordinates:

```text id="m6p1z8"
Member

+

Book

+

Borrow Operation
```

It does not own every rule.

---

# 💡 Senior Engineer Notes

## Domain Modeling Process

A practical approach:

### Step 1

Find nouns:

```text id="z3k8m5"
Book
Member
Library
```

---

### Step 2

Find responsibilities:

```text id="q8m2v6"
Who owns this behavior?
```

---

### Step 3

Protect important state:

```text id="y5n9c2"
private state

controlled methods
```

---

### Step 4

Define relationships:

```text id="r4k7m1"
Who communicates with whom?
```

---

# 🎤 Interview Connection

## Question 1

### How do you identify classes from requirements?

Answer:

Look for important domain concepts and assign each concept clear responsibilities.

---

## Question 2

### Should every noun become a class?

Answer:

No.

Only concepts with meaningful state, behavior, or identity should become classes.

---

## Question 3

### How do you decide where behavior belongs?

Answer:

Put behavior in the object that owns the required data and the responsibility.

---

## Question 4

### What is domain modeling?

Answer:

Creating software objects that represent important concepts and rules from the real business domain.

---

# 🧠 Engineering Reflection

```text id="p9x4m7"
1. Why is Book a class?

2. Why is borrowing not only a Library responsibility?

3. Which object owns borrowing rules?

4. What happens if Book status is public?

5. How would this design grow for a real library system?
```

---

# 🏁 Key Takeaways

1. Good OOP starts with understanding the domain.
2. Classes should represent meaningful concepts.
3. Responsibilities should be assigned carefully.
4. Objects should protect their own state.
5. Not all logic belongs in one manager class.
6. Domain modeling is the foundation of Object-Oriented Design.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 17 of 19 ✅
</p>
```

