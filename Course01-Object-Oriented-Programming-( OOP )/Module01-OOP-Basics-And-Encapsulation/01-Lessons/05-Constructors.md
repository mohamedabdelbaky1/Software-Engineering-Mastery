# 🏭 Lesson 05 — Constructors and Object Initialization

> **Course:** Object-Oriented Programming (OOP)  
> **Module:** 01 — OOP Basics & Encapsulation  
> **Language:** C#  
> **Level:** Beginner → Professional Foundations

---

## 📌 Table of Contents

- [🎯 Learning Goals](#-learning-goals)
- [1️⃣ Why Constructors Exist](#1️⃣-why-constructors-exist)
- [2️⃣ What Is a Constructor?](#2️⃣-what-is-a-constructor)
- [3️⃣ Constructor Syntax in C#](#3️⃣-constructor-syntax-in-c)
- [4️⃣ Default Constructor](#4️⃣-default-constructor)
- [5️⃣ Parameterized Constructor](#5️⃣-parameterized-constructor)
- [6️⃣ Constructor Overloading](#6️⃣-constructor-overloading)
- [7️⃣ Object Initialization](#7️⃣-object-initialization)
- [8️⃣ Valid Initial State](#8️⃣-valid-initial-state)
- [9️⃣ Invalid Objects](#9️⃣-invalid-objects)
- [🔟 Validation Inside Constructors](#-validation-inside-constructors)
- [1️⃣1️⃣ Constructors and Invariants](#1️⃣1️⃣-constructors-and-invariants)
- [1️⃣2️⃣ Read-Only State and Constructors](#1️⃣2️⃣-read-only-state-and-constructors)
- [1️⃣3️⃣ Constructor Chaining](#1️⃣3️⃣-constructor-chaining)
- [1️⃣4️⃣ Object Initializers vs Constructors](#1️⃣4️⃣-object-initializers-vs-constructors)
- [1️⃣5️⃣ Required Members in Modern C#](#1️⃣5️⃣-required-members-in-modern-c)
- [1️⃣6️⃣ Constructors Should Not Do Too Much](#1️⃣6️⃣-constructors-should-not-do-too-much)
- [1️⃣7️⃣ Common Design Mistakes](#1️⃣7️⃣-common-design-mistakes)
- [1️⃣8️⃣ Junior vs Senior Thinking](#1️⃣8️⃣-junior-vs-senior-thinking)
- [🎤 Interview Perspective](#-interview-perspective)
- [🧩 Mental Models](#-mental-models)
- [📝 Cheat Sheet](#-cheat-sheet)
- [✅ Key Takeaways](#-key-takeaways)
- [➡️ Next Lesson](#️-next-lesson)

---

# 🎯 Learning Goals

By the end of this lesson, you should understand:

- What a **constructor** is in C#.
- Why constructors exist.
- What a **default constructor** is.
- What a **parameterized constructor** is.
- What **constructor overloading** means.
- How constructors establish an object's initial state.
- Why an object should ideally be valid immediately after creation.
- How constructors can help enforce business rules and invariants.
- How getter-only and restricted properties work with constructors.
- What constructor chaining is.
- The difference between constructors and object initializers.
- Why constructors should not perform excessive or unrelated work.

---

# 1️⃣ Why Constructors Exist

Suppose we have this class:

```csharp
public class BankAccount
{
    public string AccountNumber { get; set; }
    public string OwnerName { get; set; }
    public decimal Balance { get; set; }
}
```

We can create an object:

```csharp
BankAccount account = new BankAccount();
```

At this moment, the object exists.

But what is its state?

Conceptually:

```text
AccountNumber = null
OwnerName     = null
Balance       = 0
```

Maybe that is acceptable.

Maybe it is not.

Suppose the domain says:

```text
Every bank account must have:
- Account number
- Owner
```

Then this object should never exist:

```csharp
BankAccount account = new BankAccount();
```

because it is incomplete.

This is one of the main reasons constructors are important.

> **A constructor helps establish the initial state of an object at creation time.**

---

# 2️⃣ What Is a Constructor?

A **constructor** is a special member of a class that runs when a new object is created.

Example:

```csharp
public class Car
{
    public string Brand { get; set; }

    public Car()
    {
        Brand = "Unknown";
    }
}
```

When we write:

```csharp
Car car = new Car();
```

the constructor runs automatically.

After creation:

```text
Brand = Unknown
```

---

## Constructor Characteristics

A constructor:

- Has the same name as the class.
- Has no return type.
- Runs when an object is created.
- Can receive parameters.
- Can initialize fields and properties.
- Can validate required data.
- Can help establish object invariants.

---

# 3️⃣ Constructor Syntax in C#

Basic syntax:

```csharp
public class Car
{
    public Car()
    {
    }
}
```

Notice:

```text
Class Name       → Car
Constructor Name → Car
```

There is no return type.

This is incorrect:

```csharp
public void Car()
{
}
```

That is a method, not a constructor.

---

## Constructor Execution

```csharp
Car car = new Car();
```

Conceptually:

```text
new Car()
   │
   ▼
Constructor executes
   │
   ▼
Object is initialized
   │
   ▼
Reference returned
```

---

# 4️⃣ Default Constructor

If you declare no constructor at all, C# usually provides a public parameterless constructor automatically for a class.

Example:

```csharp
public class Car
{
    public string Brand { get; set; }
}
```

This works:

```csharp
Car car = new Car();
```

You did not explicitly write:

```csharp
public Car()
{
}
```

but the compiler provides a parameterless constructor.

---

## Important Detail

Once you declare your own constructor, C# does **not** automatically provide a parameterless one.

Example:

```csharp
public class Car
{
    public string Brand { get; set; }

    public Car(string brand)
    {
        Brand = brand;
    }
}
```

Now this works:

```csharp
Car car = new Car("BMW");
```

But this does not:

```csharp
Car car = new Car();
```

unless you explicitly add:

```csharp
public Car()
{
}
```

> [!IMPORTANT]
> The compiler-generated parameterless constructor exists only when you have not declared any instance constructor yourself.

---

# 5️⃣ Parameterized Constructor

A constructor can receive parameters.

Example:

```csharp
public class Car
{
    public string Brand { get; private set; }

    public Car(string brand)
    {
        Brand = brand;
    }
}
```

Usage:

```csharp
Car car = new Car("BMW");
```

Now the object is created with meaningful initial state.

Instead of:

```csharp
Car car = new Car();
car.Brand = "BMW";
```

we require:

```csharp
Car car = new Car("BMW");
```

This can be much stronger when `Brand` is required.

---

## Why This Matters

Compare:

### Weak Initialization

```csharp
Customer customer = new Customer();

customer.Name = "Ali";
customer.Email = "ali@example.com";
```

The object exists temporarily with missing data.

### Stronger Initialization

```csharp
Customer customer =
    new Customer("Ali", "ali@example.com");
```

The object is created with the required state immediately.

---

# 6️⃣ Constructor Overloading

A class can have multiple constructors with different parameter lists.

This is called:

> **Constructor Overloading**

Example:

```csharp
public class Product
{
    public string Name { get; private set; }
    public decimal Price { get; private set; }

    public Product(string name)
    {
        Name = name;
        Price = 0;
    }

    public Product(string name, decimal price)
    {
        Name = name;
        Price = price;
    }
}
```

Usage:

```csharp
Product p1 = new Product("Laptop");

Product p2 = new Product("Laptop", 50000);
```

The compiler chooses the constructor based on the arguments.

---

## Overloading Means

```text
Same constructor name
+
Different parameter lists
```

Since constructors always share the class name, overloads are distinguished by their parameters.

---

# 7️⃣ Object Initialization

Object initialization means establishing the initial values of an object.

There are several ways this can happen.

## Method 1 — Constructor

```csharp
Product product =
    new Product("Laptop", 50000);
```

## Method 2 — Object Initializer

```csharp
Product product = new Product
{
    Name = "Laptop",
    Price = 50000
};
```

## Method 3 — Defaults

```csharp
public class Product
{
    public string Status { get; set; } = "Active";
}
```

But these approaches do not have the same design meaning.

Constructors are especially useful when certain values are **required for validity**.

---

# 8️⃣ Valid Initial State

A powerful object-oriented principle is:

> **An object should ideally be valid immediately after construction.**

Suppose:

```csharp
public class BankAccount
{
    public string AccountNumber { get; set; }
    public string OwnerName { get; set; }
}
```

This allows:

```csharp
BankAccount account = new BankAccount();
```

Now the object exists without:

```text
AccountNumber
OwnerName
```

If those are required, the object is invalid.

---

## Better Direction

```csharp
public class BankAccount
{
    public string AccountNumber { get; }
    public string OwnerName { get; }

    public BankAccount(
        string accountNumber,
        string ownerName)
    {
        AccountNumber = accountNumber;
        OwnerName = ownerName;
    }
}
```

Now this is impossible:

```csharp
BankAccount account = new BankAccount();
```

The caller must provide the required data.

---

# 9️⃣ Invalid Objects

An **invalid object** is an object whose state violates required rules.

Example:

```csharp
public class Employee
{
    public string Name { get; set; }
}
```

If the rule says:

```text
Employee name is required.
```

then:

```csharp
Employee employee = new Employee();
```

creates an invalid object.

The class allows a state the domain rejects.

This creates a dangerous pattern:

```text
Create invalid object
        ↓
Hope someone fills it correctly later
```

A stronger design is:

```text
Require essential information
        ↓
Create valid object
```

---

# 🔟 Validation Inside Constructors

Constructors can validate required data.

Example:

```csharp
public class Product
{
    public string Name { get; }
    public decimal Price { get; }

    public Product(string name, decimal price)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException(
                "Product name is required.",
                nameof(name));
        }

        if (price < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(price),
                "Price cannot be negative.");
        }

        Name = name;
        Price = price;
    }
}
```

Now invalid creation attempts fail immediately.

Example:

```csharp
Product product =
    new Product("", -100);
```

The object is not successfully created with invalid state.

---

## Why Constructor Validation Is Powerful

Without validation:

```text
Invalid input
   ↓
Object created
   ↓
Invalid state spreads
   ↓
Bug appears later
```

With validation:

```text
Invalid input
   ↓
Rejected immediately
```

This is often described as:

> **Fail fast.**

---

# 1️⃣1️⃣ Constructors and Invariants

Recall from earlier lessons:

> An invariant is a rule that must remain true for an object to be valid.

Suppose:

```text
BankAccount Invariants

AccountNumber is required.
OwnerName is required.
Initial balance cannot be negative.
```

We can enforce them:

```csharp
public class BankAccount
{
    public string AccountNumber { get; }
    public string OwnerName { get; }
    public decimal Balance { get; private set; }

    public BankAccount(
        string accountNumber,
        string ownerName,
        decimal initialBalance)
    {
        if (string.IsNullOrWhiteSpace(accountNumber))
        {
            throw new ArgumentException(
                "Account number is required.",
                nameof(accountNumber));
        }

        if (string.IsNullOrWhiteSpace(ownerName))
        {
            throw new ArgumentException(
                "Owner name is required.",
                nameof(ownerName));
        }

        if (initialBalance < 0)
        {
            throw new ArgumentOutOfRangeException(
                nameof(initialBalance),
                "Initial balance cannot be negative.");
        }

        AccountNumber = accountNumber;
        OwnerName = ownerName;
        Balance = initialBalance;
    }
}
```

Now construction establishes the initial invariant.

---

## Important Limitation

A valid constructor is only the beginning.

The object must also remain valid **after creation**.

Example:

```csharp
public decimal Balance { get; set; }
```

would allow this later:

```csharp
account.Balance = -100000;
```

So:

```text
Constructor validity
+
Controlled state transitions
=
Stronger encapsulation
```

We will complete this idea in the Encapsulation lesson.

---

# 1️⃣2️⃣ Read-Only State and Constructors

Constructors are useful when values should be set once and not changed freely afterward.

Example:

```csharp
public class BankAccount
{
    public string AccountNumber { get; }

    public BankAccount(string accountNumber)
    {
        AccountNumber = accountNumber;
    }
}
```

External code can read:

```csharp
Console.WriteLine(account.AccountNumber);
```

But cannot write:

```csharp
account.AccountNumber = "NEW-123";
```

This protects identity-like or immutable state.

---

## `readonly` Fields

Fields can also be declared:

```csharp
private readonly string accountNumber;
```

A `readonly` field can normally be assigned:

- At declaration
- Inside a constructor

Example:

```csharp
public class BankAccount
{
    private readonly string accountNumber;

    public BankAccount(string accountNumber)
    {
        this.accountNumber = accountNumber;
    }
}
```

Later in the course, we will study immutability more deeply.

---

# 1️⃣3️⃣ Constructor Chaining

Sometimes multiple constructors share initialization logic.

Bad example:

```csharp
public class Product
{
    public string Name { get; private set; }
    public decimal Price { get; private set; }

    public Product(string name)
    {
        Name = name;
        Price = 0;
    }

    public Product(string name, decimal price)
    {
        Name = name;
        Price = price;
    }
}
```

There is duplicated initialization logic.

We can chain constructors using:

```csharp
this(...)
```

Example:

```csharp
public class Product
{
    public string Name { get; private set; }
    public decimal Price { get; private set; }

    public Product(string name)
        : this(name, 0)
    {
    }

    public Product(string name, decimal price)
    {
        Name = name;
        Price = price;
    }
}
```

Now:

```csharp
new Product("Laptop");
```

calls:

```csharp
this("Laptop", 0);
```

which delegates to the other constructor.

---

## Why Constructor Chaining Helps

It can reduce:

```text
Duplicated initialization logic
Duplicated validation
Inconsistent object creation
```

A useful principle is:

> **Keep one main initialization path when possible.**

---

# 1️⃣4️⃣ Object Initializers vs Constructors

C# supports object initializers:

```csharp
Customer customer = new Customer
{
    Name = "Ali",
    Email = "ali@example.com"
};
```

This looks clean.

But consider:

```csharp
Customer customer = new Customer();
```

This is still allowed before setting the properties.

If `Name` and `Email` are required, that may be undesirable.

---

## Constructor

```csharp
Customer customer =
    new Customer("Ali", "ali@example.com");
```

The required data is part of object creation.

---

## Comparison

| Constructor | Object Initializer |
|---|---|
| Good for required state | Good for optional/configurable state |
| Can enforce validation | Depends on property setters |
| Prevents some incomplete creation | May allow incomplete object first |
| Expresses creation contract | Expresses post-construction assignments |

This is not an absolute rule.

But it is an important design distinction.

---

# 1️⃣5️⃣ Required Members in Modern C#

Modern C# supports the `required` keyword.

Example:

```csharp
public class Customer
{
    public required string Name { get; init; }
    public required string Email { get; init; }
}
```

Usage:

```csharp
Customer customer = new Customer
{
    Name = "Ali",
    Email = "ali@example.com"
};
```

The compiler helps ensure required members are assigned.

---

## `required` vs Constructor

Both can help with initialization, but they are not identical.

### `required`

Useful when:

```text
Object initializer style is desirable
+
Compiler-enforced assignment is enough
```

### Constructor

Useful when:

```text
Creation needs validation
+
Rules
+
Transformation
+
A strict creation contract
```

A senior engineer chooses based on design needs, not fashion.

---

# 1️⃣6️⃣ Constructors Should Not Do Too Much

Constructors should establish object state.

They should generally avoid performing large, expensive, unrelated operations.

Problematic example:

```csharp
public class Customer
{
    public Customer(string email)
    {
        // Connect to database
        // Call external API
        // Send email
        // Write file
        // Generate report
    }
}
```

This makes object creation:

- Slow
- Hard to test
- Hard to reason about
- Full of hidden side effects
- Dependent on external systems

---

## Better Mental Model

Constructor responsibility:

```text
Receive required data
        ↓
Validate required data
        ↓
Establish initial state
        ↓
Create valid object
```

Not:

```text
Run the entire application
```

> [!WARNING]
> Constructors with heavy I/O or many side effects are usually a design smell.

---

# 1️⃣7️⃣ Common Design Mistakes

## ❌ Mistake 1 — Allowing Required State to Be Missing

```csharp
Customer customer = new Customer();
```

when the object cannot be valid without a name or email.

---

## ❌ Mistake 2 — Empty Constructor + Public Setters Everywhere

```csharp
public class BankAccount
{
    public string AccountNumber { get; set; }
    public decimal Balance { get; set; }
}
```

This gives external code complete responsibility for creating a valid object.

---

## ❌ Mistake 3 — Constructors with Too Many Parameters

Example:

```csharp
public Customer(
    string name,
    string email,
    string phone,
    string address,
    string city,
    string country,
    string postalCode,
    string company,
    string jobTitle)
{
}
```

This may indicate:

- Too much responsibility
- Missing value objects
- Poor grouping
- A large domain concept

We will study these design problems later.

Do not automatically replace every long constructor with a pattern.

First ask:

> Why does this object need all of these values?

---

## ❌ Mistake 4 — Multiple Constructors with Different Rules

Example:

```text
Constructor A validates email.
Constructor B does not.
Constructor C uses different defaults.
```

Now object validity depends on which constructor was called.

Constructor chaining can help centralize initialization.

---

## ❌ Mistake 5 — Performing External Work in Constructors

Avoid constructors that unexpectedly:

```text
Send email
Access database
Call API
Create files
Start background work
```

unless there is an unusually strong reason.

---

## ❌ Mistake 6 — Assuming Constructors Alone Give Full Encapsulation

A constructor can establish valid initial state.

But later public setters may still destroy it.

Example:

```csharp
public decimal Balance { get; set; }
```

So we need:

```text
Valid creation
+
Controlled future changes
```

---

# 1️⃣8️⃣ Junior vs Senior Thinking

## 👶 Beginner Thinking

> Constructor runs when I use `new`.

## 👨‍💻 Intermediate Thinking

> Constructors initialize fields and properties and can receive parameters.

## 🧠 Senior-Oriented Thinking

A stronger engineer asks:

```text
What information is mandatory for this object to exist?

Can this object ever be created invalid?

Which invariants must hold immediately?

Should this value be immutable after construction?

Are there too many construction paths?

Do all constructors enforce the same rules?

Is this constructor doing work unrelated to initialization?

Should creation fail immediately if input is invalid?

Is object construction revealing a deeper design problem?
```

That is the shift from syntax to engineering design.

---

# 🎤 Interview Perspective

A common question:

> **What is a constructor in C#?**

A strong answer:

> A constructor is a special class member that runs during object creation and is used to establish the object's initial state. Constructors can receive parameters, validate required data, and help ensure that an object starts in a valid state.

Another question:

> **Does C# always create a default constructor?**

No.

A compiler-generated parameterless constructor is provided only when no instance constructor has been declared.

Another important question:

> **Why might a parameterized constructor be preferable to creating an empty object and setting properties later?**

Because it can make required state part of the creation contract and prevent incomplete or invalid objects from existing.

---

# 🧩 Mental Models

## Object Construction

```text
Required Input
     │
     ▼
Constructor
     │
     ├── Validate
     ├── Initialize
     └── Establish Rules
     │
     ▼
Valid Object
```

---

## Weak Creation Flow

```text
new Object()
     │
     ▼
Incomplete Object
     │
     ▼
External Code Must Fix It
```

---

## Stronger Creation Flow

```text
Required Data
     │
     ▼
Constructor
     │
     ▼
Valid Object
```

---

## Constructor + Encapsulation

```text
Constructor
   │
   └── Protect initial state

Methods / Controlled setters
   │
   └── Protect future state
```

---

# 📝 Cheat Sheet

| Concept | Meaning |
|---|---|
| **Constructor** | Special member that initializes an object |
| **Parameterless Constructor** | Constructor with no parameters |
| **Parameterized Constructor** | Constructor receiving required input |
| **Constructor Overloading** | Multiple constructors with different parameter lists |
| **Object Initialization** | Establishing initial object state |
| **Valid Initial State** | State satisfying required rules after creation |
| **Invariant** | Rule that must remain true for a valid object |
| **Constructor Validation** | Rejecting invalid creation input |
| **Constructor Chaining** | One constructor delegates to another |
| **Getter-Only Property** | Value readable externally but not freely assigned |
| **`readonly` Field** | Field assigned at declaration or construction and then restricted |
| **Object Initializer** | Syntax for assigning accessible members during creation |
| **`required` Member** | Member the compiler requires callers to initialize |

---

# ✅ Key Takeaways

1. Constructors run when objects are created.
2. Their primary responsibility is establishing initial object state.
3. Parameterized constructors can make required data part of the creation contract.
4. Objects should ideally be valid immediately after construction.
5. Constructor validation can reject invalid state early.
6. Constructors can help establish invariants.
7. Getter-only properties and `readonly` fields can protect values after construction.
8. Constructor overloading provides multiple creation paths.
9. Constructor chaining helps centralize initialization logic.
10. Object initializers are useful but do not replace constructors in every design.
11. Constructors should generally avoid heavy external side effects.
12. Valid construction is only one half of encapsulation; future state changes must also be controlled.

---

# ➡️ Next Lesson

## 🔐 Lesson 06 — Access Modifiers

Next, we will study:

- `public`
- `private`
- `protected`
- `internal`
- Member accessibility
- Type accessibility
- Public API vs implementation details
- Why everything should not be public
- How access modifiers support object boundaries
- How accessibility prepares us for Encapsulation

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Lesson 05 of 08 ✅
</p>
