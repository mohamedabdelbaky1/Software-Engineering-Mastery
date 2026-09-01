

# 🧩 Exercise 04 — Fields vs Properties

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Fields
* Properties
* Auto-properties
* Getters and setters
* Access control
* Encapsulation boundaries
* Protecting object state

---

## Why This Matters

A common beginner implementation is:

```csharp
public string Name;
```

because it is simple.

However, professional software needs control over:

* Who can read data?
* Who can modify data?
* When can data change?
* What validation should happen before changing state?

Properties provide a controlled access layer between:

```text
External Code
        ↓
Property
        ↓
Internal State
```

---

# 🏢 Real-World Scenario

## Employee Management System

You are designing an HR system.

The system needs to represent employees.

An employee has:

* Name
* Email
* Salary
* Employment status

The company has rules:

* Employee name cannot be empty.
* Salary cannot be negative.
* Salary should not be modified directly by external code.
* Employment status should change only through approved actions.

---

# 📌 Requirements

Create an `Employee` class.

---

## Employee State

The object should contain:

```text
Name
Email
Salary
Status
```

---

## Required Behaviors

The employee should support:

### Increase Salary

```csharp
IncreaseSalary(decimal amount)
```

Rules:

* Amount must be positive.
* Salary cannot be changed directly.

---

### Activate Employee

```csharp
Activate()
```

Changes:

```text
Inactive → Active
```

---

### Display Information

```csharp
DisplayInformation()
```

Shows employee details.

---

# 🧠 Engineering Focus

Before coding, think about these questions.

---

# Question 1

## Should all fields be public?

Beginner approach:

```csharp
public decimal Salary;
```

Question:

Can anyone in the application change salary?

Example:

```csharp
employee.Salary = -5000;
```

Should this be allowed?

No.

---

# Question 2

## Who owns salary changes?

Salary belongs to:

```text
Employee
```

Therefore:

```text
Employee
     |
     |
     ↓
Controls salary changes
```

---

# Question 3

## Why Not Use Public Setters?

Example:

```csharp
public decimal Salary { get; set; }
```

This allows:

```csharp
employee.Salary = 1000000;
```

The object loses control.

---

# ❌ Bad Design Example

```csharp
public class Employee
{
    public string Name;

    public string Email;

    public decimal Salary;

    public string Status;
}
```

Usage:

```csharp
Employee employee = new Employee();

employee.Name = "Ahmed";

employee.Salary = -1000;

employee.Status = "Active";
```

---

# Why This Is Poor Design

## 1. No Validation Boundary

Anyone can do:

```csharp
employee.Salary = -1000;
```

The object cannot prevent invalid state.

---

## 2. No Control Over Changes

The system cannot know:

```text
Who changed salary?
Why did it change?
Was it allowed?
```

---

## 3. Business Rules Are Lost

Rules become scattered:

```text
UI validates
Service validates
Controller validates
```

instead of being owned by the object.

---

# ✅ Expected Design Direction

Think about access.

---

## Public Read Access

Some information can be visible:

Example:

```csharp
employee.Name
```

---

## Restricted Write Access

Some information should only change internally:

Example:

```csharp
Salary
Status
```

---

## Suggested Design

```text
Employee

Properties:
- Name
- Email
- Salary
- Status


Methods:
- IncreaseSalary()
- Activate()
- DisplayInformation()
```

---

# 💻 Solution

```csharp
using System;

public class Employee
{
    public string Name { get; }

    public string Email { get; }

    public decimal Salary { get; private set; }

    public string Status { get; private set; }


    public Employee(
        string name,
        string email,
        decimal salary)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name is required.");
        }


        if (salary < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(salary));
        }


        Name = name;
        Email = email;
        Salary = salary;
        Status = "Inactive";
    }


    public void IncreaseSalary(decimal amount)
    {
        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be positive.");
        }


        Salary += amount;
    }


    public void Activate()
    {
        Status = "Active";
    }


    public void DisplayInformation()
    {
        Console.WriteLine($"Name: {Name}");
        Console.WriteLine($"Email: {Email}");
        Console.WriteLine($"Salary: {Salary}");
        Console.WriteLine($"Status: {Status}");
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
                "Ahmed",
                "ahmed@test.com",
                5000);


        employee.DisplayInformation();


        employee.IncreaseSalary(1000);


        employee.Activate();


        Console.WriteLine();


        employee.DisplayInformation();
    }
}
```

---

# Expected Output

```text
Name: Ahmed
Email: ahmed@test.com
Salary: 5000
Status: Inactive


Name: Ahmed
Email: ahmed@test.com
Salary: 6000
Status: Active
```

---

# 🔍 Solution Explanation

## Why Is Name Getter-Only?

```csharp
public string Name { get; }
```

Because employee identity should not change randomly.

---

## Why Is Salary Private Set?

```csharp
public decimal Salary { get; private set; }
```

External code can:

```csharp
employee.Salary
```

read it.

But cannot:

```csharp
employee.Salary = -5000;
```

Only the object controls salary changes.

---

## Why Is IncreaseSalary() Better?

Compare:

```csharp
employee.Salary += 1000;
```

with:

```csharp
employee.IncreaseSalary(1000);
```

The second expresses business intent.

The employee owns the rule.

---

# 💡 Senior Engineer Notes

## Fields vs Properties

### Field

```csharp
private decimal salary;
```

Stores data.

---

### Property

```csharp
public decimal Salary { get; private set; }
```

Provides controlled access.

A property can later add:

* Validation
* Logging
* Notifications
* Calculations

without changing the public API.

---

## Production Consideration

A real HR system may introduce:

```text
Employee
SalaryPolicy
PayrollService
EmployeeRepository
```

depending on complexity.

---

# 🎤 Interview Connection

## Question 1

### What is the difference between a field and a property?

Answer:

A field directly stores data, while a property provides controlled access to data and can contain logic during getting or setting.

---

## Question 2

### Why are public fields usually avoided?

Answer:

Because they expose internal representation and allow uncontrolled modification.

---

## Question 3

### Is a property automatically encapsulation?

Answer:

No.

Example:

```csharp
public decimal Salary { get; set; }
```

still allows uncontrolled mutation.

Encapsulation requires protecting rules and controlling state changes.

---

# 🧠 Engineering Reflection

Answer:

```text
1. Why is Salary not public set?

2. Why is IncreaseSalary better than changing Salary directly?

3. Which properties should be immutable?

4. When would a public setter be acceptable?

5. How do properties support future changes?
```

---

# 🏁 Key Takeaways

1. Fields store data directly.
2. Properties provide controlled access.
3. Public fields expose implementation details.
4. Public setters may allow invalid state.
5. `private set` is useful when objects should control modifications.
6. Behavior methods often express intent better than direct assignment.
7. Properties are a tool for Encapsulation, not Encapsulation itself.
8. Good design controls who can change important state.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 04 of 19 ✅
</p>
```

