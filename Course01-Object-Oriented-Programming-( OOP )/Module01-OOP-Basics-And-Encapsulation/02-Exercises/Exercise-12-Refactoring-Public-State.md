

# 🧩 Exercise 12 — Refactoring Public State

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Professional OOP Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Identifying poor encapsulation
* Refactoring public fields
* Moving behavior into objects
* Protecting object state
* Improving maintainability
* Applying OOP principles to existing code

---

## Why This Matters

In real companies, you rarely start with a perfect codebase.

You usually inherit code like:

```text
Old system
    ↓
Many public fields
    ↓
Business logic everywhere
    ↓
Hard to change
```

A senior engineer must be able to:

1. Understand existing code.
2. Identify design problems.
3. Refactor safely.
4. Preserve behavior.

---

# 🏢 Real-World Scenario

# Employee Payroll System

You joined a company and found this existing employee system.

The current implementation works, but developers are facing problems:

* Anyone can change salary.
* Employee status can become invalid.
* Payroll logic is duplicated.
* Different parts of the application modify employee data directly.

Your task:

Refactor the design using OOP principles.

---

# 📌 Requirements

The employee system should support:

---

## Employee Information

The employee has:

```text
Employee Id

Name

Salary

Status
```

---

## Employee Operations

The employee should support:

```csharp
IncreaseSalary()

Deactivate()

CalculateAnnualSalary()
```

---

## Business Rules

The system must guarantee:

```text
Salary cannot be negative.

Inactive employees cannot receive salary increases.

Employee status changes must be controlled.

External code cannot directly modify employee state.
```

---

# 🧠 Engineering Focus

Think like a code reviewer.

---

# Question 1

## What Is Wrong With Public State?

Example:

```csharp
employee.Salary = -5000;
```

The object cannot protect itself.

---

# Question 2

## Who Owns Salary Rules?

Bad:

```text
PayrollService

SalaryValidator

EmployeeController
```

Everyone knows employee rules.

---

Better:

```text
Employee
```

because:

```text
Employee owns employee data.
```

---

# Question 3

## Is Data Enough?

Bad:

```csharp
Employee
{
    Salary
    Status
}
```

A professional object also has:

```text
State

+

Behavior
```

---

# ❌ Original Bad Design

```csharp
public class Employee
{
    public int Id;

    public string Name;

    public decimal Salary;

    public string Status;
}
```

Usage:

```csharp
Employee employee = new Employee();

employee.Id = 1;

employee.Name = "Ahmed";

employee.Salary = 5000;

employee.Status = "Active";


// Somewhere else:

employee.Salary += 1000;

employee.Status = "Inactive";
```

---

# Why This Is Poor Design

---

## 1. No Protection

Anyone can do:

```csharp
employee.Salary = -10000;
```

---

## 2. Business Logic Is Scattered

Example:

```csharp
if(employee.Status == "Active")
{
    employee.Salary += amount;
}
```

This may appear in:

* Payroll system
* HR system
* Reports

---

## 3. Invalid States Exist

Example:

```text
Status = Inactive

Salary increased
```

---

# ✅ Expected Design Direction

Refactor toward:

```text
Employee

Private State

+

Controlled Behavior
```

---

# Design

```text
Employee

Public:
    Id
    Name
    Salary
    Status

Methods:
    IncreaseSalary()
    Deactivate()
    CalculateAnnualSalary()


Private:
    Validation Rules
```

---

# 💻 Solution

```csharp
using System;


public enum EmployeeStatus
{
    Active,
    Inactive
}


public class Employee
{
    public int Id { get; }

    public string Name { get; }

    public decimal Salary { get; private set; }

    public EmployeeStatus Status { get; private set; }


    public Employee(
        int id,
        string name,
        decimal salary)
    {
        if (salary < 0)
        {
            throw new ArgumentException(
                "Salary cannot be negative.");
        }


        Id = id;

        Name = name;

        Salary = salary;

        Status = EmployeeStatus.Active;
    }


    public void IncreaseSalary(decimal amount)
    {
        if (Status == EmployeeStatus.Inactive)
        {
            throw new InvalidOperationException(
                "Inactive employees cannot receive raises.");
        }


        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be positive.");
        }


        Salary += amount;
    }


    public void Deactivate()
    {
        Status = EmployeeStatus.Inactive;
    }


    public decimal CalculateAnnualSalary()
    {
        return Salary * 12;
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
        Employee employee =
            new Employee(
                1,
                "Ahmed",
                5000);


        employee.IncreaseSalary(1000);


        Console.WriteLine(
            employee.Salary);


        Console.WriteLine(
            employee.CalculateAnnualSalary());


        employee.Deactivate();
    }
}
```

---

# Expected Output

```text
6000

72000
```

---

# Invalid Operation Test

```csharp
employee.Deactivate();

employee.IncreaseSalary(500);
```

Expected:

```text
Exception

Inactive employees cannot receive raises.
```

---

# 🔍 Solution Explanation

## Before Refactoring

The employee was:

```text
Data Container
```

---

## After Refactoring

The employee became:

```text
Business Object
```

with:

```text
State

+

Rules

+

Behavior
```

---

# Why Is Salary Private Set?

```csharp
public decimal Salary { get; private set; }
```

Because salary changes must happen through:

```csharp
IncreaseSalary()
```

not:

```csharp
Salary = value;
```

---

# Why Is Status An Enum?

Before:

```csharp
"Active"
"Inactive"
```

Problems:

```text
"active"

"ACTIVE"

"Actve"
```

Enum gives:

* Type safety.
* Clear possible values.
* Better refactoring.

---

# Why Move Logic Inside Employee?

Before:

```csharp
PayrollService
{
    Check employee status
    Change salary
}
```

After:

```csharp
employee.IncreaseSalary();
```

The employee protects its own rules.

---

# 💡 Senior Engineer Notes

## Refactoring Mindset

When reviewing code, ask:

### 1. Can this object become invalid?

If yes:

Add protection.

---

### 2. Can external code modify important state?

If yes:

Reduce access.

---

### 3. Does behavior belong somewhere else?

Move it closer to the data it affects.

---

# Common Refactoring Steps

A practical approach:

```text
1. Find public mutable fields

        ↓

2. Make state private

        ↓

3. Add controlled methods

        ↓

4. Move business rules inside object

        ↓

5. Add validation
```

---

# 🎤 Interview Connection

## Question 1

### What is the problem with anemic domain models?

Answer:

An anemic model contains mostly data with little or no behavior, causing business logic to spread across services.

---

## Question 2

### Why is encapsulation useful during refactoring?

Answer:

Because it creates boundaries that allow internal implementation changes without affecting external code.

---

## Question 3

### How do you improve a class with many public fields?

Answer:

* Hide internal state.
* Add meaningful behaviors.
* Validate changes.
* Control mutations.

---

## Question 4

### What is the goal of refactoring?

Answer:

Improve design quality without changing the external behavior of the system.

---

# 🧠 Engineering Reflection

Answer:

```text
1. What problems existed in the original Employee class?

2. Why should Salary changes happen through methods?

3. What invalid states did refactoring prevent?

4. Why is behavior important in OOP?

5. How does encapsulation make future changes safer?
```

---

# 🏁 Key Takeaways

1. Existing code can always be improved.
2. Public mutable state creates fragile systems.
3. Objects should protect important rules.
4. Refactoring is about improving design without changing behavior.
5. Good objects combine:

   * State
   * Behavior
   * Rules
6. Encapsulation reduces coupling and improves maintainability.
7. Senior engineers spend significant time improving existing designs.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 12 of 19 ✅
</p>
```

