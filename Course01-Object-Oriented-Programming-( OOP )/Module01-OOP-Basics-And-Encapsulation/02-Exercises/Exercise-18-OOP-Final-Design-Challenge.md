

# 🧩 Exercise 18 — OOP Final Design Challenge

> **Course:** Object-Oriented Programming (OOP)
> **Module:** 01 — OOP Basics & Encapsulation
> **Exercise Level:** 🔴 FAANG Interview Style
> **Language:** C#

---

# 🎯 Objective

## Concepts Practiced

This exercise combines:

* Object identification
* Responsibility assignment
* Encapsulation
* Constructors
* Access modifiers
* Invariants
* State transitions
* Collection protection
* Domain modeling

---

# Why This Matters

A junior developer asks:

> "What classes should I create?"

A professional developer asks:

> "What responsibilities exist in this system, and which objects should own them?"

---

# 🏢 Real-World Scenario

# Ride Sharing Application

You are designing the core domain of a ride-sharing platform similar to Uber.

The system manages:

* Drivers
* Passengers
* Trips
* Payments

---

# Business Requirements

A passenger can request a ride.

A driver can accept a ride.

A trip has a lifecycle.

Payment happens after trip completion.

---

# Trip Lifecycle

```text id="3k9m5v"

Requested

    ↓

Accepted

    ↓

Started

    ↓

Completed


Requested

    ↓

Cancelled

```

---

# 📌 Requirements

Design the domain model.

---

# Passenger Requirements

A passenger has:

```text id="7m2x8p"
Id

Name

Active Trips
```

Rules:

```text
Passenger cannot have multiple active trips.
```

---

# Driver Requirements

A driver has:

```text id="4p8n1z"
Id

Name

Availability Status
```

Rules:

```text
Unavailable drivers cannot accept trips.
```

---

# Trip Requirements

A trip has:

```text id="9v3k6m"
Trip Id

Passenger

Driver

Pickup Location

Destination

Status

Price
```

Rules:

```text
Trip cannot start before acceptance.

Completed trip cannot be cancelled.

Price cannot be negative.
```

---

# Payment Requirements

A payment has:

```text id="5n7q2w"
Amount

Payment Status
```

Rules:

```text
Payment only happens after trip completion.
```

---

# 🧠 Engineering Focus

Before coding, answer:

---

# Question 1

## What Are The Main Objects?

From requirements:

```text id="q8m4z1"
Passenger

Driver

Trip

Payment
```

---

# Question 2

## Who Owns Trip State?

Bad:

```text id="3y8n6v"
RideService changes status
```

Example:

```csharp
trip.Status = Completed;
```

---

Better:

```text id="5x9m2k"
Trip controls lifecycle.
```

Because:

```text
Trip owns trip state.
```

---

# Question 3

## Should Driver Availability Be Public?

Bad:

```csharp
driver.IsAvailable = true;
```

Someone can create:

```text
Driver

+
Already assigned trip

+
Available status
```

The driver should control availability.

---

# ❌ Bad Design Example

```csharp
public class RideSystem
{
    public List<string> Drivers;

    public List<string> Passengers;

    public List<string> Trips;


    public void CompleteTrip()
    {
        // update everything
    }


    public void Pay()
    {
        // payment logic
    }
}
```

---

# Why This Is Poor Design

## 1. No Domain Objects

Everything is controlled by one class.

---

## 2. Rules Are Centralized

The system knows:

* Driver rules.
* Passenger rules.
* Trip rules.
* Payment rules.

---

## 3. Invalid States Are Possible

Example:

```text
Trip Completed

Payment Not Allowed
```

---

# ✅ Expected Design Direction

The model:

```text id="u6c8p4"

Passenger

Owns:
- Active trip rule


Driver

Owns:
- Availability


Trip

Owns:
- Lifecycle


Payment

Owns:
- Payment state

```

---

# Design Diagram

```text
              Passenger

                  |
                  |
                  ▼

                Trip

          /             \

         /               \

    Driver             Payment


```

---

# 💻 Solution

## Enums

```csharp
public enum TripStatus
{
    Requested,
    Accepted,
    Started,
    Completed,
    Cancelled
}
```

---

```csharp
public enum DriverStatus
{
    Available,
    Busy
}
```

---

```csharp
public enum PaymentStatus
{
    Pending,
    Paid
}
```

---

# Driver Class

```csharp
public class Driver
{
    public int Id { get; }

    public string Name { get; }

    public DriverStatus Status { get; private set; }


    public Driver(
        int id,
        string name)
    {
        Id = id;

        Name = name;

        Status = DriverStatus.Available;
    }


    public void AssignTrip()
    {
        if(Status != DriverStatus.Available)
        {
            throw new InvalidOperationException(
                "Driver is not available.");
        }

        Status = DriverStatus.Busy;
    }


    public void CompleteTrip()
    {
        Status = DriverStatus.Available;
    }
}
```

---

