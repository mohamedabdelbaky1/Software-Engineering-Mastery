

# 🔧 Refactoring Challenge 01 — Public Fields to Encapsulation

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Beginner → Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on a banking application.

A developer created a simple `BankAccount` class.

The class works, but after deployment, several issues appeared:

* Account balance becomes invalid.
* Any part of the application can modify important data.
* Business rules are difficult to enforce.
* Developers cannot trust the object state.

Your task:

Refactor the class using proper encapsulation.

---

# 🔴 Original Code

```csharp
public class BankAccount
{
    public string AccountNumber;

    public string OwnerName;

    public decimal Balance;
}
```

---

# Example Usage

```csharp
BankAccount account =
    new BankAccount();


account.AccountNumber =
    "ACC-1001";


account.OwnerName =
    "Ahmed";


account.Balance =
    -5000;
```

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Public Fields

Current:

```csharp
public decimal Balance;
```

Any code can do:

```csharp
account.Balance = -10000;
```

The object has no control.

---

## Why Is This Dangerous?

The object can enter invalid states:

```text
Account

Balance = -10000
```

Now every part of the system must check:

```csharp
if(balance < 0)
{
    ...
}
```

---

# ❌ Problem 2 — No Encapsulation Boundary

Current design:

```text
External Code

      |
      |
      ↓

Direct Object Data
```

Any code can change anything.

---

A better design:

```text
External Code

      |
      |
      ↓

Public Methods

      |
      |
      ↓

Private State
```

---

# ❌ Problem 3 — No Object Responsibility

The class is only a data container:

```text
BankAccount

=
Variables
```

A good object should be:

```text
BankAccount

=
State

+

Behavior

+

Rules
```

---

# 🧠 Refactoring Strategy

We will improve the design step-by-step.

---

# Step 1 — Make Fields Private

Before:

```csharp
public decimal Balance;
```

After:

```csharp
private decimal balance;
```

Now external code cannot directly modify it.

---

# Step 2 — Expose Safe Access

We still need users to read the balance.

Add:

```csharp
public decimal Balance
{
    get
    {
        return balance;
    }
}
```

Now:

Allowed:

```csharp
Console.WriteLine(account.Balance);
```

Not allowed:

```csharp
account.Balance = -500;
```

---

# Step 3 — Add Controlled Behavior

Instead of:

```csharp
account.Balance += 1000;
```

Create:

```csharp
account.Deposit(1000);
```

The object controls the operation.

---

# Step 4 — Validate State Changes

The account should guarantee:

```text
Balance >= 0

Deposit amount > 0

Withdrawal amount > 0
```

---

# ✅ Refactored Code

```csharp
using System;


public class BankAccount
{
    private decimal balance;


    public string AccountNumber { get; }


    public string OwnerName { get; }



    public decimal Balance
    {
        get
        {
            return balance;
        }
    }



    public BankAccount(
        string accountNumber,
        string ownerName,
        decimal initialBalance)
    {
        if(string.IsNullOrWhiteSpace(accountNumber))
        {
            throw new ArgumentException(
                "Account number is required.");
        }


        if(string.IsNullOrWhiteSpace(ownerName))
        {
            throw new ArgumentException(
                "Owner name is required.");
        }


        if(initialBalance < 0)
        {
            throw new ArgumentException(
                "Initial balance cannot be negative.");
        }


        AccountNumber = accountNumber;

        OwnerName = ownerName;

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

## Valid Usage

```csharp
public class Program
{
    public static void Main()
    {
        BankAccount account =
            new BankAccount(
                "ACC-1001",
                "Ahmed",
                5000);



        account.Deposit(2000);


        account.Withdraw(1000);



        Console.WriteLine(
            account.Balance);
    }
}
```

---

# Output

```text
6000
```

---

# Invalid Usage

```csharp
account.Balance = -5000;
```

Compilation Error:

```text
Property or indexer 'Balance' cannot be assigned to
```

---

Invalid deposit:

```csharp
account.Deposit(-500);
```

Result:

```text
Exception:
Deposit must be positive.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
BankAccount

Public Data

Anyone can modify state
```

---

# After

```text
BankAccount

Private State

+

Controlled Operations

+

Validation
```

---

# Why Is This Better?

## 1. State Protection

Before:

```csharp
account.Balance = -5000;
```

Possible.

After:

Only:

```csharp
Deposit()

Withdraw()
```

can change balance.

---

## 2. Business Rules Are Centralized

Before:

Every developer must remember:

```text
Balance cannot be negative
```

After:

The class guarantees it.

---

## 3. Future Changes Become Easier

Suppose the bank adds:

* Transaction history
* Withdrawal limits
* Fraud checks

You modify:

```text
BankAccount
```

instead of searching the entire application.

---

# 🎤 Interview Discussion

---

## Q1: Why are public fields considered bad practice?

### Answer:

Because they expose internal state and allow uncontrolled modifications that can break object invariants.

---

## Q2: Is using properties enough for encapsulation?

### Answer:

No.

A property with a public setter:

```csharp
public decimal Balance {get;set;}
```

still allows uncontrolled changes.

---

## Q3: What is the difference between data hiding and encapsulation?

### Answer:

Data hiding restricts access.

Encapsulation also controls behavior and protects rules.

---

## Q4: Why should objects control their own state changes?

### Answer:

Because the object owns the rules related to that state.

---

# 🧠 Refactoring Checklist

Before approving this refactoring:

```text
☑ Are important fields private?

☑ Are changes controlled through methods?

☑ Can the object enter invalid states?

☑ Are constructors creating valid objects?

☑ Does the class protect its own rules?
```

---

# 🏁 Key Takeaways

1. Public fields expose implementation details.
2. Private state creates a protection boundary.
3. Objects should control how their state changes.
4. Encapsulation protects correctness, not only privacy.
5. A good object makes invalid states difficult to create.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 01 Completed ✅
</p>

---

