# 🔐 Lesson 06 — Access Modifiers

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ Why Access Control Matters](#1️⃣-why-access-control-matters)
- [2️⃣ What Is an Access Modifier?](#2️⃣-what-is-an-access-modifier)
- [3️⃣ `public`](#3️⃣-public)
- [4️⃣ `private`](#4️⃣-private)
- [5️⃣ `protected`](#5️⃣-protected)
- [6️⃣ `internal`](#6️⃣-internal)
- [7️⃣ Combined Access Modifiers](#7️⃣-combined-access-modifiers)
- [8️⃣ Type Accessibility vs Member Accessibility](#8️⃣-type-accessibility-vs-member-accessibility)
- [9️⃣ Public API vs Implementation Details](#9️⃣-public-api-vs-implementation-details)
- [🔟 Why Everything Should Not Be Public](#-why-everything-should-not-be-public)
- [1️⃣1️⃣ Access Modifiers and Object Boundaries](#1️⃣1️⃣-access-modifiers-and-object-boundaries)
- [1️⃣2️⃣ Access Modifiers and State Protection](#1️⃣2️⃣-access-modifiers-and-state-protection)
- [1️⃣3️⃣ Access Modifiers Do Not Equal Encapsulation](#1️⃣3️⃣-access-modifiers-do-not-equal-encapsulation)
- [1️⃣4️⃣ Common Design Mistakes](#1️⃣4️⃣-common-design-mistakes)
- [1️⃣5️⃣ Junior vs Senior Thinking](#1️⃣5️⃣-junior-vs-senior-thinking)
- [🎤 Interview Perspective](#-interview-perspective)
- [🧩 Mental Models](#-mental-models)
- [📝 Cheat Sheet](#-cheat-sheet)
- [✅ Key Takeaways](#-key-takeaways)
- [➡️ Next Lesson](#️-next-lesson)

---

# 🎯 Learning Goals

By the end of this lesson, you should understand:

- What access modifiers are.
- Why access control exists in object-oriented programming.
- The difference between `public`, `private`, `protected`, and `internal`.
- The purpose of `protected internal` and `private protected`.
- The difference between type accessibility and member accessibility.
- Why a class should expose only what callers actually need.
- What a **public API** means.
- What **implementation details** are.
- Why unrestricted accessibility increases coupling.
- How access modifiers support object boundaries.
- Why access modifiers help Encapsulation but do not create it automatically.

---

# 1️⃣ Why Access Control Matters

Suppose we have this class:

```csharp
public class BankAccount
{
    public decimal Balance;
    public string AccountNumber;
    public string InternalSecurityCode;
}
```

External code can access everything:

```csharp
BankAccount account = new BankAccount();

account.Balance = -100000;
account.AccountNumber = "CHANGED";
account.InternalSecurityCode = "ABC";
```

The problem is not only that the data can be changed.

The deeper problem is:

> The class has no meaningful boundary.

Anything outside the object can reach its internal details.

This makes it difficult to answer questions such as:

```text
What is safe to use?

What is internal implementation?

What can external code modify?

What should remain hidden?

What can change without breaking callers?
```

Access modifiers help define those boundaries.

---

# 2️⃣ What Is an Access Modifier?

An **access modifier** controls where a type or member can be accessed from.

In C#, the main access modifiers are:

```text
public
private
protected
internal
```

There are also combinations:

```text
protected internal
private protected
```

At a high level:

```text
Access Modifier
      │
      ▼
Defines who is allowed to access something
```

That "something" may be:

- A class
- A method
- A field
- A property
- A constructor
- Another nested type

---

# 3️⃣ `public`

`public` means the member or type is accessible from any code that can access the containing type/assembly reference.

Example:

```csharp
public class Car
{
    public string Brand { get; set; }

    public void Start()
    {
        Console.WriteLine("Started");
    }
}
```

External code can use:

```csharp
Car car = new Car();

car.Brand = "BMW";
car.Start();
```

---

## When `public` Makes Sense

Use `public` when the member is intentionally part of the class's external contract.

Examples:

```csharp
account.Deposit(1000);
order.Cancel();
cart.AddItem(product);
```

These operations may be legitimate things callers should perform.

---

## Public Means Commitment

Once something becomes `public`, other code can depend on it.

That means changing it later may break callers.

Conceptually:

```text
public member
      ↓
External code depends on it
      ↓
Future changes become harder
```

> [!IMPORTANT]
> Making a member public is not merely a syntax choice.  
> It is an API design decision.

---

# 4️⃣ `private`

`private` means the member is accessible only inside the containing type.

Example:

```csharp
public class BankAccount
{
    private decimal balance;

    public void Deposit(decimal amount)
    {
        balance += amount;
    }
}
```

External code cannot do:

```csharp
account.balance = 1000;
```

because `balance` is private.

But code inside `BankAccount` can access it:

```csharp
public void Deposit(decimal amount)
{
    balance += amount;
}
```

---

## Why `private` Is Useful

`private` allows a class to hide implementation details.

Conceptually:

```text
Outside World
     │
     │ cannot access directly
     ▼
private implementation
```

This makes it possible to change internal implementation without necessarily affecting callers.

---

## Example

Version 1:

```csharp
public class BankAccount
{
    private decimal balance;

    public decimal GetBalance()
    {
        return balance;
    }
}
```

Later, the internal representation may change.

As long as the public contract remains compatible, external code may not need to change.

That is one major benefit of hiding implementation details.

---

# 5️⃣ `protected`

`protected` means a member is accessible:

- Inside the containing class
- Inside derived classes

Example:

```csharp
public class Employee
{
    protected decimal salary;
}
```

A derived class can access it:

```csharp
public class Manager : Employee
{
    public void IncreaseSalary(decimal amount)
    {
        salary += amount;
    }
}
```

But unrelated external code cannot do:

```csharp
manager.salary = 10000;
```

---

## Mental Model

```text
Base Class
   │
   ├── can access protected member
   │
   ▼
Derived Class
   │
   └── can also access it
```

---

## Important Design Note

`protected` is more open than `private`.

It exposes implementation details to subclasses.

That increases coupling between the base class and derived classes.

So:

> [!WARNING]
> Do not use `protected` automatically just because inheritance exists.

A strong default is often:

```text
private first
```

Then increase visibility only when a real requirement justifies it.

---

# 6️⃣ `internal`

`internal` means the type or member is accessible only within the same assembly.

Example:

```csharp
internal class PaymentValidator
{
}
```

Code in the same assembly can use it.

Code in another assembly normally cannot.

---

## What Is an Assembly?

In simple terms, an assembly is typically the compiled output of a .NET project, such as:

```text
MyApp.dll
```

So `internal` is useful when something should be available across the current project/assembly but not exposed as part of the external public API.

---

## Example

```csharp
public class PaymentService
{
    public void Pay()
    {
        PaymentValidator validator = new PaymentValidator();
    }
}

internal class PaymentValidator
{
}
```

External consumers can use:

```text
PaymentService
```

but the internal helper remains hidden from them.

---

# 7️⃣ Combined Access Modifiers

C# supports two additional combinations.

---

## `protected internal`

Accessible from:

```text
Same assembly
OR
Derived classes in other assemblies
```

Example:

```csharp
protected internal void Validate()
{
}
```

Think:

```text
protected OR internal
```

---

## `private protected`

Accessible from:

```text
Derived classes
AND
only when they are in the same assembly
```

Think:

```text
protected AND internal
```

---

## Quick Comparison

| Modifier | Same Class | Derived Class | Same Assembly | Other Assemblies |
|---|---:|---:|---:|---:|
| `public` | ✅ | ✅ | ✅ | ✅ |
| `private` | ✅ | ❌ | ❌ | ❌ |
| `protected` | ✅ | ✅ | Not by assembly alone | Through inheritance |
| `internal` | ✅ | ✅ | ✅ | ❌ |
| `protected internal` | ✅ | ✅ | ✅ | Derived types |
| `private protected` | ✅ | ✅ in same assembly | Limited | ❌ |

> [!NOTE]
> At this stage, the four most important modifiers are:
>
> `public`, `private`, `protected`, and `internal`.

---

# 8️⃣ Type Accessibility vs Member Accessibility

Access modifiers can apply to types and to members.

---

## Type Accessibility

Example:

```csharp
public class Customer
{
}
```

The class itself is public.

Another example:

```csharp
internal class CustomerValidator
{
}
```

The class is visible only inside the same assembly.

---

## Member Accessibility

Example:

```csharp
public class Customer
{
    public string Name { get; private set; }

    private bool IsValidEmail(string email)
    {
        return true;
    }
}
```

Here:

```text
Customer          → public type
Name              → public getter / private setter
IsValidEmail()    → private method
```

Different members can have different accessibility.

---

## Top-Level Type Defaults

If no access modifier is specified on a top-level class:

```csharp
class Customer
{
}
```

it is `internal` by default.

---

## Class Member Defaults

If no access modifier is specified on a class member:

```csharp
public class Customer
{
    string name;
}
```

the field is `private` by default.

Still, explicitly writing the intended modifier is often clearer.

---

# 9️⃣ Public API vs Implementation Details

This distinction is extremely important.

Consider:

```csharp
public class BankAccount
{
    public void Deposit(decimal amount)
    {
    }

    private bool IsValidAmount(decimal amount)
    {
        return amount > 0;
    }
}
```

From the caller's perspective:

```text
Deposit()
```

is part of the class's public API.

But:

```text
IsValidAmount()
```

is an implementation detail.

---

## Public API

The public API is what external callers are intentionally allowed to use.

Example:

```text
Deposit()
Withdraw()
Balance
```

---

## Implementation Details

These are internal decisions used to make the class work.

Example:

```text
Validation helper
Calculation helper
Internal field
Temporary algorithm
```

External callers should usually not depend on them.

---

## Why This Separation Matters

Suppose external code depends on:

```csharp
account.CalculateInternalRiskScore();
```

If that method should really be private, making it public creates unnecessary dependency.

Now changing the internal implementation becomes harder.

Good boundaries aim for:

```text
Small public surface
+
Hidden implementation details
```

---

# 🔟 Why Everything Should Not Be Public

This class exposes almost everything:

```csharp
public class Order
{
    public List<string> Items;
    public decimal Total;
    public string Status;

    public void RecalculateInternalValues()
    {
    }

    public void ResetEverything()
    {
    }
}
```

External code can:

```text
Modify items directly
Change total
Change status
Call internal maintenance methods
Reset state
```

The object has almost no control.

---

## Problems with Excessive Public Access

### 1. More Coupling

More external code can depend on internal details.

### 2. Harder Refactoring

Changing internal members may break callers.

### 3. Invalid State

External code can bypass business rules.

### 4. Larger API Surface

Developers have more things to understand.

### 5. Unclear Intent

Callers may not know which members are truly meant for normal use.

---

## Better Direction

Expose only what callers need.

```csharp
public class Order
{
    private readonly List<string> items = new();

    public string Status { get; private set; }

    public void AddItem(string item)
    {
        items.Add(item);
    }

    public void Cancel()
    {
        Status = "Cancelled";
    }
}
```

The object exposes meaningful behavior rather than every internal detail.

---

# 1️⃣1️⃣ Access Modifiers and Object Boundaries

An object should have a boundary between:

```text
What outsiders may use
```

and:

```text
How the object works internally
```

Conceptually:

```text
          External Code
               │
               ▼
      ┌──────────────────┐
      │    Public API    │
      ├──────────────────┤
      │ Internal Logic   │
      │ Private State    │
      │ Helper Methods   │
      └──────────────────┘
```

Access modifiers help implement this boundary.

---

## Boundary Thinking

Instead of asking:

> Can this be public?

ask:

> Does this need to be public?

That is a much stronger engineering question.

---

# 1️⃣2️⃣ Access Modifiers and State Protection

Consider:

```csharp
public class BankAccount
{
    public decimal Balance { get; set; }
}
```

Although this uses a property, external code can still change the balance.

A stronger version:

```csharp
public class BankAccount
{
    public decimal Balance { get; private set; }

    public void Deposit(decimal amount)
    {
        Balance += amount;
    }
}
```

Now external code can read:

```csharp
account.Balance
```

but cannot directly assign:

```csharp
account.Balance = 5000;
```

State changes happen through behavior:

```csharp
account.Deposit(5000);
```

This gives the object more control.

---

## Access Control Supports Invariants

Suppose:

```text
Balance must never become negative.
```

If the setter is public:

```csharp
account.Balance = -5000;
```

can bypass the rule.

If state is restricted and modified through methods, the object can validate transitions.

```text
External code
     │
     ▼
Withdraw()
     │
     ▼
Validate rules
     │
     ▼
Update balance
```

This prepares us directly for Encapsulation.

---

# 1️⃣3️⃣ Access Modifiers Do Not Equal Encapsulation

This distinction is critical.

A beginner may think:

```text
private field
=
Encapsulation
```

Not automatically.

Example:

```csharp
public class BankAccount
{
    private decimal balance;

    public void SetBalance(decimal value)
    {
        balance = value;
    }

    public decimal GetBalance()
    {
        return balance;
    }
}
```

The field is private.

But callers can still do:

```csharp
account.SetBalance(-100000);
```

The object's state remains uncontrolled.

So:

```text
Data hiding
≠
Full encapsulation
```

Access modifiers are tools.

Encapsulation is the broader design goal of:

```text
Protecting state
+
Controlling transitions
+
Preserving invariants
+
Exposing meaningful behavior
```

> [!IMPORTANT]
> `private` helps hide implementation.  
> Encapsulation requires correct behavioral boundaries as well.

---

# 1️⃣4️⃣ Common Design Mistakes

## ❌ Mistake 1 — Making Everything Public

```csharp
public string Name;
public decimal Balance;
public string Status;
```

This destroys meaningful boundaries.

---

## ❌ Mistake 2 — Making Everything Private Without a Usable API

The opposite extreme is also bad.

```csharp
public class BankAccount
{
    private decimal balance;
    private void Deposit(decimal amount) { }
    private void Withdraw(decimal amount) { }
}
```

If legitimate callers cannot use the object, the design is not useful.

The goal is not maximum restriction.

The goal is:

```text
Minimum necessary exposure
```

---

## ❌ Mistake 3 — Using `protected` Too Freely

`protected` exposes implementation details to subclasses.

That can tightly couple inheritance hierarchies.

Prefer:

```text
private
```

unless subclass access is genuinely required.

---

## ❌ Mistake 4 — Public Helper Methods

Example:

```csharp
public bool ValidateInternalCalculation()
{
}
```

If callers never need this directly, it may belong as a private implementation detail.

---

## ❌ Mistake 5 — Public Setter on Invariant-Sensitive State

```csharp
public string Status { get; set; }
```

allows:

```csharp
order.Status = "Delivered";
```

even when the order was never paid.

Meaningful state transitions may be better expressed through behavior.

---

## ❌ Mistake 6 — Thinking `internal` Means Secure

`internal` is an accessibility boundary within .NET assemblies.

It is not a security mechanism.

Do not use access modifiers as a substitute for authorization or security controls.

---

## ❌ Mistake 7 — Confusing Accessibility with Ownership

Just because code *can* access something does not mean it *should own responsibility* for changing it.

Accessibility and responsibility are related, but they are not the same concept.

---

# 1️⃣5️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> `public` means accessible and `private` means hidden.

## 👨‍💻 Intermediate Thinking

> Access modifiers help protect data and control visibility.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
What is the smallest API callers actually need?

Which details should remain implementation-specific?

What future change becomes harder if I expose this?

Does this public member leak internal representation?

Who genuinely needs write access?

Does this setter allow invalid transitions?

Am I exposing this because of a requirement or convenience?

Would private be enough?

Does protected create unnecessary subclass coupling?
```

This is the difference between knowing syntax and designing boundaries.

---

# 🎤 Interview Perspective

A common question:

> **What is the difference between `public`, `private`, `protected`, and `internal` in C#?**

A strong answer:

> `public` allows general access, `private` limits access to the containing type, `protected` allows access from the containing type and derived types, and `internal` limits access to the same assembly.

A stronger follow-up:

> **Why shouldn't everything be public?**

Because every public member expands the class's external contract, increases coupling, exposes implementation details, and may allow callers to bypass rules.

Another important question:

> **Does making a field private mean the class is encapsulated?**

No.

Private accessibility provides data hiding, but true encapsulation also requires controlling valid state transitions and protecting invariants through a meaningful public API.

---

# 🧩 Mental Models

## Access Boundary

```text
External Code
     │
     ▼
┌────────────────────┐
│    Public API      │
├────────────────────┤
│ Private State      │
│ Private Helpers    │
│ Internal Details   │
└────────────────────┘
```

---

## Principle of Minimum Exposure

```text
Start private
     │
     ▼
Expose only what is required
     │
     ▼
Keep API small and intentional
```

---

## Access Control + Behavior

```text
External Caller
      │
      ▼
Public Behavior
      │
      ▼
Validation
      │
      ▼
Private / Restricted State
```

---

## Access Modifiers vs Encapsulation

```text
Access Modifiers
      │
      └── Control visibility

Encapsulation
      │
      ├── Protect state
      ├── Control behavior
      ├── Preserve invariants
      └── Hide implementation details
```

---

# 📝 Cheat Sheet

| Modifier | Main Meaning |
|---|---|
| **`public`** | Accessible broadly |
| **`private`** | Accessible only inside the containing type |
| **`protected`** | Accessible inside the type and derived types |
| **`internal`** | Accessible within the same assembly |
| **`protected internal`** | Same assembly OR derived type |
| **`private protected`** | Derived type AND same assembly |

### Design Terms

| Concept | Meaning |
|---|---|
| **Public API** | Members intentionally exposed to callers |
| **Implementation Detail** | Internal logic callers should not depend on |
| **API Surface** | Total set of externally accessible members |
| **Object Boundary** | Separation between external contract and internal implementation |
| **Minimum Exposure** | Expose only what is required |
| **Data Hiding** | Preventing direct access to internal representation |

---

# ✅ Key Takeaways

1. Access modifiers control where types and members can be accessed.
2. `public` exposes a member as part of an external contract.
3. `private` hides members inside the containing type.
4. `protected` exposes members to derived types and therefore increases inheritance coupling.
5. `internal` limits access to the same assembly.
6. A public API should be small and intentional.
7. Implementation details should usually remain hidden.
8. Excessive public access increases coupling and makes refactoring harder.
9. Restricted setters can help protect state.
10. Accessibility should reflect real responsibilities, not convenience.
11. `private` alone does not create full encapsulation.
12. Access modifiers are tools that help establish object boundaries.
13. Good encapsulation requires controlled state transitions and invariant protection.

---

# ➡️ Next Lesson

## 💥 Lesson 07 — The Problem of Uncontrolled State

Next, we will study:

- Public mutable state
- Unrestricted setters
- Invalid object states
- Broken invariants
- Why data exposure causes design problems
- State transition control
- Why getters/setters alone are insufficient
- Tell, Don't Ask as an introduction
- Why objects should protect their own rules
- The exact problem Encapsulation is designed to solve

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 06 of 08 ✅
</p>
