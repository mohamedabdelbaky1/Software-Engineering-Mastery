

# 🧩 Exercise 08 — Access Modifiers Practice

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🟡 Design Thinking
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise focuses on:

* `public`
* `private`
* `protected`
* `internal`
* Access boundaries
* Public API design
* Implementation details
* Encapsulation through access control

---

## Why This Matters

A beginner often thinks:

> "Make everything public so it is easier to use."

Example:

```csharp
public decimal Balance;
public string Password;
public List<Transaction> Transactions;
```

This creates a weak design because every part of the application can access and modify internal data.

Professional developers ask:

```text
Who needs access?

Why do they need access?

Should they be able to modify it?

Should this detail be visible outside the class?
```

---

# 🏢 Real-World Scenario

# Banking System — Account Security

You are designing a banking application.

The system contains:

* Bank accounts
* Transactions
* Account operations

A bank account has:

```text
Account Number
Owner Name
Balance
PIN
Transaction History
```

---

The system has security rules:

* Customers can view account information.
* Customers cannot directly modify balance.
* PIN should never be publicly accessible.
* Transaction history should not be replaced externally.
* Internal banking services may access some internal details.
* Specialized account types should be able to extend account behavior.

---

# 📌 Requirements

Create a `BankAccount` class.

---

# Public Members

The outside world should access:

```text
AccountNumber
OwnerName
Balance
Deposit()
Withdraw()
```

---

# Private Members

Only the account itself should access:

```text
PIN
Transaction storage
Validation helpers
```

---

# Protected Members

Child classes should be able to access:

```text
Account rules
Internal account operations
```

Example:

```text
SavingsAccount
PremiumAccount
```

---

# Internal Members

Members available only inside the banking application:

Example:

```text
Banking system audit operations
```

---

# 🧠 Engineering Focus

Before coding, think about access.

---

# Question 1

## Should Balance be public?

Bad:

```csharp
public decimal Balance;
```

This allows:

```csharp
account.Balance = -10000;
```

Who should control balance changes?

Answer:

```text
BankAccount
```

---

# Question 2

## Should PIN be public?

Example:

```csharp
public string Pin;
```

Problems:

* Security risk.
* Any object can read it.
* Any object can modify it.

Better:

```csharp
private string pin;
```

---

# Question 3

## Should Transaction History be public?

Bad:

```csharp
public List<Transaction> Transactions;
```

External code can:

```csharp
account.Transactions.Clear();
```

The account loses control.

---

# ❌ Bad Design Example

```csharp
public class BankAccount
{
    public string AccountNumber;

    public string OwnerName;

    public decimal Balance;

    public string Pin;

    public List<string> Transactions;
}
```

Usage:

```csharp
BankAccount account = new BankAccount();

account.Balance = -5000;

account.Pin = "1234";

account.Transactions.Clear();
```

---

# Why This Is Poor Design

## 1. No Access Control

Everything is exposed.

---

## 2. Internal Details Leak

External code depends on:

```text
How the account stores transactions
```

---

## 3. Rules Can Be Bypassed

The object cannot guarantee:

```text
Balance is valid.

PIN is protected.

Transactions are consistent.
```

---

# ✅ Expected Design Direction

Design the access boundary.

---

## BankAccount

```text
Public API

    ↓

Controlled Operations

    ↓

Private Implementation
```

---

# Design

```text
BankAccount

Public:
    AccountNumber
    OwnerName
    Balance
    Deposit()
    Withdraw()


Private:
    PIN
    transactions
    ValidateAmount()


Protected:
    AccountRules


Internal:
    AuditInformation()
```

---

# 💻 Solution

