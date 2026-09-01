

# 🔍 Code Review Challenge 03 — Anemic Domain Model

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟠 Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You are reviewing an HR management system.

The team created an `Employee` class to represent employees.

The implementation works, but over time developers noticed:

* Business rules are duplicated everywhere.
* Services contain hundreds of `if` statements.
* Changing employee rules requires modifying many files.
* The `Employee` class only stores data.

You are asked:

> Review the design and suggest improvements.

---

# 👀 Code Under Review

```csharp
public class Employee
{
    public int Id { get; set; }

    public string Name { get; set; }

    public decimal Salary { get; set; }

    public bool IsActive { get; set; }
}
```

---

# Example Usage

```csharp
Employee employee =
    new Employee();


employee.Id = 1;

employee.Name = "Ahmed";

employee.Salary = 5000;

employee.IsActive = true;



if(employee.IsActive)
{
    employee.Salary += 1000;
}
```

---

# 🔴 Review Findings

---

# Issue 1 — Employee Has No Behavior

## Problem

The class only contains:

```text
Properties
```

It does not contain:

```text
Rules

Behavior

Business Decisions
```

---

Current:

```csharp
employee.Salary += 1000;
```

The logic exists outside the object.

---

# Why Is This A Problem?

Imagine salary increase rules change:

New requirement:

```text
Only active employees with more than 1 year experience can receive raises.
```

Where do you put this rule?

Possibly:

```text
PayrollService

HRService

BonusService

Reports
```

Now the rule is duplicated.

---

# Senior Engineer Thinking

Ask:

> Who owns salary rules?

Answer:

```text
Employee
```

Because:

```text
Employee owns employee state.
```

---

# Issue 2 — Anemic Domain Model

## Definition

An anemic domain model is:

> A model where objects contain only data, while all behavior exists in external services.

Example:

```csharp
Employee
{
    Salary
    Status
}
```

but:

```text
PayrollService

HRService

BonusService
```

contain all logic.

---

# Why Is This Weak?

The object becomes:

```text
Database Record
```

instead of:

```text
Business Object
```

---

# Issue 3 — Public Setters Allow Invalid State

Current:

```csharp
public decimal Salary { get; set; }
```

Allows:

```csharp
employee.Salary = -5000;
```

The object accepts invalid data.

---

# Issue 4 — Business Rules Are Scattered

Example:

File 1:

```csharp
if(employee.IsActive)
{
    employee.Salary += amount;
}
```

File 2:

```csharp
if(employee.IsActive)
{
    CalculateBonus(employee);
}
```

File 3:

```csharp
if(employee.IsActive)
{
    Promote(employee);
}
```

The rule:

```text
Employee must be active
```

exists everywhere.

---

# 🧠 Senior Engineer Analysis

A professional reviewer asks:

---

## Question 1

### What does Employee know?

Current:

```text
Nothing
```

---

Better:

```text
Employee knows:

- Its salary rules.
- Its active state.
- Its allowed operations.
```

---

## Question 2

### Who should change salary?

Bad:

```csharp
employee.Salary = 7000;
```

Better:

```csharp
employee.IncreaseSalary(2000);
```

---

## Question 3

### Does every class need behavior?

No.

But domain entities usually should contain behavior related to their responsibilities.

---

# ❌ Design Problems Summary

| Problem              | Severity  | Reason                    |
| -------------------- | --------- | ------------------------- |
| Data-only class      | 🔴 High   | No business behavior      |
| Public setters       | 🔴 High   | Invalid states possible   |
| Rules outside object | 🔴 High   | Duplication               |
| Weak encapsulation   | 🟠 Medium | No protection             |
| Hard maintenance     | 🔴 High   | Changes spread everywhere |

---

# ✅ Recommended Design Direction

Move behavior into the entity.

Before:

```text
Employee

Data only


PayrollService

All rules
```

---

After:

```text
Employee

State
+
Behavior
+
Rules
```

---

# Refactored Version

```csharp
public enum EmployeeStatus
{
    Active,
    Inactive
}
```

---

# Employee Class

```csharp
using System;


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
        if(salary < 0)
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
        if(Status != EmployeeStatus.Active)
        {
            throw new InvalidOperationException(
                "Inactive employee cannot receive raise.");
        }


        if(amount <= 0)
        {
            throw new ArgumentException(
                "Invalid amount.");
        }


        Salary += amount;
    }



    public void Deactivate()
    {
        Status = EmployeeStatus.Inactive;
    }
}
```

---

# Usage After Refactoring

```csharp
Employee employee =
    new Employee(
        1,
        "Ahmed",
        5000);



employee.IncreaseSalary(1000);



Console.WriteLine(
    employee.Salary);
```

---

# Output

```text
6000
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Employee

=
Data Container
```

---

# After

```text
Employee

=
Object With Responsibility
```

---

# Why Move IncreaseSalary() Inside Employee?

Because the method needs:

```text
Employee Status

Employee Salary
```

The employee owns both.

Therefore:

```text
Employee should control the operation.
```

---

# Why Remove Salary Setter?

Before:

```csharp
Salary { get; set; }
```

Allows:

```csharp
employee.Salary = -1000;
```

---

After:

```csharp
Salary { get; private set; }
```

Only Employee can change salary.

---

# Why Is This More Maintainable?

Future change:

> Employees above grade 5 receive a higher raise.

Before:

Modify:

```text
PayrollService

BonusService

HRService
```

---

After:

Modify:

```text
Employee.IncreaseSalary()
```

One location.

---

# 🎤 Interview Discussion

---

## Q1: What is an anemic domain model?

### Answer:

A model where classes mainly contain data while business logic exists in external services.

---

## Q2: Why is anemic design considered weak?

### Answer:

Because behavior becomes scattered, rules are duplicated, and objects cannot protect their own state.

---

## Q3: Should every method be inside an entity?

### Answer:

No.

Only behavior that belongs to the object's responsibility should live inside it.

---

## Q4: What is the difference between DTO and Domain Entity?

### Answer:

DTO:

```text
Transfers data
```

Domain Entity:

```text
Contains state + behavior + rules
```

---

# 🧠 Reviewer Checklist

When reviewing a class:

```text
☑ Does this class only store data?

☑ Are business rules outside the object?

☑ Can the object protect itself?

☑ Does the object own the required information?

☑ Are setters exposing important state?
```

---

# 🏁 Key Takeaways

1. Objects should contain behavior, not only data.
2. Domain entities should protect their own rules.
3. External services should not own every business decision.
4. Public setters create weak boundaries.
5. Anemic models make systems harder to maintain.
6. Good OOP puts behavior close to the data it affects.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 03 Completed ✅
</p>

---

