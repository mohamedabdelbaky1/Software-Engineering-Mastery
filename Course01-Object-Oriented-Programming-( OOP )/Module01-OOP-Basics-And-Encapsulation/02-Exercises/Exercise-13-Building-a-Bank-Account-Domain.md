

# 🧩 Exercise 13 — Building a Bank Account Domain

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟠 Real-World Domain Design
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* Complete object modeling
* Domain entities
* Encapsulation
* Constructor design
* Access modifiers
* Invariants
* Controlled behavior
* State transitions
* Object responsibility

---

# Why This Matters

A professional developer does not design classes as:

```text
Class = Data Holder
```

Instead:

```text
Class = Real-world responsibility
```

A bank account is not just:

```text
Account Number
Balance
Owner
```

It also contains rules:

```text
Can money be withdrawn?

Can the account be closed?

Can balance become negative?

Can inactive accounts receive transactions?
```

The object must protect these rules.

---

# 🏢 Real-World Scenario

## Banking Application

You are building the account module of a banking system.

A bank account has:

* Identity
* Owner information
* Balance
* Status
* Transaction history

---

The account lifecycle:

```text
Active

   |
   |
   ▼

Suspended

   |
   |
   ▼

Closed
```

---

# 📌 Requirements

Create a `BankAccount` class.

---

# Account State

The account should contain:

```text
Account Number

Owner Name

Balance

Status

Transactions
```

---

# Account Rules

The object must guarantee:

```text
Account number cannot change.

Balance cannot be modified directly.

Balance cannot become negative.

Closed accounts cannot perform transactions.

Transaction history cannot be modified externally.
```

---

# Account Behaviors

---

## Deposit

```csharp
Deposit(decimal amount)
```

Rules:

* Amount must be positive.
* Account cannot be closed.

---

## Withdraw

```csharp
Withdraw(decimal amount)
```

Rules:

* Amount must be positive.
* Balance must be sufficient.
* Account cannot be closed.

---

## Suspend Account

```csharp
Suspend()
```

Rules:

Allowed:

```text
Active → Suspended
```

---

## Close Account

```csharp
Close()
```

Rules:

Allowed:

```text
Active → Closed

Suspended → Closed
```

---

# 🧠 Engineering Focus

## Question 1

### Who owns balance rules?

Bad:

```text
BankService
Controller
UI
```

Better:

```text
BankAccount
```

Because:

```text
BankAccount owns Balance.
```

---

# Question 2

## Should Balance Be Public?

Bad:

```csharp
account.Balance = 1000000;
```

Problems:

* No validation.
* No transaction record.
* No business meaning.

---

Better:

```csharp
account.Deposit(1000000);
```

---

# Question 3

## Should Transactions Be Public?

Bad:

```csharp
account.Transactions.Clear();
```

This destroys history.

The account should own transaction management.

---

# ❌ Bad Design Example

```csharp
public class BankAccount
{
    public string AccountNumber;

    public string OwnerName;

    public decimal Balance;

    public string Status;

    public List<string> Transactions;
}
```

Usage:

```csharp
account.Balance = -500;

account.Status = "Closed";

account.Transactions.Clear();
```

---

# Why This Is Poor Design

## 1. No Encapsulation

Everything is exposed.

---

## 2. Invalid States Exist

Example:

```text
Closed account

+
Successful withdrawal
```

---

## 3. No Audit Trail

Balance changes happen without records.

---

# ✅ Expected Design Direction

The class should become:

```text
BankAccount

Owns:

Identity
State
Rules
Behavior
```

---

# Design

```text
BankAccount

Public:

AccountNumber
OwnerName
Balance
Status

Deposit()
Withdraw()
Suspend()
Close()


Private:

Transactions
Validation Rules
```

---

# 💻 Solution

## Account Status

```csharp
public enum AccountStatus
{
    Active,
    Suspended,
    Closed
}
```

---

## Transaction

```csharp
public class Transaction
{
    public string Type { get; }

    public decimal Amount { get; }

    public DateTime Date { get; }


    public Transaction(
        string type,
        decimal amount)
    {
        Type = type;
        Amount = amount;
        Date = DateTime.Now;
    }
}
```

---

## BankAccount

