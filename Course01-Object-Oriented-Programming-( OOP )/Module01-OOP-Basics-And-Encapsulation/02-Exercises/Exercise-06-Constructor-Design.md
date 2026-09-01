

# 🧩 Exercise 06 — Constructor Design

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Constructors
* Parameterized constructors
* Object initialization
* Required vs optional data
* Constructor validation
* Valid object creation
* Establishing initial invariants

---

## Why This Matters

A common beginner approach:

```csharp
Customer customer = new Customer();

customer.Name = "Mohamed";
customer.Email = "test@test.com";
```

The problem:

Between these two lines:

```text
Object Created
        ↓
Data Assigned
```

the object exists but may be invalid.

Professional OOP asks:

> Can this object exist in an incomplete or invalid state?

If the answer is no, the constructor should enforce that.

---

# 🏢 Real-World Scenario

# Banking Application — Customer Account Creation

You are designing a banking system.

A bank account cannot exist without:

* Account number
* Customer name
* Initial balance

The system has rules:

* Account number is required.
* Customer name cannot be empty.
* Initial balance cannot be negative.
* Account status starts as Active.

---

# 📌 Requirements

Create a `BankAccount` class.

---

# Account State

The account should contain:

```text
AccountNumber
CustomerName
Balance
Status
```

---

# Object Creation Rules

The object must be created using:

```csharp
new BankAccount(...)
```

with required information.

---

# Validation Rules

The constructor should prevent:

```text
Empty account number

Empty customer name

Negative balance
```

---

# Behavior

The account should support:

## Deposit

```csharp
Deposit(decimal amount)
```

Rules:

* Amount must be positive.

---

## Withdraw

```csharp
Withdraw(decimal amount)
```

Rules:

* Amount must be positive.
* Cannot withdraw more than balance.

---

# 🧠 Engineering Focus

Before coding, think about:

---

# Question 1

## Should an empty account exist?

Bad:

```csharp
BankAccount account = new BankAccount();
```

Then:

```text
AccountNumber = null
CustomerName = null
Balance = 0
```

Is this a valid bank account?

No.

---

# Question 2

## Who guarantees initial validity?

Possible answers:

```text
UI
Controller
Service
Database
```

All are fragile.

The strongest place:

```text
BankAccount Constructor
```

because every account must pass through it.

---

# Question 3

## What belongs in constructor?

Required:

```text
Identity
Required information
Initial state
Validation
```

Not:

```text
Sending emails
Database calls
External API calls
```

---

# ❌ Bad Design Example

```csharp
public class BankAccount
{
    public string AccountNumber;

    public string CustomerName;

    public decimal Balance;

    public string Status;
}
```

Usage:

```csharp
BankAccount account =
    new BankAccount();


account.AccountNumber = "123";

account.CustomerName = "Ahmed";

account.Balance = 5000;

account.Status = "Active";
```

---

# Why This Is Poor Design

## 1. Invalid Object Can Exist

This is allowed:

```csharp
BankAccount account =
    new BankAccount();
```

The system has an incomplete account.

---

## 2. Initialization Responsibility Is Outside

Every caller must remember:

```text
Set account number

Set customer name

Set status
```

This creates duplication.

---

## 3. Rules Are Not Protected

Someone can do:

```csharp
account.Balance = -5000;
```

---

# ✅ Expected Design Direction

The object should require valid data during creation.

---

# Class Responsibility

```text
BankAccount

Responsible for:

- Valid creation
- Balance management
- Account rules
```

---

# Constructor Responsibility

The constructor should:

```text
Receive required data

Validate input

Create valid object
```

---

# Design

```text
        Constructor

             |
             ▼

     Validate Input

             |
             ▼

     Valid Account

             |
             ▼

 Deposit / Withdraw
```

---

# 💻 Solution

