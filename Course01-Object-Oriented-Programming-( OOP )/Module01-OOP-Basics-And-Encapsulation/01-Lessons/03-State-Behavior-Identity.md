# 🧩 Lesson 03 — State, Behavior, and Identity

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ Why These Three Concepts Matter](#1️⃣-why-these-three-concepts-matter)
- [2️⃣ Object State](#2️⃣-object-state)
- [3️⃣ State Changes Over Time](#3️⃣-state-changes-over-time)
- [4️⃣ Object Behavior](#4️⃣-object-behavior)
- [5️⃣ Behavior Should Work with State](#5️⃣-behavior-should-work-with-state)
- [6️⃣ State vs Behavior](#6️⃣-state-vs-behavior)
- [7️⃣ Object Identity](#7️⃣-object-identity)
- [8️⃣ Same State Does Not Mean Same Object](#8️⃣-same-state-does-not-mean-same-object)
- [9️⃣ Identity vs Equality](#9️⃣-identity-vs-equality)
- [🔟 Independent Object State](#-independent-object-state)
- [1️⃣1️⃣ Shared References and Shared State Changes](#1️⃣1️⃣-shared-references-and-shared-state-changes)
- [1️⃣2️⃣ Object State Transitions](#1️⃣2️⃣-object-state-transitions)
- [1️⃣3️⃣ Valid and Invalid State](#1️⃣3️⃣-valid-and-invalid-state)
- [1️⃣4️⃣ Responsibility and State Ownership](#1️⃣4️⃣-responsibility-and-state-ownership)
- [1️⃣5️⃣ Object Interaction](#1️⃣5️⃣-object-interaction)
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

- What **state** means in an object.
- What **behavior** means in an object.
- What **identity** means in an object.
- How object state changes over time.
- Why behavior should often control state changes.
- Why two objects can contain the same data but still be different objects.
- Why multiple references to the same object observe the same state changes.
- What a **state transition** is.
- Why valid and invalid object states matter.
- How state ownership connects to object responsibility.
- How these concepts prepare us for Encapsulation.

---

# 1️⃣ Why These Three Concepts Matter

In the previous lesson, we learned that a class defines the structure and behavior of objects.

Now we need to understand the three characteristics that make an object meaningful:

```text
Object
│
├── State
├── Behavior
└── Identity
```

These three ideas are fundamental because they answer three different questions:

```text
State
→ What does this object currently know?

Behavior
→ What can this object do?

Identity
→ Which specific object is this?
```

A professional object model depends on all three.

---

# 2️⃣ Object State

An object's **state** is the collection of data that describes its current condition.

Consider:

```csharp
public class Car
{
    public string Brand;
    public int Speed;
    public bool IsRunning;
}
```

One object might have:

```text
Brand     = BMW
Speed     = 100
IsRunning = true
```

Another object might have:

```text
Brand     = Toyota
Speed     = 0
IsRunning = false
```

Both are created from the same class, but each one has its own state.

---

## State Depends on the Object

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car1.Speed = 100;

car2.Brand = "Toyota";
car2.Speed = 40;
```

Conceptually:

```text
car1
├── Brand = BMW
└── Speed = 100

car2
├── Brand = Toyota
└── Speed = 40
```

The class defines what state is possible.

Each object contains the actual values.

---

## 🧠 Useful Question

When analyzing a domain object, ask:

> **What information does this object need to remember?**

That usually reveals its state.

Examples:

| Object | Possible State |
|---|---|
| `BankAccount` | Balance, AccountNumber, Status |
| `Order` | Items, Status, CreatedAt |
| `Product` | Name, Price, Quantity |
| `Employee` | Name, Salary, Department |
| `Car` | Brand, Speed, IsRunning |

---

# 3️⃣ State Changes Over Time

Object state is often not permanent.

It changes as the object performs behavior.

Example:

```csharp
Car car = new Car();

car.Speed = 0;
```

Later:

```csharp
car.Speed = 20;
```

Then:

```csharp
car.Speed = 60;
```

The same object moved through different states:

```text
Speed = 0
   ↓
Speed = 20
   ↓
Speed = 60
```

This idea is extremely important.

An object is not only a collection of values.

It can have a **lifecycle** where its state changes over time.

---

## Example — Order

An order might move through:

```text
Created
   ↓
Confirmed
   ↓
Paid
   ↓
Shipped
   ↓
Delivered
```

The object remains the same order.

Its state changes.

This is called a:

> **State transition**

---

# 4️⃣ Object Behavior

**Behavior** describes what an object can do.

Example:

```csharp
public class Car
{
    public int Speed;

    public void Accelerate()
    {
        Speed += 10;
    }

    public void Brake()
    {
        Speed -= 10;
    }
}
```

The methods:

```text
Accelerate()
Brake()
```

represent behavior.

Behavior often:

- Reads state
- Changes state
- Validates rules
- Coordinates with other objects
- Produces a result

---

## Example — Bank Account

```csharp
public class BankAccount
{
    public decimal Balance;

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

Here:

```text
Balance
```

is state.

And:

```text
Deposit()
Withdraw()
```

are behaviors.

---

# 5️⃣ Behavior Should Work with State

One of the most important ideas in OOP is that behavior often exists to manage object state.

Consider this:

```csharp
account.Balance -= 500;
```

External code directly changes state.

Compare that with:

```csharp
account.Withdraw(500);
```

The second version expresses behavior.

That behavior can eventually enforce rules such as:

```text
Amount must be positive.

Balance must remain valid.

Withdrawal may depend on account status.
```

This is why behavior is more than just "methods inside a class."

Behavior can become the mechanism through which an object protects its own state.

> [!IMPORTANT]
> This idea leads directly to **Encapsulation**.

---

# 6️⃣ State vs Behavior

The distinction should be clear.

| State | Behavior |
|---|---|
| What the object knows | What the object does |
| Data | Operations |
| Can change over time | Can read/change state |
| Example: `Balance` | Example: `Withdraw()` |
| Example: `Speed` | Example: `Accelerate()` |
| Example: `Status` | Example: `Cancel()` |

Example:

```csharp
public class Order
{
    public string Status;
    public decimal Total;

    public void Cancel()
    {
        Status = "Cancelled";
    }
}
```

Here:

```text
Status
Total
```

are state.

And:

```text
Cancel()
```

is behavior.

---

# 7️⃣ Object Identity

Now we reach the third major concept:

> **Identity**

Identity answers:

> Which specific object is this?

Consider:

```csharp
Car car1 = new Car();
Car car2 = new Car();
```

Even if both objects contain exactly the same state:

```csharp
car1.Brand = "BMW";
car2.Brand = "BMW";

car1.Speed = 100;
car2.Speed = 100;
```

they are still different objects.

Conceptually:

```text
car1 ───► Car Object #1

car2 ───► Car Object #2
```

They may look identical by data.

But they have different identity.

---

# 8️⃣ Same State Does Not Mean Same Object

Consider two bank accounts:

```text
Account A
Balance = 1000

Account B
Balance = 1000
```

Their current balance is the same.

But they are not the same account.

Why?

Because identity is separate from state.

This distinction is especially important for domain objects such as:

```text
Customer
Order
BankAccount
Invoice
Employee
Vehicle
```

Two customers may have the same name.

Two orders may have the same total.

Two cars may have the same brand and speed.

But they are still separate objects.

---

## Example

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car2.Brand = "BMW";
```

Conceptually:

```text
Object #1
Brand = BMW

Object #2
Brand = BMW
```

Same state value.

Different identity.

---

# 9️⃣ Identity vs Equality

These two ideas are related but not identical.

### Identity

Asks:

> Are these references pointing to the same object?

### Equality

Usually asks:

> Should these two values or objects be considered equivalent according to some rule?

At this stage, focus on identity.

Consider:

```csharp
Car car1 = new Car();
Car car2 = car1;
```

Now both references point to the same object.

Conceptually:

```text
car1 ───┐
        ▼
      Object #1
        ▲
car2 ───┘
```

But:

```csharp
Car car1 = new Car();
Car car2 = new Car();
```

creates two distinct objects.

We will study equality more deeply later in the OOP course.

---

# 🔟 Independent Object State

When two objects are distinct, their state can change independently.

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Speed = 100;
car2.Speed = 40;
```

Now:

```csharp
car1.Speed = 150;
```

does not affect:

```csharp
car2.Speed
```

Conceptually:

```text
car1 ─────► Object #1
            Speed = 150

car2 ─────► Object #2
            Speed = 40
```

This independence is one of the reasons object identity matters.

---

# 1️⃣1️⃣ Shared References and Shared State Changes

Now compare:

```csharp
Car car1 = new Car();

car1.Speed = 100;

Car car2 = car1;
```

Both variables point to the same object.

If we write:

```csharp
car2.Speed = 200;
```

then:

```csharp
Console.WriteLine(car1.Speed);
```

prints:

```text
200
```

Why?

Because there is only one object.

```text
car1 ───┐
        ▼
      Car Object
      Speed = 200
        ▲
car2 ───┘
```

The state belongs to the object.

The variables are only references to that object.

---

# 1️⃣2️⃣ Object State Transitions

A **state transition** occurs when an object's state moves from one valid condition to another.

Example:

```text
Order.Status

Created
   ↓
Paid
   ↓
Shipped
```

Instead of external code doing:

```csharp
order.Status = "Paid";
```

a more meaningful API may eventually look like:

```csharp
order.Pay();
```

Then the object itself controls the transition.

This matters because not every transition should necessarily be legal.

Example:

```text
Created → Paid
```

may be valid.

But:

```text
Delivered → Created
```

may be invalid.

---

## Another Example — Car

```text
Stopped
  ↓ Start()
Running
  ↓ Stop()
Stopped
```

Behavior causes state transitions.

---

# 1️⃣3️⃣ Valid and Invalid State

Not every technically possible state should be allowed.

Example:

```csharp
public class BankAccount
{
    public decimal Balance;
}
```

Technically:

```csharp
account.Balance = -100000;
```

is allowed by the class.

But the domain may reject that state.

So we need to distinguish:

```text
Technically possible state
```

from:

```text
Valid domain state
```

This is a key design issue.

---

## Example

For a product:

```text
Quantity = -50
```

may be technically assignable.

But it may violate a business rule.

For an order:

```text
Status = "Delivered"
```

before payment may be impossible according to the domain.

For a car:

```text
Speed = -300
```

may be meaningless.

Good object design should eventually help prevent invalid states.

---

# 1️⃣4️⃣ Responsibility and State Ownership

A powerful design question is:

> **Who owns this state?**

If an object owns state, it is often a strong candidate to own behavior that works with that state.

Example:

```text
Order
├── Items
└── CalculateTotal()
```

Why might `Order` calculate its total?

Because it owns the items required for the calculation.

This idea can be summarized as:

```text
Information ownership
        ↓
Responsibility candidate
```

This is not an absolute rule.

But it is a strong design heuristic.

---

## Example — Bank Account

If `BankAccount` owns:

```text
Balance
```

then behaviors such as:

```text
Deposit()
Withdraw()
```

naturally relate to that state.

This is more coherent than scattering the logic across unrelated classes.

---

# 1️⃣5️⃣ Object Interaction

Objects rarely work in isolation.

Suppose we have:

```text
Customer
Order
Product
```

A customer may create an order containing products.

Conceptually:

```text
Customer
   │
   ▼
Order
   │
   ▼
Product
```

Each object has its own:

```text
State
Behavior
Identity
```

But the use case is completed through collaboration.

This is important because OOP is not:

```text
One object does everything.
```

It is often:

```text
Multiple objects
+
Clear responsibilities
+
Meaningful collaboration
```

---

# 1️⃣6️⃣ Common Design Mistakes

## ❌ Mistake 1 — Treating Objects as Data Bags

Example:

```csharp
public class BankAccount
{
    public decimal Balance;
    public string Status;
}
```

and all behavior exists outside the class.

The object becomes only a container for data.

Later, we will learn why this can weaken encapsulation and responsibility ownership.

---

## ❌ Mistake 2 — Putting Every Behavior Inside One Object

The opposite mistake is also possible.

Example:

```csharp
public class Customer
{
    public void CreateOrder() { }
    public void CalculateTax() { }
    public void SendEmail() { }
    public void ProcessPayment() { }
    public void GenerateInvoice() { }
}
```

This does not mean the design is good simply because behavior exists inside a class.

Responsibilities still need to be assigned carefully.

---

## ❌ Mistake 3 — Confusing State with Derived Information

Suppose an order already owns its items and quantities.

Its total might be calculated from those items.

Storing both:

```text
Items
Total
```

can sometimes create duplicated state if `Total` can become inconsistent with the items.

Example:

```text
Items total = 1000

Stored Total = 700
```

Now which value is correct?

This introduces the idea that not every value needs to be stored as state.

Some values may be derived.

We will explore this idea further later.

---

## ❌ Mistake 4 — Exposing State Without Control

```csharp
public decimal Balance;
```

means any external code may change balance directly.

This removes the object's ability to control its own transitions.

This is one of the main problems Encapsulation will solve.

---

## ❌ Mistake 5 — Assuming Same Data Means Same Identity

Two objects can have exactly the same state and still be separate objects.

Identity and state are different concepts.

---

## ❌ Mistake 6 — Assuming Every Method Is Good Behavior

This:

```csharp
public void DoEverything()
{
}
```

is technically a method.

But meaningful behavior should represent a clear responsibility.

---

# 1️⃣7️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> An object has variables and methods.

## 👨‍💻 Intermediate Thinking

> State represents data, behavior changes state, and each object has identity.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
What state genuinely belongs to this object?

Which values should be stored?

Which values should be derived?

Which behaviors should be allowed to modify state?

Which transitions are valid?

Which transitions are invalid?

Who owns the rules protecting this state?

Should another object know about this state?

Does this object expose too much?
```

These questions are the beginning of professional object design.

---

# 🎤 Interview Perspective

A common interview question is:

> **What are the main characteristics of an object?**

A good answer usually mentions:

```text
State
Behavior
Identity
```

A stronger explanation is:

> State represents the object's current data, behavior represents the operations it can perform, and identity distinguishes one object from another even when their state is similar.

Another common question:

> **Can two objects have the same state but different identities?**

Yes.

Example:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car2.Brand = "BMW";
```

They may contain equal-looking state, but they are distinct instances.

Another important question:

> **Why is behavior important instead of directly modifying state?**

Because behavior can eventually enforce rules and valid state transitions rather than allowing arbitrary external changes.

---

# 🧩 Mental Models

## Object Model

```text
Object
│
├── State
│   └── What it knows
│
├── Behavior
│   └── What it does
│
└── Identity
    └── Which specific object it is
```

---

## State Transition

```text
Current State
     │
     │ Behavior
     ▼
New State
```

Example:

```text
Balance = 1000
     │
     │ Withdraw(300)
     ▼
Balance = 700
```

---

## Identity vs State

```text
Object #1
Brand = BMW
Speed = 100

Object #2
Brand = BMW
Speed = 100
```

Same visible state.

Different identity.

---

## Shared Reference

```text
car1 ───┐
        ▼
      Object
      Speed = 100
        ▲
car2 ───┘
```

Change through either reference:

```text
        ↓
Same object's state changes
```

---

## Responsibility Heuristic

```text
Who owns the information?
        ↓
Who may be responsible for the behavior?
```

---

# 📝 Cheat Sheet

| Concept | Meaning |
|---|---|
| **State** | The object's current data |
| **Behavior** | Operations the object can perform |
| **Identity** | What distinguishes one object from another |
| **State Transition** | A change from one object state to another |
| **Independent State** | Separate objects can hold different values |
| **Shared Reference** | Multiple variables reference the same object |
| **Valid State** | State allowed by domain rules |
| **Invalid State** | State that violates object/domain rules |
| **State Ownership** | Which object is responsible for holding particular data |
| **Derived Value** | A value calculated from other state rather than necessarily stored |
| **Responsibility** | Something the object should know or do |

---

# ✅ Key Takeaways

1. Every meaningful object can be understood through **state, behavior, and identity**.
2. State represents what an object currently knows.
3. Behavior represents what an object can do.
4. Behavior often causes state transitions.
5. Separate objects can hold independent state.
6. Multiple references can point to the same object and observe the same state changes.
7. Two objects may have identical state while still having different identities.
8. Not every technically possible state is a valid domain state.
9. Objects should eventually control important state transitions.
10. State ownership is closely related to responsibility assignment.
11. Not every value needs to be stored; some can be derived.
12. These concepts prepare us directly for fields, properties, methods, constructors, and Encapsulation.

---

# ➡️ Next Lesson

## ⚙️ Lesson 04 — Fields, Properties, and Methods

Next, we will study:

- Fields
- Properties
- Methods
- Instance members
- Reading object state
- Updating object state
- Fields vs Properties
- Auto-properties
- Getters and setters
- Why properties are not automatically encapsulation
- Method responsibilities
- How class members represent state and behavior

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 03 of 08 ✅
</p>
