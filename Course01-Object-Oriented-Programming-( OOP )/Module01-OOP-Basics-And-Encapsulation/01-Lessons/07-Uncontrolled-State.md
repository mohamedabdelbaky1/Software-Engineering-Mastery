# 💥 Lesson 07 — The Problem of Uncontrolled State

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ Why Uncontrolled State Is a Design Problem](#1️⃣-why-uncontrolled-state-is-a-design-problem)
- [2️⃣ What Is Mutable State?](#2️⃣-what-is-mutable-state)
- [3️⃣ Public Fields and Unrestricted Access](#3️⃣-public-fields-and-unrestricted-access)
- [4️⃣ Public Setters Can Cause the Same Problem](#4️⃣-public-setters-can-cause-the-same-problem)
- [5️⃣ Valid State vs Invalid State](#5️⃣-valid-state-vs-invalid-state)
- [6️⃣ Broken Invariants](#6️⃣-broken-invariants)
- [7️⃣ Why Validation Outside the Object Is Fragile](#7️⃣-why-validation-outside-the-object-is-fragile)
- [8️⃣ State Transitions Should Be Controlled](#8️⃣-state-transitions-should-be-controlled)
- [9️⃣ Behavior-Oriented APIs](#9️⃣-behavior-oriented-apis)
- [🔟 Tell, Don’t Ask — Introduction](#-tell-dont-ask--introduction)
- [1️⃣1️⃣ Data Hiding Is Not Enough](#1️⃣1️⃣-data-hiding-is-not-enough)
- [1️⃣2️⃣ The Anemic Object Problem](#1️⃣2️⃣-the-anemic-object-problem)
- [1️⃣3️⃣ Protecting Collections](#1️⃣3️⃣-protecting-collections)
- [1️⃣4️⃣ Hidden Coupling Through Shared Mutable State](#1️⃣4️⃣-hidden-coupling-through-shared-mutable-state)
- [1️⃣5️⃣ Requirement Changes Expose Weak Designs](#1️⃣5️⃣-requirement-changes-expose-weak-designs)
- [1️⃣6️⃣ Common Design Mistakes](#1️⃣6️⃣-common-design-mistakes)
- [1️⃣7️⃣ Junior vs Senior Thinking](#1️⃣7️⃣-junior-vs-senior-thinking)
- [🎤 Interview Perspective](#-interview-perspective)
- [🧩 Mental Models](#-mental-models)
- [📝 Cheat Sheet](#-cheat-sheet)
- [✅ Key Takeaways](#-key-takeaways)
- [➡️ Next Lesson](#️-next-lesson)

---

# 🎯 Learning Goals

By the end of this lesson, you should understand:

- What **mutable state** means.
- Why unrestricted access to object state is dangerous.
- Why public fields and unrestricted setters can break object rules.
- The difference between a **valid state** and an **invalid state**.
- What happens when object invariants are not protected.
- Why validation scattered outside the object is fragile.
- Why important state transitions should happen through meaningful behavior.
- Why `private` fields alone do not guarantee good encapsulation.
- How shared mutable state increases coupling.
- Why exposing collections directly can break invariants.
- How weak object boundaries become painful when requirements change.
- The exact design problem that **Encapsulation** is meant to solve.

---

# 1️⃣ Why Uncontrolled State Is a Design Problem

Consider this class:

```csharp
public class BankAccount
{
    public decimal Balance;
}
```

Usage:

```csharp
BankAccount account = new BankAccount();

account.Balance = 1000;
account.Balance = -5000;
account.Balance = 999999999;
```

C# allows all of these assignments.

But the domain may not.

Suppose the business rule says:

> A normal account balance cannot become negative.

Then this:

```csharp
account.Balance = -5000;
```

puts the object into an invalid state.

The deeper problem is:

> **The object does not control its own state.**

---

# 2️⃣ What Is Mutable State?

**Mutable state** is state that can change after an object is created.

Example:

```csharp
public class Car
{
    public int Speed { get; set; }
}
```

This value can change:

```csharp
car.Speed = 0;
car.Speed = 50;
car.Speed = 100;
```

Mutable state is not inherently bad.

Most useful systems contain mutable state.

The problem appears when that state can be changed:

```text
From anywhere
At any time
To any value
Without rules
```

That is **uncontrolled mutable state**.

---

# 3️⃣ Public Fields and Unrestricted Access

Consider:

```csharp
public class Product
{
    public decimal Price;
    public int Quantity;
}
```

External code can do:

```csharp
product.Price = -100;
product.Quantity = -50;
```

The class cannot prevent this.

It cannot enforce rules such as:

```text
Price >= 0
Quantity >= 0
```

The object is effectively saying:

> Anyone can change my state however they want.

That is a weak object boundary.

---

## Why This Is Dangerous

If many parts of the system can directly modify state:

```text
Controller
Service
UI
Database code
Background job
Test
Other objects
```

then finding the source of a bug becomes difficult.

You no longer have one controlled path for state changes.

---

# 4️⃣ Public Setters Can Cause the Same Problem

A developer may replace public fields with properties:

```csharp
public class BankAccount
{
    public decimal Balance { get; set; }
}
```

This looks more object-oriented.

But external code can still do:

```csharp
account.Balance = -100000;
```

So the real problem remains.

This means:

```text
Public Field
        ↓
Uncontrolled mutation

Public Setter
        ↓
Can still allow uncontrolled mutation
```

> [!IMPORTANT]
> Replacing a field with `{ get; set; }` does not automatically solve the design problem.

---

# 5️⃣ Valid State vs Invalid State

A **valid state** satisfies the rules of the object.

An **invalid state** violates one or more of those rules.

Example:

```text
BankAccount
Balance = 1000
```

may be valid.

But:

```text
BankAccount
Balance = -5000
```

may be invalid.

Another example:

```text
Order
Status = Shipped
PaymentStatus = Unpaid
```

may violate the business rules.

The key question is:

> **Can the object prevent itself from entering an invalid state?**

If the answer is no, the design is weak.

---

# 6️⃣ Broken Invariants

Recall:

> An invariant is a rule that must remain true for an object to remain valid.

Example:

```text
BankAccount invariant:

Balance >= 0
```

If external code can directly modify `Balance`, the invariant can be broken.

```csharp
account.Balance = -5000;
```

The object cannot defend itself.

---

## Example — Product

Suppose:

```text
Product invariant:

Price >= 0
Quantity >= 0
```

But the class allows:

```csharp
product.Price = -10;
product.Quantity = -20;
```

Then the class representation does not protect the domain model.

---

## Stronger Design Goal

We want:

```text
Invalid request
      ↓
Object checks rule
      ↓
Reject invalid transition
```

instead of:

```text
External code
      ↓
Direct mutation
      ↓
Invariant broken
```

---

# 7️⃣ Why Validation Outside the Object Is Fragile

A common weak approach is:

```csharp
if (amount > 0 && account.Balance >= amount)
{
    account.Balance -= amount;
}
```

At first, this looks reasonable.

The problem is that the rule exists outside the object.

Now another part of the application may forget the validation:

```csharp
account.Balance -= amount;
```

Another developer may implement slightly different rules.

You end up with:

```text
Controller A → validation version 1
Service B    → validation version 2
Job C        → no validation
Test D       → direct assignment
```

The business rule becomes scattered.

---

## Better Responsibility

If `BankAccount` owns `Balance`, then the account is a natural place to protect balance-related rules.

Example direction:

```csharp
account.Withdraw(amount);
```

Now every withdrawal can pass through the same rule enforcement.

This centralizes the invariant.

---

# 8️⃣ State Transitions Should Be Controlled

Suppose an order can move through:

```text
Created
   ↓
Paid
   ↓
Shipped
   ↓
Delivered
```

Weak design:

```csharp
order.Status = "Delivered";
```

Nothing prevents:

```text
Created → Delivered
```

even if payment never happened.

---

## Better Direction

Instead of arbitrary assignments:

```csharp
order.Pay();
order.Ship();
order.Deliver();
```

Each behavior can check whether the transition is valid.

Conceptually:

```text
Current State
     │
     ▼
Requested Behavior
     │
     ▼
Validate Transition
     │
     ├── Valid   → Change State
     └── Invalid → Reject
```

This is much stronger than exposing the state directly.

---

# 9️⃣ Behavior-Oriented APIs

Compare these two designs.

---

## Data-Oriented API

```csharp
account.Balance = account.Balance - 500;
```

The caller:

- Reads internal state
- Calculates the new value
- Applies the mutation
- Owns the business decision

---

## Behavior-Oriented API

```csharp
account.Withdraw(500);
```

The object:

- Receives the intent
- Validates the operation
- Applies the correct state transition
- Preserves its rules

This communicates the domain much better.

---

## Another Example

Instead of:

```csharp
order.Status = "Cancelled";
```

prefer:

```csharp
order.Cancel();
```

when cancellation has business meaning.

Instead of:

```csharp
cart.Total = 0;
cart.Items.Clear();
```

prefer:

```csharp
cart.Clear();
```

if clearing the cart is a valid behavior.

---

# 🔟 Tell, Don’t Ask — Introduction

A useful object-oriented idea is:

> **Tell an object what to do instead of asking for its data and doing the work elsewhere.**

Consider:

```csharp
if (account.Balance >= amount)
{
    account.Balance -= amount;
}
```

External code asks:

```text
What is your balance?
```

Then performs the object's business logic itself.

A more behavior-oriented style is:

```csharp
account.Withdraw(amount);
```

Now we tell the object what behavior we want.

---

## Important Nuance

`Tell, Don't Ask` is not a law.

Reading state is not automatically bad.

For example:

```csharp
Console.WriteLine(account.Balance);
```

may be perfectly reasonable.

The principle is useful when callers are:

```text
Reading object state
        ↓
Making decisions that belong to the object
        ↓
Mutating the object externally
```

That is often a sign of misplaced responsibility.

---

# 1️⃣1️⃣ Data Hiding Is Not Enough

Consider:

```csharp
public class BankAccount
{
    private decimal balance;

    public decimal GetBalance()
    {
        return balance;
    }

    public void SetBalance(decimal value)
    {
        balance = value;
    }
}
```

The field is private.

But external code can still do:

```csharp
account.SetBalance(-5000);
```

So the class technically hides the field, but does not protect the rule.

This is why:

```text
Data Hiding
≠
Full Encapsulation
```

A better API exposes meaningful operations:

```text
Deposit
Withdraw
Transfer
```

instead of generic mutation:

```text
SetBalance
```

---

# 1️⃣2️⃣ The Anemic Object Problem

An object can become little more than a bag of data.

Example:

```csharp
public class Order
{
    public List<OrderItem> Items { get; set; }
    public string Status { get; set; }
    public decimal Total { get; set; }
}
```

Then all behavior lives elsewhere:

```csharp
public class OrderService
{
    public void Cancel(Order order)
    {
        order.Status = "Cancelled";
    }

    public decimal CalculateTotal(Order order)
    {
        return order.Items.Sum(x => x.Price);
    }
}
```

The `Order` itself knows almost nothing about how to protect its own state.

This style is often called an:

> **Anemic Domain Model**

---

## Important Nuance

Anemic models are not always wrong.

For simple CRUD applications, data-centric models may be sufficient.

The design problem appears when the domain contains significant business rules but the entities remain passive data containers.

The correct question is:

> **Does this object have meaningful rules and responsibilities that belong inside it?**

---

# 1️⃣3️⃣ Protecting Collections

Collections are a common source of uncontrolled state.

Weak example:

```csharp
public class ShoppingCart
{
    public List<string> Items { get; set; } = new();
}
```

External code can do:

```csharp
cart.Items.Add("Laptop");
cart.Items.Clear();
cart.Items = null;
```

The class has almost no control.

---

## Stronger Direction

```csharp
public class ShoppingCart
{
    private readonly List<string> items = new();

    public IReadOnlyList<string> Items => items;

    public void AddItem(string item)
    {
        items.Add(item);
    }

    public void RemoveItem(string item)
    {
        items.Remove(item);
    }
}
```

Now callers can inspect items without freely replacing the collection.

---

## Why This Matters

The object may later need rules such as:

```text
Maximum 20 items
No duplicate product
Quantity must be positive
Certain products cannot coexist
```

If callers mutate the collection directly, they can bypass those rules.

---

# 1️⃣4️⃣ Hidden Coupling Through Shared Mutable State

Suppose two variables reference the same object:

```csharp
BankAccount account1 = new BankAccount();
BankAccount account2 = account1;
```

Both references point to the same state.

If `account2` changes it:

```csharp
account2.Balance = 0;
```

`account1` sees the same change.

Conceptually:

```text
account1 ───┐
            ▼
        Same Object
            ▲
account2 ───┘
```

When state is widely mutable, shared references can create surprising side effects.

---

## Design Consequence

The more places that can mutate an object:

```text
The harder it becomes to know:
- Who changed it?
- When did it change?
- Was the change valid?
- Which rule was applied?
```

Controlled mutation reduces this uncertainty.

---

# 1️⃣5️⃣ Requirement Changes Expose Weak Designs

Suppose the original requirement is:

```text
Withdrawal is allowed if balance is sufficient.
```

External code everywhere does:

```csharp
if (account.Balance >= amount)
{
    account.Balance -= amount;
}
```

Then the requirement changes:

```text
Premium accounts may overdraft up to 5000.
```

Now you must find every place that performs withdrawal logic.

Possible locations:

```text
API Controller
Desktop UI
Background Job
Mobile Service
Admin Tool
Tests
```

This creates **shotgun changes**.

---

## Better Design

If all withdrawals go through:

```csharp
account.Withdraw(amount);
```

then the rule is centralized.

Requirement change:

```text
Old Rule
   ↓
Modify one behavior boundary
   ↓
New Rule
```

This is one of the biggest practical benefits of controlling state changes.

---

# 1️⃣6️⃣ Common Design Mistakes

## ❌ Mistake 1 — Public Mutable Fields

```csharp
public decimal Balance;
```

Any caller can break the invariant.

---

## ❌ Mistake 2 — Public Setters Everywhere

```csharp
public decimal Balance { get; set; }
```

This may be syntactically cleaner but still logically uncontrolled.

---

## ❌ Mistake 3 — Generic Setter Methods

```csharp
SetBalance(...)
SetStatus(...)
SetTotal(...)
```

These often expose state manipulation without expressing domain intent.

---

## ❌ Mistake 4 — Validation Only in the UI

```text
UI validates
Domain object trusts everything
```

Another caller can bypass the UI.

Core domain rules should usually not depend only on presentation-layer validation.

---

## ❌ Mistake 5 — Duplicating Business Rules Everywhere

```text
Controller checks one rule
Service checks another
Job checks another
```

This makes requirements hard to change consistently.

---

## ❌ Mistake 6 — Exposing Mutable Collections

```csharp
public List<OrderItem> Items { get; set; }
```

Callers can bypass collection rules.

---

## ❌ Mistake 7 — Hiding Data but Exposing Unrestricted Mutation

```csharp
private decimal balance;

public void SetBalance(decimal value)
{
    balance = value;
}
```

This hides storage but does not protect invariants.

---

## ❌ Mistake 8 — Putting Every Rule Inside One Object

The solution to uncontrolled state is not:

> Put the entire application inside one class.

Responsibilities still need to remain focused.

---

## ❌ Mistake 9 — Over-Restricting Everything

Not every property must be private.

Not every object must be immutable.

Not every state change requires a separate method.

Control should be justified by domain rules and design needs.

---

# 1️⃣7️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> Public fields are bad, so I use properties.

## 👨‍💻 Intermediate Thinking

> I use `private set` to control updates.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
What state can become invalid?

Who should be allowed to change it?

Which transitions have business meaning?

Where should those rules live?

Can callers bypass those rules?

Am I exposing data because they need it, or because it is convenient?

Can the object guarantee its invariants?

What happens when this requirement changes?

How many places would need modification?

Is shared mutable state creating hidden coupling?
```

That is the real problem Encapsulation is designed to address.

---

# 🎤 Interview Perspective

A common interview question:

> **Why are public fields considered bad design for mutable domain state?**

A strong answer:

> Because they allow external code to modify internal state directly, which makes it difficult for the object to enforce invariants, control valid transitions, and evolve its implementation without affecting callers.

Another question:

> **Are properties with public setters enough for encapsulation?**

No.

```csharp
public decimal Balance { get; set; }
```

still allows unrestricted mutation.

Another important question:

> **Why should business rules often live close to the state they protect?**

Because centralizing the rule reduces duplication, prevents callers from bypassing it, and makes requirement changes easier to manage.

---

# 🧩 Mental Models

## Uncontrolled State

```text
Caller A ───┐
Caller B ───┼──► Object State
Caller C ───┤
Caller D ───┘

Anyone can mutate it.
```

---

## Controlled State

```text
External Code
     │
     ▼
Meaningful Behavior
     │
     ▼
Validation
     │
     ▼
State Transition
     │
     ▼
Invariant Preserved
```

---

## Weak Design

```text
Read state
   ↓
Decision outside object
   ↓
Direct mutation
```

---

## Stronger Direction

```text
Request behavior
   ↓
Object decides
   ↓
Object protects rule
   ↓
State changes safely
```

---

## Encapsulation Problem

```text
State
+
Rules
+
Behavior

should form a meaningful boundary.
```

---

# 📝 Cheat Sheet

| Concept | Meaning |
|---|---|
| **Mutable State** | State that can change after object creation |
| **Uncontrolled State** | State that can be changed without meaningful restrictions |
| **Valid State** | State satisfying object/domain rules |
| **Invalid State** | State violating one or more invariants |
| **Invariant** | Rule that must remain true for a valid object |
| **State Transition** | Change from one state to another |
| **Behavior-Oriented API** | API exposing meaningful operations instead of raw mutation |
| **Tell, Don't Ask** | Prefer requesting behavior over extracting data to manipulate externally |
| **Anemic Object** | Object containing mostly data while meaningful behavior lives elsewhere |
| **Shared Mutable State** | Mutable object state accessible through multiple references |
| **Data Hiding** | Hiding internal representation |
| **Encapsulation** | Protecting state, rules, and transitions behind meaningful boundaries |

---

# ✅ Key Takeaways

1. Mutable state is normal; **uncontrolled** mutable state is the real problem.
2. Public fields allow callers to bypass object rules.
3. Public setters can create the same problem.
4. Objects can enter invalid states when invariants are not protected.
5. Validation scattered outside the object is fragile.
6. Important state transitions should often happen through meaningful behavior.
7. `Withdraw()` communicates more domain intent than directly changing `Balance`.
8. `private` storage alone does not guarantee encapsulation.
9. Generic setter methods can still expose uncontrolled mutation.
10. Mutable collections also need protection when they carry business rules.
11. Shared mutable state increases hidden coupling.
12. Centralized behavior makes requirement changes easier.
13. Encapsulation is the solution to the broader problem of uncontrolled state and exposed implementation.

---

# ➡️ Next Lesson

## 🛡️ Lesson 08 — Encapsulation

Next, we will complete Module 01 by studying:

- What Encapsulation really means
- Encapsulation vs Data Hiding
- Protecting object invariants
- Controlling state transitions
- Private fields
- Properties and restricted setters
- Behavior-based APIs
- Constructor validation
- Encapsulating collections
- Avoiding invalid state
- Over-encapsulation
- Production-quality C# examples
- How senior engineers evaluate object boundaries

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 07 of 08 ✅
</p>