```csharp
using System;

public class BankAccount
{
    public string AccountNumber { get; }

    public string CustomerName { get; }

    public decimal Balance { get; private set; }

    public string Status { get; private set; }


    public BankAccount(
        string accountNumber,
        string customerName,
        decimal initialBalance)
    {
        if (string.IsNullOrWhiteSpace(accountNumber))
        {
            throw new ArgumentException(
                "Account number is required.");
        }


        if (string.IsNullOrWhiteSpace(customerName))
        {
            throw new ArgumentException(
                "Customer name is required.");
        }


        if (initialBalance < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(initialBalance),
                "Balance cannot be negative.");
        }


        AccountNumber = accountNumber;

        CustomerName = customerName;

        Balance = initialBalance;

        Status = "Active";
    }


    public void Deposit(decimal amount)
    {
        if (amount <= 0)
        {
            throw new ArgumentException(
                "Deposit amount must be positive.");
        }


        Balance += amount;
    }


    public void Withdraw(decimal amount)
    {
        if (amount <= 0)
        {
            throw new ArgumentException(
                "Withdrawal amount must be positive.");
        }


        if (amount > Balance)
        {
            throw new InvalidOperationException(
                "Insufficient balance.");
        }


        Balance -= amount;
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
        BankAccount account =
            new BankAccount(
                "ACC-1001",
                "Mohamed",
                5000);


        account.Deposit(1000);


        account.Withdraw(2000);


        Console.WriteLine(
            account.Balance);
    }
}
```

---

# Expected Output

```text
4000
```

---

# Invalid Creation Test

```csharp
BankAccount account =
    new BankAccount(
        "",
        "Ahmed",
        -500);
```

Expected:

```text
Exception

Account number is required.
```

---

# 🔍 Solution Explanation

## Why Are AccountNumber and CustomerName Getter-Only?

```csharp
public string AccountNumber { get; }
```

Because they represent identity.

After creation:

```text
ACC-1001
```

should not become:

```text
ACC-9999
```

randomly.

---

# Why Is Balance Private Set?

```csharp
public decimal Balance { get; private set; }
```

Because balance changes have rules.

External code should not do:

```csharp
account.Balance = -1000;
```

Only the account controls:

```text
Deposit

Withdraw
```

---

# Why Validate Inside Constructor?

Because every object creation goes through it.

Instead of:

```text
Create invalid object

Hope someone fixes it
```

we have:

```text
Require valid data

Create valid object
```

---

# Why Not Call Database Inside Constructor?

Bad:

```csharp
public BankAccount()
{
    SaveToDatabase();
}
```

Problems:

* Hard to test.
* Hidden side effects.
* Slow object creation.
* Tight coupling.

Constructor responsibility:

```text
Create object

Not run the application
```

---

# 💡 Senior Engineer Notes

## Constructor Design Principles

A good constructor:

✅ Creates valid objects
✅ Validates required input
✅ Establishes initial state
✅ Protects invariants

---

A bad constructor:

❌ Calls external services
❌ Performs heavy operations
❌ Contains business workflows
❌ Has too many unrelated parameters

---

# Constructor Parameter Explosion

Example:

```csharp
new Employee(
name,
email,
phone,
address,
city,
country,
department,
manager,
salary,
...)
```

This may indicate:

* Missing abstraction.
* Too much responsibility.
* Need for value objects.

---

# Real Production Considerations

A banking system may later introduce:

```text
BankAccount

AccountRepository

TransactionService

Money Value Object

AccountPolicy
```

depending on complexity.

---

# 🎤 Interview Connection

## Question 1

### Why do we use constructors?

Answer:

Constructors initialize objects and help guarantee that objects start in a valid state.

---

## Question 2

### What is constructor validation?

Answer:

Checking constructor inputs before assigning them to ensure invalid objects cannot be created.

---

## Question 3

### Should constructors contain business logic?

Answer:

Constructors should establish initial state and validate creation rules, but heavy workflows and external operations should usually be handled elsewhere.

---

## Question 4

### What is the difference between creating an object and initializing an object?

Answer:

Creating means allocating the object.

Initialization means assigning valid initial state.

A good constructor handles both together.

---

# 🧠 Engineering Reflection

Answer before moving forward:

```text
1. Why is BankAccount() without parameters dangerous?

2. Which fields should never change after creation?

3. Why does Balance need controlled modification?

4. What validation belongs inside constructor?

5. Why should constructors avoid database calls?
```

---

# 🏁 Key Takeaways

1. Constructors define the creation contract of an object.
2. Objects should start valid whenever possible.
3. Required data should be enforced during creation.
4. Constructor validation prevents invalid state.
5. Identity-related data is often immutable.
6. Mutable state should have controlled transitions.
7. Constructors create objects; they should not manage workflows.
8. Good constructor design is a foundation for Encapsulation.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 06 of 19 ✅
</p>
```


* Designing classes that cannot be misused.