```csharp
using System;
using System.Collections.Generic;


public class BankAccount
{
    private readonly string pin;

    private readonly List<string> transactions = new();


    protected decimal MinimumBalanceRule = 0;


    public string AccountNumber { get; }

    public string OwnerName { get; }

    public decimal Balance { get; private set; }


    internal string AuditCode { get; private set; }


    public BankAccount(
        string accountNumber,
        string ownerName,
        string pin,
        decimal initialBalance)
    {
        AccountNumber = accountNumber;

        OwnerName = ownerName;

        this.pin = pin;

        Balance = initialBalance;

        AuditCode = Guid.NewGuid().ToString();
    }


    public void Deposit(decimal amount)
    {
        ValidateAmount(amount);

        Balance += amount;

        transactions.Add(
            $"Deposit: {amount}");
    }


    public void Withdraw(decimal amount)
    {
        ValidateAmount(amount);


        if (Balance - amount < MinimumBalanceRule)
        {
            throw new InvalidOperationException(
                "Insufficient balance.");
        }


        Balance -= amount;

        transactions.Add(
            $"Withdraw: {amount}");
    }


    private void ValidateAmount(decimal amount)
    {
        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be positive.");
        }
    }


    protected bool IsValidPin(string input)
    {
        return input == pin;
    }


    internal List<string> GetAuditTransactions()
    {
        return transactions;
    }
}
```

---

# Extension Example

A child class:

```csharp
public class SavingsAccount : BankAccount
{
    public SavingsAccount(
        string accountNumber,
        string ownerName,
        string pin,
        decimal balance)
        : base(
            accountNumber,
            ownerName,
            pin,
            balance)
    {

    }


    public void ApplyMinimumBalanceRule()
    {
        MinimumBalanceRule = 1000;
    }
}
```

Here:

```csharp
protected
```

allows inheritance access.

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
                "1234",
                5000);


        Console.WriteLine(
            account.Balance);


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
5000

4000
```

---

# Invalid Access Examples

These should NOT compile:

```csharp
account.pin = "9999";
```

because:

```text
private
```

---

```csharp
account.transactions.Clear();
```

because:

```text
private
```

---

```csharp
account.Balance = -500;
```

because:

```text
private set
```

---

# 🔍 Solution Explanation

## Why Is Balance Public But Private Set?

```csharp
public decimal Balance { get; private set; }
```

The user needs to see balance.

But only the account should modify it.

---

## Why Is PIN Private?

Because it is an implementation detail and sensitive information.

No external object should depend on it.

---

## Why Is MinimumBalanceRule Protected?

Because specialized account types may need to customize account rules.

Example:

```text
SavingsAccount
PremiumAccount
```

---

## Why Is AuditCode Internal?

Because it belongs to the banking application, not external users.

---

# 💡 Senior Engineer Notes

## Access Modifiers Define Design Boundaries

Think of them as architecture decisions.

---

## Public

Meaning:

> "This is part of my official API."

Use carefully.

---

## Private

Meaning:

> "This is my implementation detail."

Default choice for internal state.

---

## Protected

Meaning:

> "My child classes may customize this behavior."

Use carefully because inheritance creates coupling.

---

## Internal

Meaning:

> "Only this application/module should use this."

Useful for large systems.

---

# Common Mistakes

## ❌ Making Everything Public

```text
Easy now

Hard later
```

---

## ❌ Using Protected Everywhere

Inheritance creates hidden dependencies.

---

## ❌ Exposing Collections

```csharp
public List<T>
```

Usually leaks internal state.

---

## ❌ Confusing Private With Security

`private` protects code boundaries.

It does not replace real security mechanisms.

---

# 🎤 Interview Connection

## Question 1

### What is the purpose of access modifiers?

Answer:

Access modifiers control visibility and define boundaries between public APIs and internal implementation details.

---

## Question 2

### Why should fields usually be private?

Answer:

Because exposing fields allows uncontrolled access and makes future changes harder.

---

## Question 3

### Difference between private and protected?

Answer:

`private` is accessible only inside the declaring class.

`protected` is accessible inside the class and derived classes.

---

## Question 4

### Is protected always better than private?

No.

Protected creates inheritance coupling.

Use it only when derived classes genuinely need access.

---

# 🧠 Engineering Reflection

Answer:

```text
1. Why is Balance not publicly writable?

2. Why is PIN private?

3. When would protected be useful?

4. Why can exposing List<T> be dangerous?

5. Which members should be part of the public API?
```

---

# 🏁 Key Takeaways

1. Access modifiers create object boundaries.
2. Public members define the external API.
3. Private members protect implementation details.
4. Protected enables controlled inheritance.
5. Internal limits access to the application/module.
6. Good design exposes behavior, not unnecessary data.
7. Access control is a fundamental tool for Encapsulation.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 08 of 19 ✅
</p>
```

