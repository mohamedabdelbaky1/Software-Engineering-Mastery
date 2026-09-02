

# 🔧 Refactoring Challenge 07 — Creating Valid Objects

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on a vehicle management system.

The team created a `Car` class.

The current design allows developers to create an empty car and configure it later.

After some time, bugs appeared:

* Cars without models.
* Negative speed values.
* Invalid engine states.
* Objects used before initialization.

Your task:

Refactor the class so every `Car` object is valid from the moment it is created.

---

# 🔴 Original Code

```csharp
public class Car
{
    public string Brand { get; set; }

    public string Model { get; set; }

    public int Speed { get; set; }

    public bool EngineStarted { get; set; }
}
```

---

# Example Usage

```csharp
Car car =
    new Car();



car.Brand = "BMW";

car.Model = "M3";

car.Speed = -100;

car.EngineStarted = true;
```

---

# Current Object State

The object can become:

```text
Car

Brand:
BMW

Model:
M3

Speed:
-100

Engine:
Started
```

This object does not represent a realistic car.

---

# 🔍 Code Smells Identified

---

# ❌ Problem 1 — Empty Object Creation

Current:

```csharp
new Car();
```

creates an incomplete object.

At creation time:

```text
Brand = null

Model = null

Speed = 0

EngineStarted = false
```

The object has no identity.

---

# ❌ Problem 2 — Initialization Is External

The responsibility is moved to every caller:

```csharp
car.Brand = "...";

car.Model = "...";

car.Speed = "...";
```

Every developer must know:

* Which properties are required.
* Which order is correct.
* Which values are allowed.

---

# ❌ Problem 3 — Invalid State Is Possible

Example:

```csharp
car.Speed = -100;
```

A car cannot have negative speed.

The class does not protect itself.

---

# ❌ Problem 4 — Object Identity Is Missing

A real car needs:

```text
Brand

Model
```

to identify what it represents.

But the constructor does not require them.

---

# 🧠 Senior Engineer Thinking

A senior engineer asks:

---

## Question 1

What makes a valid Car?

Minimum:

```text
Brand exists

Model exists

Speed >= 0

Engine state is controlled
```

---

## Question 2

Who should guarantee validity?

Answer:

```text
Car
```

The object itself.

---

## Question 3

Should external code build the object step-by-step?

Usually no.

The object should receive everything required during creation.

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Add a constructor.

---

## Step 2

Require essential information.

---

## Step 3

Remove unsafe setters.

---

## Step 4

Control state changes through methods.

---

# ✅ Refactored Code

```csharp
using System;


public class Car
{
    public string Brand { get; }

    public string Model { get; }


    public int Speed { get; private set; }


    public bool EngineStarted { get; private set; }



    public Car(
        string brand,
        string model)
    {
        if(string.IsNullOrWhiteSpace(brand))
        {
            throw new ArgumentException(
                "Brand is required.");
        }


        if(string.IsNullOrWhiteSpace(model))
        {
            throw new ArgumentException(
                "Model is required.");
        }


        Brand = brand;

        Model = model;

        Speed = 0;

        EngineStarted = false;
    }



    public void StartEngine()
    {
        EngineStarted = true;
    }



    public void StopEngine()
    {
        if(Speed > 0)
        {
            throw new InvalidOperationException(
                "Cannot stop engine while moving.");
        }


        EngineStarted = false;
    }



    public void Accelerate(int amount)
    {
        if(!EngineStarted)
        {
            throw new InvalidOperationException(
                "Engine is not started.");
        }


        if(amount <= 0)
        {
            throw new ArgumentException(
                "Invalid acceleration.");
        }


        Speed += amount;
    }



    public void Brake(int amount)
    {
        if(amount <= 0)
        {
            throw new ArgumentException(
                "Invalid brake amount.");
        }


        Speed -= amount;


        if(Speed < 0)
        {
            Speed = 0;
        }
    }
}
```

---

# 🧪 Test Cases

---

## Valid Usage

```csharp
public class Program
{
    public static void Main()
    {
        Car car =
            new Car(
                "BMW",
                "M3");



        car.StartEngine();


        car.Accelerate(80);



        Console.WriteLine(
            car.Speed);
    }
}
```

---

# Output

```text
80
```

---

# Invalid Usage

```csharp
Car car =
    new Car(
        "",
        "M3");
```

Result:

```text
Exception:

Brand is required.
```

---

# Invalid State Change

```csharp
car.Accelerate(100);
```

without:

```csharp
car.StartEngine();
```

Result:

```text
Exception:

Engine is not started.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text
Create empty object

↓

Set values

↓

Hope it becomes valid
```

---

# After

```text
Provide required data

↓

Validate

↓

Create valid object
```

---

# Why Remove Public Setters?

Before:

```csharp
car.Speed = -100;
```

Possible.

After:

```csharp
car.Accelerate(100);
```

The car controls speed changes.

---

# Why Are StartEngine() and StopEngine() Methods?

Because engine state is not simple data.

Changing:

```text
EngineStarted = true
```

is a behavior.

It may require rules:

* Maintenance check.
* Fuel availability.
* Safety conditions.

---

# Object Lifecycle

The new lifecycle:

```text
Created

   ↓

Engine stopped

   ↓

StartEngine()

   ↓

Running

   ↓

Accelerate()

   ↓

Moving
```

Every transition is controlled.

---

# 🎤 Interview Discussion

---

## Q1: Why should objects be valid after construction?

### Answer:

Because other parts of the system can trust the object without performing repeated validation.

---

## Q2: What is the difference between initialization and state transition?

### Answer:

Initialization creates the first valid state.

State transition changes the object while respecting rules.

---

## Q3: Why avoid object creation with many public setters?

### Answer:

Because it allows incomplete and invalid objects.

---

## Q4: What is an invariant in this example?

### Answer:

Conditions that must always remain true:

```text
Speed >= 0

Engine cannot stop while moving
```

---

# 🧠 Refactoring Checklist

```text
☑ Can the object exist incomplete?

☑ Are required values constructor parameters?

☑ Are invalid values rejected?

☑ Are state changes controlled?

☑ Does the object protect its invariants?
```

---

# 🏁 Key Takeaways

1. Objects should be valid immediately after creation.
2. Constructors define the starting valid state.
3. Public setters often create uncontrolled objects.
4. State transitions should happen through meaningful methods.
5. Objects should protect their own invariants.
6. A trustworthy object reduces complexity across the system.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 07 Completed ✅
</p>

---


