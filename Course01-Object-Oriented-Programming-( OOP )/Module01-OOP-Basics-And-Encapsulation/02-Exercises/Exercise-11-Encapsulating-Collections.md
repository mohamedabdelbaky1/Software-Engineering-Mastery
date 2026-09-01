

# 🧩 Exercise 11 — Encapsulating Collections

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Professional OOP Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Collection encapsulation
* Protecting internal state
* `List<T>` exposure problems
* `IReadOnlyList<T>`
* Collection ownership
* Aggregate boundaries
* Maintaining invariants

---

## Why This Matters

A common mistake is thinking:

> "I made my fields private, so my object is encapsulated."

Example:

```csharp
private List<OrderItem> items;
```

Looks safe.

But then:

```csharp
public List<OrderItem> Items
{
    get
    {
        return items;
    }
}
```

The internal collection has leaked.

External code can now:

```csharp
order.Items.Clear();
order.Items.Add(null);
```

The object lost control.

---

# 🏢 Real-World Scenario

# University Course Registration System

You are designing a university system.

A course contains:

* Course information
* Registered students

A course has rules:

```text
A course cannot contain duplicate students.

A course cannot exceed maximum capacity.

Students must be added through registration rules.

External code should not directly modify registrations.
```

---

# 📌 Requirements

Create a `Course` class.

---

# Course State

The course contains:

```text
CourseId

Name

MaximumCapacity

Students
```

---

# Course Behaviors

---

## Register Student

```csharp
RegisterStudent(Student student)
```

Rules:

* Student cannot be null.
* Student cannot already exist.
* Capacity cannot be exceeded.

---

## Remove Student

```csharp
RemoveStudent(Student student)
```

Rules:

* Student must exist.

---

## Check Availability

```csharp
HasAvailableSeats()
```

Returns:

```text
true  → seats available

false → course full
```

---

# 🧠 Engineering Focus

Before coding, think about collection ownership.

---

# Question 1

## Who Owns Students?

The answer:

```text
Course
```

because:

```text
Course
 |
 └── Registered Students
```

---

# Question 2

## Should Students Be Publicly Modifiable?

Bad:

```csharp
course.Students.Add(student);
```

Why?

Because it bypasses:

* Duplicate checks.
* Capacity rules.
* Validation.

---

# Question 3

## Does Returning a Collection Give Away Control?

Consider:

```csharp
public List<Student> Students => students;
```

The caller receives the actual list.

Now:

```csharp
course.Students.Clear();
```

The course state is destroyed.

---

# ❌ Bad Design Example

```csharp
public class Course
{
    public string Name;

    public List<Student> Students;
}
```

Usage:

```csharp
Course course = new Course();

course.Students.Add(null);

course.Students.Clear();

course.Students.Add(student);
```

---

# Why This Is Poor Design

## 1. Rules Can Be Bypassed

The course cannot enforce:

```text
Maximum capacity
Duplicate prevention
```

---

## 2. Internal Representation Is Exposed

External code depends on:

```text
List<Student>
```

Now changing:

```text
List<T>
      ↓
HashSet<T>
      ↓
Database collection
```

becomes difficult.

---

## 3. Object Loses Responsibility

The course becomes:

```text
Data container
```

instead of:

```text
Registration manager
```

---

# ✅ Expected Design Direction

The course should own registration behavior.

---

# Design

```text
Course

Private:
    students collection


Public:
    Students (read-only view)

Methods:
    RegisterStudent()
    RemoveStudent()
    HasAvailableSeats()
```

---

# Object Boundary

```text
External Code

      |
      ▼

Course API

      |
      ▼

Private Collection

      |
      ▼

Rules Protected
```

---

# 💻 Solution

## Student Class

```csharp
public class Student
{
    public int Id { get; }

    public string Name { get; }


    public Student(
        int id,
        string name)
    {
        Id = id;
        Name = name;
    }
}
```

---

## Course Class

```csharp
using System;
using System.Collections.Generic;
using System.Linq;


public class Course
{
    private readonly List<Student> students = new();


    public int CourseId { get; }

    public string Name { get; }

    public int MaximumCapacity { get; }


    public IReadOnlyList<Student> Students => students;


    public Course(
        int courseId,
        string name,
        int maximumCapacity)
    {
        CourseId = courseId;

        Name = name;

        MaximumCapacity = maximumCapacity;
    }


    public void RegisterStudent(Student student)
    {
        if (student == null)
        {
            throw new ArgumentNullException(
                nameof(student));
        }


        if (students.Any(
            s => s.Id == student.Id))
        {
            throw new InvalidOperationException(
                "Student already registered.");
        }


        if (!HasAvailableSeats())
        {
            throw new InvalidOperationException(
                "Course capacity reached.");
        }


        students.Add(student);
    }


    public void RemoveStudent(Student student)
    {
        if (!students.Remove(student))
        {
            throw new InvalidOperationException(
                "Student not found.");
        }
    }


    public bool HasAvailableSeats()
    {
        return students.Count < MaximumCapacity;
    }
}
```