```csharp
using System;
using System.Collections.Generic;


public class BankAccount
{
    private readonly List<Transaction> transactions = new();


    public string AccountNumber { get; }

    public string OwnerName { get; }

    public decimal Balance { get; private set; }

    public AccountStatus Status { get; private set; }


    public IReadOnlyList<Transaction> Transactions 
        => transactions;



    public BankAccount(
        string accountNumber,
        string ownerName,
        decimal initialBalance)
    {
        if (string.IsNullOrWhiteSpace(accountNumber))
        {
            throw new ArgumentException(
                "Account number required.");
        }


        if (initialBalance < 0)
        {
            throw new ArgumentException(
                "Invalid balance.");
        }


        AccountNumber = accountNumber;

        OwnerName = ownerName;

        Balance = initialBalance;

        Status = AccountStatus.Active;
    }



    public void Deposit(decimal amount)
    {
        EnsureAccountIsActive();


        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be positive.");
        }


        Balance += amount;


        transactions.Add(
            new Transaction(
                "Deposit",
                amount));
    }



    public void Withdraw(decimal amount)
    {
        EnsureAccountIsActive();


        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be positive.");
        }


        if (amount > Balance)
        {
            throw new InvalidOperationException(
                "Insufficient balance.");
        }


        Balance -= amount;


        transactions.Add(
            new Transaction(
                "Withdrawal",
                amount));
    }



    public void Suspend()
    {
        if (Status != AccountStatus.Active)
        {
            throw new InvalidOperationException(
                "Only active accounts can be suspended.");
        }


        Status = AccountStatus.Suspended;
    }



    public void Close()
    {
        if (Status == AccountStatus.Closed)
        {
            throw new InvalidOperationException(
                "Account already closed.");
        }


        Status = AccountStatus.Closed;
    }



    private void EnsureAccountIsActive()
    {
        if (Status == AccountStatus.Closed)
        {
            throw new InvalidOperationException(
                "Closed account cannot perform operations.");
        }
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
                "ACC-001",
                "Mohamed",
                5000);


        account.Deposit(1000);


        account.Withdraw(2000);


        Console.WriteLine(
            account.Balance);


        Console.WriteLine(
            account.Transactions.Count);
    }
}
```

---

# Expected Output

```text
4000

2
```

---

# Invalid Operation Test

```csharp
account.Close();

account.Deposit(500);
```

Expected:

```text
Exception

Closed account cannot perform operations.
```

---

# 🔍 Solution Explanation

## Why Is Balance Private Set?

Because balance changes are business actions:

```text
Deposit
Withdraw
```

not simple assignments.

---

## Why Are Transactions Private?

Because history is owned by the account.

External code should view it:

```csharp
account.Transactions
```

but not modify it.

---

## Why Does Account Validate Operations?

Because it owns:

```text
Balance
Status
Transactions
```

Therefore it owns their rules.

---

## Why Use Methods Instead of Setters?

Compare:

```csharp
account.Status = Closed;
```

with:

```csharp
account.Close();
```

The second expresses:

* Intent.
* Business meaning.
* Validation.

---

# 💡 Senior Engineer Notes

## Entity Thinking

A bank account is an entity because it has:

### Identity

```text
Account Number
```

### State

```text
Balance
Status
```

### Behavior

```text
Deposit
Withdraw
Close
```

---

## Encapsulation Goal

Encapsulation is not:

> "Make fields private."

The real goal:

> "Prevent invalid behavior and protect business rules."

---

# 🎤 Interview Connection

## Question 1

### What makes a class a good domain object?

Answer:

A good domain object:

* Has clear identity.
* Owns related state.
* Contains relevant behavior.
* Protects business rules.

---

## Question 2

### Why should balance changes not happen through setters?

Answer:

Because balance changes require validation and represent business operations.

---

## Question 3

### What is the benefit of keeping invariants inside the entity?

Answer:

The entity guarantees correctness regardless of where it is used.

---

## Question 4

### What is the difference between an entity and a data object?

Answer:

An entity has identity and behavior.

A data object mainly carries information.

---

# 🧠 Engineering Reflection

```text
1. Why does BankAccount own Deposit()?

2. Why is Balance not directly writable?

3. Which invariants does this class protect?

4. Why is Transaction history encapsulated?

5. How would this design scale in a banking application?
```

---

# 🏁 Key Takeaways

1. Real objects contain both data and behavior.
2. Entities protect their own rules.
3. Constructors establish valid initial state.
4. Methods represent meaningful business actions.
5. Collections should be protected.
6. State transitions should be controlled.
7. Encapsulation creates reliable software objects.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 13 of 19 ✅
</p>
```


* Immutable design patterns in C#.
