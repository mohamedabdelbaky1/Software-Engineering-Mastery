

# 🔧 Refactoring Challenge 08 — Improving Class Responsibility

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on a student management system.

The team created a `Student` class.

The developer wanted to keep everything related to students in one place.

The class currently handles:

* Student information.
* Grade calculation.
* Saving data.
* Sending notifications.

The system works, but the class becomes difficult to maintain.

Your task:

Refactor the class so it has a clear responsibility.

---

# 🔴 Original Code

```csharp
using System;
using System.Collections.Generic;


public class Student
{
    public string Name { get; set; }


    public List<int> Grades { get; set; }



    public void CalculateAverage()
    {
        int total = 0;


        foreach(int grade in Grades)
        {
            total += grade;
        }


        Console.WriteLine(
            total / Grades.Count);
    }



    public void Save()
    {
        Console.WriteLine(
            "Saving student to database");
    }



    public void SendEmail()
    {
        Console.WriteLine(
            "Sending email to student");
    }
}
```

---

# Example Usage

```csharp
Student student =
    new Student();


student.Name = "Ahmed";


student.Grades =
    new List<int>
    {
        90,
        80,
        70
    };


student.CalculateAverage();

student.Save();

student.SendEmail();
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Student Has Too Many Responsibilities

Current class:

```text
Student

- Stores student data

- Calculates grades

- Saves database data

- Sends emails
```

The class has multiple reasons to change.

---

Example:

If email requirements change:

```text
Student changes
```

If database changes:

```text
Student changes
```

If grading rules change:

```text
Student changes
```

---

# ❌ Problem 2 — Low Cohesion

Cohesion means:

> How closely related the responsibilities inside a class are.

Current:

```text
Student

+
Database logic

+
Email logic

+
Grade logic
```

These responsibilities are unrelated.

---

# ❌ Problem 3 — Student Knows Too Much

A student object should know:

```text
Name

Grades

Student-related behavior
```

It should not know:

```text
How data is stored

How emails are sent
```

---

# ❌ Problem 4 — Hard to Change

Imagine replacing:

Database:

```text
SQL Server
        ↓
MongoDB
```

Email:

```text
Email
        ↓
SMS
```

The Student class changes every time.

---

# 🧠 Senior Engineer Thinking

A senior developer asks:

---

## Question 1

What is the main responsibility of Student?

Answer:

```text
Represent a student.
```

---

## Question 2

Who should calculate grades?

The responsibility is related to grades.

Possible owner:

```text
GradeCalculator
```

---

## Question 3

Who should save students?

A persistence component.

Example:

```text
StudentRepository
```

---

## Question 4

Who should send notifications?

A notification component.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Keep Student focused on student data.

---

## Step 2

Move grade calculation.

---

## Step 3

Move storage responsibility.

---

## Step 4

Move notification responsibility.

---

# ✅ Refactored Code

---

# Student Class

```csharp
using System;
using System.Collections.Generic;


public class Student
{
    private readonly List<int> grades =
        new();



    public string Name { get; }



    public IReadOnlyList<int> Grades =>
        grades;



    public Student(
        string name)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name required.");
        }


        Name = name;
    }



    public void AddGrade(int grade)
    {
        if(grade < 0 || grade > 100)
        {
            throw new ArgumentException(
                "Invalid grade.");
        }


        grades.Add(grade);
    }
}
```

---

# GradeCalculator

```csharp
using System.Linq;


public class GradeCalculator
{
    public double CalculateAverage(
        Student student)
    {
        return student.Grades.Average();
    }
}
```

---

# StudentRepository

```csharp
public class StudentRepository
{
    public void Save(
        Student student)
    {
        Console.WriteLine(
            "Saving student data");
    }
}
```

---

# StudentNotificationService

```csharp
public class StudentNotificationService
{
    public void Send(
        Student student)
    {
        Console.WriteLine(
            $"Email sent to {student.Name}");
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
        Student student =
            new Student(
                "Ahmed");



        student.AddGrade(90);

        student.AddGrade(80);

        student.AddGrade(70);



        GradeCalculator calculator =
            new GradeCalculator();



        Console.WriteLine(
            calculator.CalculateAverage(student));



        StudentRepository repository =
            new StudentRepository();


        repository.Save(student);



        StudentNotificationService notification =
            new StudentNotificationService();


        notification.Send(student);
    }
}
```

---

# Output

```text
80

Saving student data

Email sent to Ahmed
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Student

Data

+

Grades

+

Database

+

Email
```

The class is doing everything.

---

# After

```text
Student

Owns:

Student state


GradeCalculator

Owns:

Grade calculation


Repository

Owns:

Saving


Notification Service

Owns:

Communication
```

---

# Why Is This Better?

---

## 1. Clear Responsibility

Now each class has a clear purpose.

---

## 2. Easier Changes

Changing email logic:

Before:

```text
Modify Student
```

After:

```text
Modify Notification Service
```

---

## 3. Better Testing

You can test:

```text
Student

without database

without email
```

---

## 4. Better Object Design

Student is now a real domain object:

```text
Student

State

+

Rules
```

not:

```text
Student

Everything
```

---

# 🎤 Interview Discussion

---

## Q1: What is class responsibility?

### Answer:

The responsibility is the job or purpose a class owns in the system.

---

## Q2: What is high cohesion?

### Answer:

A class whose methods and data strongly relate to one clear purpose.

---

## Q3: Why are large classes problematic?

### Answer:

They become difficult to understand, test, and modify because they contain unrelated responsibilities.

---

## Q4: Should every operation become a separate class?

### Answer:

No.

Only separate responsibilities when they represent different concepts or change for different reasons.

---

# 🧠 Refactoring Checklist

```text
☑ Does the class have one clear purpose?

☑ Are responsibilities mixed?

☑ Does the class know unrelated details?

☑ Can parts change independently?

☑ Is the object representing a real concept?
```

---

# 🏁 Key Takeaways

1. A class should have a clear responsibility.
2. Related data and behavior should stay together.
3. Unrelated responsibilities should be separated.
4. Good design reduces the impact of future changes.
5. Clean objects are easier to understand and maintain.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 08 Completed ✅
</p>

---

