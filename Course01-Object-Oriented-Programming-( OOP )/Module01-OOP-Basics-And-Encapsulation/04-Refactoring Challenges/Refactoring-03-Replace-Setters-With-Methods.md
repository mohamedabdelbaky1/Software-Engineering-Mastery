

# 🔧 Refactoring Challenge 03 — Replace Setters With Methods

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on an employee management system.

The team created an `Employee` class.

The implementation allows developers to directly modify employee data.

At first this looked simple, but problems appeared:

* Salaries changed without approval.
* Employees became active without proper checks.
* Invalid values entered the system.
* Business rules were duplicated across services.

Your task:

Refactor the class so state changes happen through meaningful behaviors.

---

# 🔴 Original Code

```csharp id="q7m3kx"
public class Employee
{
    public string Name { get; set; }

    public decimal Salary { get; set; }

    public bool IsActive { get; set; }
}
```

---

# Example Usage

```csharp id="5m9x2p"
Employee employee =
    new Employee();


employee.Name = "Ahmed";

employee.Salary = 5000;

employee.IsActive = true;


employee.Salary = -1000;
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — State Can Change Without Meaning

Current:

```csharp
employee.Salary = 7000;
```

What happened?

We don't know.

Was it:

* Promotion?
* Annual raise?
* Correction?
* Mistake?

The code only describes a value change.

It does not describe a business action.

---

# Better:

```csharp
employee.IncreaseSalary(1000);
```

Now the code communicates intent.

---

# ❌ Problem 2 — Public Setters Bypass Rules

Current:

```csharp
public decimal Salary { get; set; }
```

Allows:

```csharp
employee.Salary = -5000;
```

The object cannot protect itself.

---

# ❌ Problem 3 — Boolean State Can Become Invalid

Current:

```csharp
public bool IsActive {get;set;}
```

Allows:

```csharp
employee.IsActive = true;
```

without knowing:

* When was the employee activated?
* Is activation allowed?
* Are requirements completed?

---

# ❌ Problem 4 — Business Logic Moves Outside

Developers start writing:

```csharp
if(employee.IsActive)
{
    employee.Salary += bonus;
}
```

everywhere.

The employee rules become scattered.

---

# 🧠 Senior Engineer Thinking

A senior engineer asks:

---

## Question 1

### What does Employee own?

Employee owns:

```text id="x5m8q2"
Salary

Employment status
```

Therefore:

Employee should control changes.

---

## Question 2

### Are all changes equal?

No.

Compare:

```csharp
employee.Salary = 10000;
```

with:

```csharp
employee.Promote();
```

The second one represents a business action.

---

## Question 3

### What should the public API express?

Not:

```text id="k8p4m1"
Change data
```

But:

```text id="q3x9m7"
Perform valid action
```

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Remove public setters.

---

## Step 2

Create controlled methods.

---

## Step 3

Move validation inside the object.

---

## Step 4

Protect important state.

---

# ✅ Refactored Code

```csharp id="n5q8x3"
using System;


public class Employee
{
    public string Name { get; }


    public decimal Salary { get; private set; }


    public bool IsActive { get; private set; }



    public Employee(
        string name,
        decimal salary)
    {
        if(string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Name is required.");
        }


        if(salary < 0)
        {
            throw new ArgumentException(
                "Invalid salary.");
        }


        Name = name;

        Salary = salary;

        IsActive = false;
    }



    public void Activate()
    {
        IsActive = true;
    }



    public void IncreaseSalary(
        decimal amount)
    {
        if(!IsActive)
        {
            throw new InvalidOperationException(
                "Inactive employee cannot receive raise.");
        }


        if(amount <= 0)
        {
            throw new ArgumentException(
                "Invalid raise amount.");
        }


        Salary += amount;
    }



    public void Deactivate()
    {
        IsActive = false;
    }
}
```

---

# 🧪 Test Cases

---

# Valid Flow

```csharp id="f8m3q7"
public class Program
{
    public static void Main()
    {
        Employee employee =
            new Employee(
                "Ahmed",
                5000);



        employee.Activate();


        employee.IncreaseSalary(1000);



        Console.WriteLine(
            employee.Salary);
    }
}
```

---

# Output

```text id="x7m2q9"
6000
```

---

# Invalid Flow

```csharp id="3p8k1m"
Employee employee =
    new Employee(
        "Ahmed",
        5000);



employee.IncreaseSalary(1000);
```

Result:

```text id="8n4m2x"
Exception:

Inactive employee cannot receive raise.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text id="s7m3x9"
External Code

changes state directly

        ↓

Employee
```

---

# After

```text id="h4k8m2"
External Code

requests behavior

        ↓

Employee validates

        ↓

State changes
```

---

# Why Replace Setters?

Because:

```csharp
employee.Salary = 8000;
```

does not explain:

* Why salary changed.
* Whether change is allowed.
* What rules apply.

---

But:

```csharp
employee.IncreaseSalary(1000);
```

communicates:

* A raise happened.
* Rules should be checked.
* Employee controls the operation.

---

# Property vs Method Decision

Use a property for:

## Simple information

Example:

```csharp
employee.Name
```

Reading data.

---

Use a method for:

## Actions

Example:

```csharp
employee.Promote();

employee.Activate();

employee.IncreaseSalary();
```

Actions usually contain rules.

---

# 🎤 Interview Discussion

---

## Q1: Why are public setters dangerous?

### Answer:

Because they allow external code to modify state without validation or business rules.

---

## Q2: When should you use a method instead of a setter?

### Answer:

When changing a value represents a business operation that requires rules or validation.

---

## Q3: Should every property have a setter?

### Answer:

No.

Only state that can safely change externally should be mutable.

---

## Q4: What is a controlled state transition?

### Answer:

A state change performed through a method that validates whether the transition is allowed.

Example:

```text id="v9m2x5"
Inactive

   |

Activate()

   |

Active
```

---

# 🧠 Refactoring Checklist

```text id="p4x8m2"
☑ Are important setters removed?

☑ Do methods represent business actions?

☑ Can invalid changes happen?

☑ Are rules inside the owning object?

☑ Does the public API express intent?
```

---

# 🏁 Key Takeaways

1. Setters expose state changes; methods express behavior.
2. Objects should protect their own transitions.
3. Good APIs describe business actions.
4. Not every property needs to be writable.
5. Encapsulation creates safer and clearer code.
6. The goal of OOP is not storing data — it is modeling behavior.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 03 Completed ✅
</p>

---