# Passenger Class

```csharp
public class Passenger
{
    public int Id { get; }

    public string Name { get; }


    public Passenger(
        int id,
        string name)
    {
        Id = id;

        Name = name;
    }
}
```

---

# Trip Class

```csharp
public class Trip
{
    public int Id { get; }

    public Passenger Passenger { get; }

    public Driver Driver { get; private set; }

    public TripStatus Status { get; private set; }

    public decimal Price { get; }


    public Trip(
        int id,
        Passenger passenger,
        decimal price)
    {
        if(price < 0)
        {
            throw new ArgumentException(
                "Invalid price.");
        }


        Id = id;

        Passenger = passenger;

        Price = price;

        Status = TripStatus.Requested;
    }


    public void Accept(Driver driver)
    {
        if(Status != TripStatus.Requested)
        {
            throw new InvalidOperationException(
                "Trip cannot be accepted.");
        }


        driver.AssignTrip();

        Driver = driver;

        Status = TripStatus.Accepted;
    }


    public void Start()
    {
        if(Status != TripStatus.Accepted)
        {
            throw new InvalidOperationException(
                "Trip must be accepted first.");
        }


        Status = TripStatus.Started;
    }


    public void Complete()
    {
        if(Status != TripStatus.Started)
        {
            throw new InvalidOperationException(
                "Trip must start first.");
        }


        Driver.CompleteTrip();

        Status = TripStatus.Completed;
    }


    public void Cancel()
    {
        if(Status == TripStatus.Completed)
        {
            throw new InvalidOperationException(
                "Completed trip cannot be cancelled.");
        }


        Status = TripStatus.Cancelled;
    }
}
```

---

# Payment Class

```csharp
public class Payment
{
    public decimal Amount { get; }

    public PaymentStatus Status { get; private set; }


    public Payment(
        decimal amount)
    {
        Amount = amount;

        Status = PaymentStatus.Pending;
    }


    public void Pay(Trip trip)
    {
        if(trip.Status != TripStatus.Completed)
        {
            throw new InvalidOperationException(
                "Trip must be completed.");
        }


        Status = PaymentStatus.Paid;
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
        Passenger passenger =
            new Passenger(
                1,
                "Mohamed");


        Driver driver =
            new Driver(
                1,
                "Ahmed");


        Trip trip =
            new Trip(
                100,
                passenger,
                150);


        trip.Accept(driver);

        trip.Start();

        trip.Complete();


        Payment payment =
            new Payment(
                150);


        payment.Pay(trip);


        Console.WriteLine(
            payment.Status);
    }
}
```

---

# Expected Output

```text
Paid
```

---

# 🔍 Solution Explanation

## Why Does Trip Control Status?

Because lifecycle rules belong to the trip.

Only the trip knows:

```text
Requested → Accepted

Accepted → Started

Started → Completed
```

---

## Why Does Driver Control Availability?

Because availability is driver state.

External code should not do:

```csharp
driver.Status = Busy;
```

---

## Why Is Payment Separate?

Because payment is a different business responsibility.

A trip is not responsible for:

* Payment processing.
* Payment status.
* Payment methods.

---

# 💡 Senior Engineer Notes

## Domain Modeling Rule

A useful question:

> Which object has the information required to enforce this rule?

Example:

"Can a trip start?"

Who knows?

```text
Trip
```

Therefore:

```text
Trip.Start()
```

---

# Common Mistakes

## ❌ One Giant Manager Class

```text
RideService
```

doing everything.

---

## ❌ Public State Changes

```csharp
trip.Status = Completed;
```

---

## ❌ Data-only Classes

Classes with only:

```text
Properties
```

and no behavior.

---

# 🎤 Interview Connection

## Question 1

### How do you design classes from requirements?

Answer:

Identify domain concepts, assign responsibilities, define relationships, and protect important rules.

---

## Question 2

### How do you decide where a method belongs?

Answer:

Place behavior in the object that owns the data needed to perform that behavior.

---

## Question 3

### Why avoid large service classes?

Answer:

Because they create low cohesion and concentrate too many responsibilities.

---

## Question 4

### What makes an object well-designed?

Answer:

It has:

* Clear responsibility.
* Encapsulated state.
* Controlled behavior.
* Protected invariants.

---

# 🧠 Engineering Reflection

```text
1. Why does Trip own lifecycle transitions?

2. Why should Driver control availability?

3. Why is Payment separate from Trip?

4. What invalid states does this design prevent?

5. How would you extend this system for real production?
```

---

# 🏁 Key Takeaways

1. Design starts from responsibilities, not properties.
2. Good objects protect their own rules.
3. Domain models represent business concepts.
4. Avoid "God classes".
5. Encapsulation creates reliable systems.
6. OOP is about modeling behavior, not organizing data.

---

<p align="center">
  <strong>Module 01 — OOP Basics & Encapsulation</strong><br>
  Exercise 18 of 19 ✅
</p>

````

