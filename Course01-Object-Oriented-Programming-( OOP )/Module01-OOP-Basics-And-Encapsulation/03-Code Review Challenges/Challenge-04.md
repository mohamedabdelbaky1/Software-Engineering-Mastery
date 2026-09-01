

# 🔍 Code Review Challenge 04 — Missing Encapsulation

> **Module:** OOP Basics & Encapsulation
> **Category:** Code Review
> **Difficulty:** 🟠 Mid-Level Engineering Thinking
> **Language:** C#

---

# 📌 Scenario

You are reviewing an online banking system.

The team created a `BankAccount` class.

The developer claims:

> "The fields are private, so the class is fully encapsulated."

You review the implementation and discover that the object can still enter invalid states.

Your task:

Find the hidden encapsulation problems.

---

# 👀 Code Under Review

```csharp
using System;


public class BankAccount
{
    private decimal balance;


    public string AccountNumber { get; }

    public decimal Balance
    {
        get
        {
            return balance;
        }

        private set
        {
            balance = value;
        }
    }



    public BankAccount(
        string accountNumber,
        decimal initialBalance)
    {
        AccountNumber = accountNumber;

        Balance = initialBalance;
    }



    public void Deposit(decimal amount)
    {
        Balance += amount;
    }



    public void Withdraw(decimal amount)
    {
        Balance -= amount;
    }
}
```

---

# Example Usage

```csharp
BankAccount account =
    new BankAccount(
        "ACC-100",
        5000);



account.Deposit(-1000);



account.Withdraw(10000);
```

---

# 🔴 Review Findings

---

# Issue 1 — Private Fields Are Not Enough

## Problem

The field is private:

```csharp
private decimal balance;
```

But the object still allows invalid changes.

Example:

```csharp
account.Deposit(-1000);
```

Result:

```text
Balance becomes 4000
```

The method accepts invalid behavior.

---

# Senior Engineer Thinking

Ask:

> Can users of this class perform an operation that violates business rules?

Yes.

Therefore:

Encapsulation is incomplete.

---

# Issue 2 — Missing Validation Rules

Current:

```csharp
public void Deposit(decimal amount)
{
    Balance += amount;
}
```

Possible:

```csharp
Deposit(-5000);
```

A deposit should never decrease money.

---

Correct thinking:

```text
Deposit

must guarantee:

amount > 0
```

---

# Issue 3 — Withdraw Allows Invalid State

Current:

```csharp
public void Withdraw(decimal amount)
{
    Balance -= amount;
}
```

Problem:

```csharp
account.Withdraw(10000);
```

Result:

```text
Balance = -5000
```

The object is now invalid.

---

# Issue 4 — Constructor Allows Invalid Objects

Current:

```csharp
new BankAccount(
    "ACC-100",
    -5000);
```

Creates:

```text
Account

Balance = -5000
```

The object starts invalid.

---

# 🧠 Senior Engineer Analysis

A senior developer asks:

---

## Question 1

### Who owns balance rules?

Answer:

```text
BankAccount
```

Because:

```text
BankAccount owns balance state.
```

---

## Question 2

### Are public methods always safe?

No.

A method is part of the public API.

It must protect the object.

---

## Question 3

### What is the real purpose of encapsulation?

Not:

```text
Hide variables
```

But:

```text
Protect object correctness
```

---

# ❌ Design Problems Summary

| Problem                            | Severity  | Reason                     |
| ---------------------------------- | --------- | -------------------------- |
| No validation in methods           | 🔴 High   | Invalid operations allowed |
| Constructor accepts invalid state  | 🔴 High   | Object starts broken       |
| Private field gives false security | 🔴 High   | Encapsulation incomplete   |
| No business rules                  | 🟠 Medium | Weak domain object         |

---

# ✅ Recommended Design Direction

The object should guarantee:

```text
BankAccount

Always true:

Balance >= 0

Deposit amount > 0

Withdrawal amount > 0

Withdrawal <= Balance
```

These are called:

# Invariants

An invariant is:

> A condition that must always remain true while the object exists.

---

# Refactored Version

```csharp
using System;


public class BankAccount
{
    private decimal balance;


    public string AccountNumber { get; }


    public decimal Balance
    {
        get
        {
            return balance;
        }
    }



    public BankAccount(
        string accountNumber,
        decimal initialBalance)
    {
        if(string.IsNullOrWhiteSpace(accountNumber))
        {
            throw new ArgumentException(
                "Account number required.");
        }


        if(initialBalance < 0)
        {
            throw new ArgumentException(
                "Balance cannot be negative.");
        }


        AccountNumber = accountNumber;

        balance = initialBalance;
    }



    public void Deposit(decimal amount)
    {
        if(amount <= 0)
        {
            throw new ArgumentException(
                "Deposit must be positive.");
        }


        balance += amount;
    }



    public void Withdraw(decimal amount)
    {
        if(amount <= 0)
        {
            throw new ArgumentException(
                "Withdrawal must be positive.");
        }


        if(amount > balance)
        {
            throw new InvalidOperationException(
                "Insufficient balance.");
        }


        balance -= amount;
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
                "ACC-100",
                5000);



        account.Deposit(1000);


        account.Withdraw(2000);


        Console.WriteLine(
            account.Balance);
    }
}
```

---

# Output

```text
4000
```

---

# Invalid Test

```csharp
account.Deposit(-500);
```

Result:

```text
Exception

Deposit must be positive.
```

---

# Invalid Test

```csharp
account.Withdraw(10000);
```

Result:

```text
Exception

Insufficient balance.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Private field

+

Unsafe methods
```

The object could still break.

---

# After

```text
Private state

+

Protected operations

+

Guaranteed rules
```

---

# Why Remove Private Setter?

Before:

```csharp
Balance { get; private set; }
```

Although external code cannot set it, the class itself can do:

```csharp
Balance = -1000;
```

without protection.

---

After:

```csharp
private decimal balance;
```

Only controlled methods modify it.

---

# Why Are Invariants Important?

Without invariants:

```text
Account

Balance = -5000
```

The rest of the system must constantly check:

```csharp
if(balance < 0)
```

everywhere.

With invariants:

```text
BankAccount guarantees correctness.
```

---

# 🎤 Interview Discussion

---

## Q1: Is making fields private enough for encapsulation?

### Answer:

No.

Encapsulation requires controlling access and protecting business rules.

---

## Q2: What is an invariant?

### Answer:

A condition that must always be true for an object throughout its lifetime.

---

## Q3: Where should validation happen?

### Answer:

Close to the object that owns the rule, usually inside constructors and behavior methods.

---

## Q4: Why are methods part of encapsulation?

### Answer:

Because methods define the allowed ways external code can interact with object state.

---

# 🧠 Reviewer Checklist

When reviewing encapsulation:

```text
☑ Are fields protected?

☑ Can methods create invalid state?

☑ Does the constructor create valid objects?

☑ Are business rules inside the owner object?

☑ Can external code bypass rules?
```

---

# 🏁 Key Takeaways

1. Private fields alone do not guarantee encapsulation.
2. Public methods must protect object rules.
3. Constructors should create valid objects.
4. Invariants are the foundation of reliable objects.
5. Encapsulation protects behavior, not only data.
6. A good object makes incorrect usage difficult.

---

<p align="center">
<strong>03-Code-Review-Challenges</strong><br>
Challenge 04 Completed ✅
</p>

---