---

# 🧪 Test Cases

```csharp
public class Program
{
    public static void Main()
    {
        Course course =
            new Course(
                101,
                "Object Oriented Programming",
                2);


        Student student1 =
            new Student(
                1,
                "Ahmed");


        Student student2 =
            new Student(
                2,
                "Mohamed");


        course.RegisterStudent(student1);

        course.RegisterStudent(student2);


        Console.WriteLine(
            course.Students.Count);


        Console.WriteLine(
            course.HasAvailableSeats());
    }
}
```

---

# Expected Output

```text
2

False
```

---

# Invalid Test Case

Trying to exceed capacity:

```csharp
Student student3 =
    new Student(
        3,
        "Ali");


course.RegisterStudent(student3);
```

Result:

```text
Exception

Course capacity reached.
```

---

# 🔍 Solution Explanation

## Why Is The List Private?

```csharp
private readonly List<Student> students;
```

Because the course controls:

* Adding students.
* Removing students.
* Capacity rules.

---

## Why Use IReadOnlyList?

```csharp
public IReadOnlyList<Student> Students => students;
```

The caller can:

```csharp
course.Students.Count;
```

but cannot:

```csharp
course.Students.Add(student);
```

---

## Why Not Return List Directly?

Because this exposes implementation details:

```csharp
public List<Student> Students
```

Now callers depend on:

```text
List<T>
```

instead of the concept:

```text
Registered students
```

---

## Why Does RegisterStudent Exist?

Because registration is a business operation.

Compare:

```csharp
course.Students.Add(student);
```

with:

```csharp
course.RegisterStudent(student);
```

The second allows the course to protect its rules.

---

# 💡 Senior Engineer Notes

## Collection Encapsulation Pattern

Common pattern:

```csharp
private readonly List<T> items = new();

public IReadOnlyList<T> Items => items;
```

This is widely used in:

* Domain models.
* Aggregates.
* Entity classes.

---

# Aggregate Boundary Concept

In Domain-Driven Design:

An object that owns related objects and protects their rules is called an:

```text
Aggregate Root
```

Example:

```text
Course
 |
 └── Students
```

The Course controls access to students inside that boundary.

---

# Common Mistakes

## ❌ Public Mutable Collection

```csharp
public List<Student> Students;
```

---

## ❌ Returning Internal List

```csharp
public List<Student> GetStudents()
{
    return students;
}
```

---

## ❌ Allowing External Modification

```csharp
course.Students.Add(student);
```

---

## ❌ Using Collections Without Rules

Sometimes a collection is not just data.

It represents a business concept.

Example:

```text
Registered Students
```

is different from:

```text
List<Student>
```

---

# 🎤 Interview Connection

## Question 1

### Why should you avoid exposing List<T> publicly?

Answer:

Because it exposes internal mutable state and allows callers to bypass business rules.

---

## Question 2

### How do you expose a collection safely?

Answer:

Expose a read-only abstraction such as:

```csharp
IReadOnlyList<T>
```

while keeping the actual collection private.

---

## Question 3

### Why is collection encapsulation important?

Answer:

Because collections often have rules around modification, ownership, and consistency.

---

## Question 4

### What is an aggregate root?

Answer:

An object that controls access to related objects and protects consistency rules inside its boundary.

---

# 🧠 Engineering Reflection

Answer:

```text
1. Why should Course own student registration?

2. Why is public List<Student> dangerous?

3. What rules would break if users modified the list directly?

4. Why use IReadOnlyList?

5. When should a collection become part of an object's responsibility?
```

---

# 🏁 Key Takeaways

1. Collections are also object state.
2. Private fields are not enough if mutable collections leak.
3. Objects should control collection modifications.
4. `IReadOnlyList<T>` allows observation without mutation.
5. Collection ownership defines responsibility boundaries.
6. Encapsulation applies to collections exactly like individual fields.
7. Protecting collections is essential for professional domain modeling.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 11 of 19 ✅
</p>
```
