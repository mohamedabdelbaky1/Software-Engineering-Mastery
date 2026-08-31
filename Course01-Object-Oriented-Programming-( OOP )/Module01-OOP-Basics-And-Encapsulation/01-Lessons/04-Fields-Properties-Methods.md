# ⚙️ Lesson 04 — Fields, Properties, and Methods

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ Why Class Members Matter](#1️⃣-why-class-members-matter)
- [2️⃣ What Is a Field?](#2️⃣-what-is-a-field)
- [3️⃣ What Is a Property?](#3️⃣-what-is-a-property)
- [4️⃣ What Is a Method?](#4️⃣-what-is-a-method)
- [5️⃣ Fields vs Properties vs Methods](#5️⃣-fields-vs-properties-vs-methods)
- [6️⃣ Instance Members](#6️⃣-instance-members)
- [7️⃣ Reading and Changing Object State](#7️⃣-reading-and-changing-object-state)
- [8️⃣ Auto-Implemented Properties](#8️⃣-auto-implemented-properties)
- [9️⃣ Getters and Setters](#9️⃣-getters-and-setters)
- [🔟 Read-Only and Restricted Properties](#-read-only-and-restricted-properties)
- [1️⃣1️⃣ Properties Are Not Automatically Encapsulation](#1️⃣1️⃣-properties-are-not-automatically-encapsulation)
- [1️⃣2️⃣ Methods as Behavior](#1️⃣2️⃣-methods-as-behavior)
- [1️⃣3️⃣ Methods That Read State](#1️⃣3️⃣-methods-that-read-state)
- [1️⃣4️⃣ Methods That Change State](#1️⃣4️⃣-methods-that-change-state)
- [1️⃣5️⃣ Derived Values](#1️⃣5️⃣-derived-values)
- [1️⃣6️⃣ Method Parameters and Return Values](#1️⃣6️⃣-method-parameters-and-return-values)
- [1️⃣7️⃣ Naming and Intent](#1️⃣7️⃣-naming-and-intent)
- [1️⃣8️⃣ Common Design Mistakes](#1️⃣8️⃣-common-design-mistakes)
- [1️⃣9️⃣ Junior vs Senior Thinking](#1️⃣9️⃣-junior-vs-senior-thinking)
- [🎤 Interview Perspective](#-interview-perspective)
- [🧩 Mental Models](#-mental-models)
- [📝 Cheat Sheet](#-cheat-sheet)
- [✅ Key Takeaways](#-key-takeaways)
- [➡️ Next Lesson](#️-next-lesson)

---

# 🎯 Learning Goals

By the end of this lesson, you should understand:

- What a **field** is in C#.
- What a **property** is in C#.
- What a **method** is in C#.
- How these members map to object **state** and **behavior**.
- Why properties are usually preferred over public fields.
- How `get` and `set` work.
- What `private set` means.
- How read-only properties improve control over object state.
- Why a property with a public setter does **not** automatically provide real encapsulation.
- How methods can read state, change state, validate rules, and express object intent.
- The difference between **stored state** and **derived values**.
- Why naming class members clearly is a design decision, not only a style preference.

---

# 1️⃣ Why Class Members Matter

In the previous lessons, we learned that an object can be understood through:

```text
Object
├── State
├── Behavior
└── Identity
```

Now we need to represent state and behavior in actual C# code.

The most common class members we use for this are:

```text
Fields
Properties
Methods
```

A simplified relationship looks like this:

```text
Object
│
├── State
│   ├── Fields
│   └── Properties
│
└── Behavior
    └── Methods
```

This is not a strict rule in every case, but it is a very useful starting point.

---

# 2️⃣ What Is a Field?

A **field** is a variable declared directly inside a class or struct.

Example:

```csharp
public class Car
{
    public string Brand;
    public int Speed;
}
```

Here:

```text
Brand
Speed
```

are fields.

They store data belonging to each object.

Example:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Brand = "BMW";
car2.Brand = "Toyota";
```

Each object has its own field values.

---

## Field as Object State

Consider:

```csharp
public class BankAccount
{
    public decimal Balance;
}
```

`Balance` represents part of the object's state.

Conceptually:

```text
BankAccount Object
└── Balance = 5000
```

So fields are one way to physically store state inside an object.

---

## ⚠️ Public Fields

This is legal C#:

```csharp
public class BankAccount
{
    public decimal Balance;
}
```

Usage:

```csharp
account.Balance = 1000;
account.Balance = -100000;
```

The problem is that external code has complete control over the field.

The object cannot decide:

```text
Who changes Balance?

When can it change?

Which values are allowed?

Which rules should be checked?
```

> [!WARNING]
> Public fields are usually a poor choice for mutable domain state because they expose the implementation directly.

This is one of the reasons properties exist.

---

# 3️⃣ What Is a Property?

A **property** provides controlled access to data through accessors such as:

```text
get
set
```

Example:

```csharp
public class Car
{
    public string Brand { get; set; }
}
```

Usage:

```csharp
Car car = new Car();

car.Brand = "BMW";

Console.WriteLine(car.Brand);
```

From the outside, a property looks similar to a field:

```csharp
car.Brand
```

But internally, a property is different.

It represents an abstraction around reading and/or writing a value.

---

## Basic Property Syntax

```csharp
public string Brand
{
    get;
    set;
}
```

Meaning:

```text
get
→ allows reading the property

set
→ allows assigning a value
```

Example:

```csharp
Console.WriteLine(car.Brand);
```

uses the getter.

This:

```csharp
car.Brand = "BMW";
```

uses the setter.

---

# 4️⃣ What Is a Method?

A **method** represents behavior.

Example:

```csharp
public class Car
{
    public int Speed { get; set; }

    public void Accelerate()
    {
        Speed += 10;
    }
}
```

Here:

```text
Speed
```

represents state.

And:

```text
Accelerate()
```

represents behavior.

Usage:

```csharp
car.Accelerate();
```

A method may:

- Read state
- Change state
- Validate rules
- Perform calculations
- Return results
- Collaborate with other objects

---

# 5️⃣ Fields vs Properties vs Methods

The distinction should be clear.

| Member | Main Purpose | Example |
|---|---|---|
| **Field** | Store data directly | `private decimal balance;` |
| **Property** | Expose controlled access to data | `public decimal Balance { get; private set; }` |
| **Method** | Represent behavior or operation | `Withdraw(amount)` |

A common professional design looks like this:

```csharp
public class BankAccount
{
    private decimal balance;

    public decimal Balance
    {
        get
        {
            return balance;
        }
    }

    public void Deposit(decimal amount)
    {
        balance += amount;
    }
}
```

Conceptually:

```text
Private Field
    ↓
Stores state

Property
    ↓
Exposes controlled access

Method
    ↓
Changes state through behavior
```

This is much closer to proper object-oriented design.

---

# 6️⃣ Instance Members

Most members we are discussing in this module are **instance members**.

That means every object gets its own instance state.

Example:

```csharp
public class Car
{
    public string Brand { get; set; }
    public int Speed { get; set; }

    public void Accelerate()
    {
        Speed += 10;
    }
}
```

Create two objects:

```csharp
Car car1 = new Car();
Car car2 = new Car();

car1.Speed = 100;
car2.Speed = 40;
```

Each object has its own `Speed`.

Calling:

```csharp
car1.Accelerate();
```

changes `car1`, not `car2`.

Result:

```text
car1.Speed = 110
car2.Speed = 40
```

This connects directly to the concept of **independent object state** from Lesson 03.

---

# 7️⃣ Reading and Changing Object State

There are several ways object state can be read or modified.

Consider:

```csharp
public class Product
{
    public decimal Price { get; set; }
}
```

External code can read:

```csharp
Console.WriteLine(product.Price);
```

External code can also write:

```csharp
product.Price = 100;
```

So the property currently provides:

```text
Read access
+
Write access
```

But this raises an important design question:

> ### Should external code always be allowed to change this value?

Sometimes the answer is yes.

Sometimes the answer is no.

This is where access control becomes important.

---

# 8️⃣ Auto-Implemented Properties

C# allows concise property syntax:

```csharp
public string Name { get; set; }
```

This is called an:

> **Auto-Implemented Property**

You do not manually declare the backing field.

C# manages the underlying storage automatically.

Example:

```csharp
public class Product
{
    public string Name { get; set; }
    public decimal Price { get; set; }
}
```

Usage:

```csharp
Product product = new Product();

product.Name = "Laptop";
product.Price = 50000;
```

Auto-properties are convenient when no custom access logic is needed.

---

## Auto-Property Mental Model

Think:

```text
Property
   │
   ├── get
   │
   └── set
```

Behind the scenes, C# maintains storage for the value.

At this stage, the exact compiler-generated implementation is less important than understanding the abstraction.

---

# 9️⃣ Getters and Setters

A property can control reading and writing separately.

Example:

```csharp
public class Employee
{
    private decimal salary;

    public decimal Salary
    {
        get
        {
            return salary;
        }

        set
        {
            salary = value;
        }
    }
}
```

Here:

```text
get
→ returns the field

set
→ receives a new value
```

Inside a setter, the keyword:

```csharp
value
```

represents the incoming value.

Example:

```csharp
employee.Salary = 10000;
```

Inside the setter:

```text
value = 10000
```

---

## Validation Inside a Setter

Technically, we can write:

```csharp
public decimal Salary
{
    get
    {
        return salary;
    }

    set
    {
        if (value < 0)
        {
            throw new ArgumentException("Salary cannot be negative.");
        }

        salary = value;
    }
}
```

Now invalid values are rejected.

This is more controlled than a public field.

However, we still need to think about whether a public setter is the right design.

---

# 🔟 Read-Only and Restricted Properties

Sometimes external code should be able to read a value but not change it directly.

Example:

```csharp
public class BankAccount
{
    public decimal Balance { get; private set; }
}
```

External code can read:

```csharp
Console.WriteLine(account.Balance);
```

But cannot do:

```csharp
account.Balance = 5000;
```

because the setter is private.

Only code inside `BankAccount` can modify the property.

---

## Better Behavior-Oriented Design

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

Now:

```csharp
account.Deposit(1000);
```

is allowed.

But:

```csharp
account.Balance = 1000;
```

is not.

This makes the object more responsible for its own state.

---

## Getter-Only Property

A property can also be getter-only:

```csharp
public string AccountNumber { get; }
```

This means outside code cannot assign to it after initialization through supported construction logic.

We will connect this more deeply to constructors in the next lesson.

---

# 1️⃣1️⃣ Properties Are Not Automatically Encapsulation

This is one of the most important points in this lesson.

A beginner may write:

```csharp
public class BankAccount
{
    public decimal Balance { get; set; }
}
```

and say:

> "I encapsulated Balance because I used a property."

Not necessarily.

External code can still do:

```csharp
account.Balance = -100000;
```

So the object still does not control its state.

This means:

```text
Property
≠
Encapsulation automatically
```

A property is only a **language feature**.

Encapsulation is a **design principle**.

---

## Compare

### Weak Control

```csharp
public decimal Balance { get; set; }
```

External code controls everything.

### Better Control

```csharp
public decimal Balance { get; private set; }

public void Deposit(decimal amount)
{
    // validation
    Balance += amount;
}
```

Now state changes happen through meaningful behavior.

> [!IMPORTANT]
> Encapsulation is about controlling access and protecting rules, not merely replacing fields with properties.

---

# 1️⃣2️⃣ Methods as Behavior

Methods should represent meaningful operations.

Example:

```csharp
public class BankAccount
{
    public decimal Balance { get; private set; }

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

The methods express domain behavior:

```text
Deposit money
Withdraw money
```

Compare that with meaningless method names:

```csharp
public void DoThing()
{
}
```

or:

```csharp
public void ChangeData()
{
}
```

These names do not communicate responsibility.

---

# 1️⃣3️⃣ Methods That Read State

Not every method changes state.

Some methods only inspect state.

Example:

```csharp
public class BankAccount
{
    public decimal Balance { get; private set; }

    public bool HasEnoughBalance(decimal amount)
    {
        return Balance >= amount;
    }
}
```

`HasEnoughBalance()` reads state but does not modify it.

Another example:

```csharp
public class Order
{
    public string Status { get; private set; }

    public bool IsCompleted()
    {
        return Status == "Completed";
    }
}
```

This kind of behavior answers questions about the object.

---

# 1️⃣4️⃣ Methods That Change State

Some methods perform state transitions.

Example:

```csharp
public class Order
{
    public string Status { get; private set; } = "Created";

    public void Confirm()
    {
        Status = "Confirmed";
    }
}
```

Conceptually:

```text
Created
   │
   │ Confirm()
   ▼
Confirmed
```

This is clearer than:

```csharp
order.Status = "Confirmed";
```

because the method expresses **intent**.

Later, it can also enforce rules.

---

# 1️⃣5️⃣ Derived Values

Not every property needs to store independent state.

Some values can be calculated from other values.

Example:

```csharp
public class Rectangle
{
    public double Width { get; set; }
    public double Height { get; set; }

    public double Area
    {
        get
        {
            return Width * Height;
        }
    }
}
```

`Area` does not need separate storage.

It is derived from:

```text
Width
Height
```

This avoids duplicated state.

---

## Why This Matters

Imagine storing:

```text
Width = 10
Height = 5
Area = 20
```

But mathematically:

```text
10 × 5 = 50
```

Now the object contains inconsistent state.

A derived property avoids this problem.

---

## Expression-Bodied Property

C# allows:

```csharp
public double Area => Width * Height;
```

This is equivalent in meaning to a getter that returns the calculation.

---

# 1️⃣6️⃣ Method Parameters and Return Values

Methods often need input.

Example:

```csharp
public void Deposit(decimal amount)
{
    Balance += amount;
}
```

Here:

```text
amount
```

is a parameter.

A method can also return a value:

```csharp
public decimal CalculateDiscount(decimal percentage)
{
    return Price * percentage;
}
```

Methods can therefore:

```text
Receive input
↓
Use object state
↓
Apply logic
↓
Return output
```

---

## Void vs Returning a Value

### Returns nothing

```csharp
public void Start()
{
}
```

### Returns data

```csharp
public decimal CalculateTotal()
{
    return 1000;
}
```

The return type should reflect what the behavior produces.

---

# 1️⃣7️⃣ Naming and Intent

Good member names communicate design.

Compare:

```csharp
public decimal X { get; set; }

public void Do()
{
}
```

with:

```csharp
public decimal Balance { get; private set; }

public void Withdraw(decimal amount)
{
}
```

The second version communicates much more.

Good names answer:

```text
What does this state mean?

What does this behavior do?
```

---

## Naming Guidelines

### Properties and Fields

Prefer nouns:

```text
Name
Balance
Price
Status
Quantity
```

### Methods

Prefer verbs or verb phrases:

```text
Deposit()
Withdraw()
CalculateTotal()
CancelOrder()
AddItem()
```

> [!TIP]
> A clear name reduces the amount of explanation future developers need.

---

# 1️⃣8️⃣ Common Design Mistakes

## ❌ Mistake 1 — Public Fields Everywhere

```csharp
public decimal Balance;
```

This exposes state directly.

---

## ❌ Mistake 2 — Public Setters Everywhere

```csharp
public decimal Balance { get; set; }
```

This may still expose uncontrolled state changes.

---

## ❌ Mistake 3 — Using Properties Only Because "C# Best Practice Says So"

The important question is not:

> Field or property?

The deeper question is:

> Who should be allowed to change this state, and how?

---

## ❌ Mistake 4 — Storing Derived Data

Bad:

```csharp
public decimal Price { get; set; }
public int Quantity { get; set; }
public decimal Total { get; set; }
```

If:

```text
Total = Price × Quantity
```

then storing `Total` independently may introduce inconsistency.

A better design may calculate it:

```csharp
public decimal Total => Price * Quantity;
```

---

## ❌ Mistake 5 — Methods That Do Not Represent Meaningful Behavior

```csharp
public void Process()
{
}
```

Too vague.

A domain method should communicate intent clearly.

---

## ❌ Mistake 6 — Giant Methods

Even though methods represent behavior, one method should not necessarily perform everything.

Example:

```csharp
public void CompleteEverything()
{
    // validate
    // save database
    // charge payment
    // send email
    // generate report
}
```

This usually signals unclear responsibilities.

We will study responsibility separation later.

---

## ❌ Mistake 7 — Too Many Getters and Setters

If every property has:

```csharp
get;
set;
```

ask:

> Is this object actually protecting anything?

A class can look object-oriented while behaving like a public data container.

---

# 1️⃣9️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> Fields store data, properties expose data, methods contain code.

## 👨‍💻 Intermediate Thinking

> Properties help control access, and methods represent behavior.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
Should this value even be stored?

Should it be derived?

Who may read it?

Who may change it?

Should external code set it directly?

Should a method represent the state transition instead?

Does this method express domain intent?

Is this property exposing too much?

Could this state become inconsistent?
```

These questions move us from syntax toward design.

---

# 🎤 Interview Perspective

A common question:

> **What is the difference between a field and a property in C#?**

A stronger answer is:

> A field directly stores data, while a property provides an access abstraction around a value through accessors such as `get` and `set`. Properties can control read/write access and can later include validation or computed logic without exposing the underlying storage directly.

Another common question:

> **Why prefer properties over public fields?**

Because properties provide a controlled abstraction boundary and allow future access logic without exposing storage directly.

But an important follow-up is:

> **Does using a property automatically provide encapsulation?**

No.

Example:

```csharp
public decimal Balance { get; set; }
```

still allows external code to assign arbitrary values.

Real encapsulation depends on who controls state changes and whether object invariants are protected.

---

# 🧩 Mental Models

## Class Members

```text
Class
│
├── State
│   ├── Field
│   └── Property
│
└── Behavior
    └── Method
```

---

## Controlled State

```text
External Code
     │
     ▼
   Method
     │
     ▼
Validation / Rules
     │
     ▼
Object State
```

Instead of:

```text
External Code
     │
     ▼
Directly changes state
```

---

## Property Access

```text
Property
│
├── get → Read
└── set → Write
```

---

## Derived Value

```text
Stored State
   │
   ├── Price
   └── Quantity
        │
        ▼
     Total
   (Derived)
```

---

# 📝 Cheat Sheet

| Concept | Meaning |
|---|---|
| **Field** | Direct storage inside a class |
| **Property** | Controlled access abstraction around a value |
| **Method** | Behavior or operation |
| **`get`** | Allows reading |
| **`set`** | Allows assignment |
| **`private set`** | Setter accessible only inside the declaring type |
| **Auto-Property** | Property with compiler-managed storage |
| **Getter-Only Property** | Property that external code cannot assign directly |
| **Derived Property** | Property calculated from other state |
| **Instance Member** | Member belonging to each object instance |
| **Behavior Method** | Method representing a meaningful object action |
| **State Transition** | Change in object state caused by behavior |

---

# ✅ Key Takeaways

1. Fields, properties, and methods are fundamental C# class members.
2. Fields directly store data.
3. Properties provide an abstraction around reading and writing values.
4. Methods represent behavior.
5. Public fields expose state too directly.
6. Public setters can still allow uncontrolled state changes.
7. `private set` can restrict who changes a property.
8. Properties do **not** automatically equal encapsulation.
9. Meaningful methods can control state transitions.
10. Not every value should be stored; some should be derived.
11. Clear member naming communicates object intent.
12. Good object design asks who can read, change, and protect state.

---

# ➡️ Next Lesson

## 🏭 Lesson 05 — Constructors and Object Initialization

Next, we will study:

- What a constructor is
- Why constructors exist
- Default constructors
- Parameterized constructors
- Constructor overloading
- Object initialization
- Required initial state
- Invalid objects
- Establishing invariants at creation time
- Why creating a valid object matters

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 04 of 08 ✅
</p>
