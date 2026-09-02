

# 🔧 Refactoring Challenge 02 — Adding Constructor Validation

> **Module:** OOP Basics & Encapsulation
> **Category:** Refactoring Challenge
> **Difficulty:** 🟡 Beginner → Intermediate
> **Language:** C#

---

# 📌 Legacy Scenario

You are working on a hotel reservation system.

The original developer created a `Reservation` class.

The idea was:

1. Create an empty reservation.
2. Assign values later.

The developer thought this was flexible.

However, the system started producing invalid reservations:

* Empty customer names.
* Negative prices.
* Invalid dates.
* Missing room information.

Your task:

Refactor the object creation process so that every `Reservation` object starts valid.

---

# 🔴 Original Code

```csharp id="8xv4pm"
public class Reservation
{
    public int Id { get; set; }

    public string CustomerName { get; set; }

    public string RoomNumber { get; set; }

    public DateTime CheckIn { get; set; }

    public DateTime CheckOut { get; set; }

    public decimal Price { get; set; }



    public Reservation()
    {

    }
}
```

---

# Example Usage

```csharp id="0n8zq4"
Reservation reservation =
    new Reservation();



reservation.CustomerName =
    "Ahmed";


reservation.RoomNumber =
    "101";


reservation.Price =
    -500;


reservation.CheckIn =
    new DateTime(2026, 9, 10);


reservation.CheckOut =
    new DateTime(2026, 9, 5);
```

---

# 🔍 Refactoring Goal

Transform this:

```text id="4x7mqp"
Create empty object

        ↓

Fill properties

        ↓

Hope object is valid
```

Into:

```text id="k9m3zq"
Provide required data

        ↓

Validate

        ↓

Create valid object
```

---

# 🔴 Code Smells Identified

---

# ❌ Problem 1 — Empty Constructor

Current:

```csharp id="y4n8p1"
new Reservation();
```

creates:

```text id="u6m2x8"
CustomerName = null

RoomNumber = null

Price = 0

Dates = default
```

The object exists but has no meaning.

---

# ❌ Problem 2 — Object Can Be Invalid

Example:

```csharp id="m7x2q9"
Price = -500;
```

A reservation with a negative price makes no business sense.

---

# ❌ Problem 3 — Public Setters Allow State Breaking

Current:

```csharp id="p4n8m2"
public decimal Price { get; set; }
```

Allows:

```csharp
reservation.Price = -1000;
```

No protection exists.

---

# ❌ Problem 4 — Validation Is Scattered

Without constructor validation:

Everywhere you use:

```text id="v8q3m1"
Reservation
```

you need:

```csharp
if(price < 0)

if(name empty)

if(date invalid)
```

The same rules get duplicated.

---

# 🧠 Senior Engineer Thinking

A senior developer asks:

---

## Question 1

### What should happen after creating an object?

Answer:

The object should be usable immediately.

---

## Question 2

### Who owns reservation validity rules?

Answer:

```text id="s9k4p2"
Reservation
```

Because:

The reservation knows what makes a valid reservation.

---

## Question 3

### Where should invalid data be rejected?

Answer:

At the boundary where it enters the system.

For object creation:

```text id="j3m8x5"
Constructor
```

---

# 🛠 Refactoring Strategy

We will:

---

## Step 1

Remove empty initialization.

---

## Step 2

Require mandatory data through constructor parameters.

---

## Step 3

Validate all incoming values.

---

## Step 4

Protect properties from external modification.

---

# ✅ Refactored Code

```csharp id="v8m2qx"
using System;


public class Reservation
{
    public int Id { get; }


    public string CustomerName { get; }


    public string RoomNumber { get; }


    public DateTime CheckIn { get; }


    public DateTime CheckOut { get; }


    public decimal Price { get; }



    public Reservation(
        int id,
        string customerName,
        string roomNumber,
        DateTime checkIn,
        DateTime checkOut,
        decimal price)
    {
        ValidateCustomerName(customerName);

        ValidateRoomNumber(roomNumber);

        ValidateDates(checkIn, checkOut);

        ValidatePrice(price);



        Id = id;

        CustomerName = customerName;

        RoomNumber = roomNumber;

        CheckIn = checkIn;

        CheckOut = checkOut;

        Price = price;
    }



    private void ValidateCustomerName(
        string customerName)
    {
        if(string.IsNullOrWhiteSpace(customerName))
        {
            throw new ArgumentException(
                "Customer name is required.");
        }
    }



    private void ValidateRoomNumber(
        string roomNumber)
    {
        if(string.IsNullOrWhiteSpace(roomNumber))
        {
            throw new ArgumentException(
                "Room number is required.");
        }
    }



    private void ValidateDates(
        DateTime checkIn,
        DateTime checkOut)
    {
        if(checkOut <= checkIn)
        {
            throw new ArgumentException(
                "Invalid reservation dates.");
        }
    }



    private void ValidatePrice(
        decimal price)
    {
        if(price < 0)
        {
            throw new ArgumentException(
                "Price cannot be negative.");
        }
    }
}
```

---

# 🧪 Test Cases

---

# Valid Reservation

```csharp id="3y8m1q"
public class Program
{
    public static void Main()
    {
        Reservation reservation =
            new Reservation(
                1,
                "Ahmed",
                "101",
                new DateTime(2026,9,10),
                new DateTime(2026,9,15),
                3000);



        Console.WriteLine(
            reservation.Price);
    }
}
```

---

# Output

```text id="5m8q2x"
3000
```

---

# Invalid Customer

```csharp
new Reservation(
    1,
    "",
    "101",
    DateTime.Now,
    DateTime.Now.AddDays(2),
    3000);
```

Result:

```text id="1x7m9p"
Exception:

Customer name is required.
```

---

# Invalid Price

```csharp
new Reservation(
    1,
    "Ahmed",
    "101",
    DateTime.Now,
    DateTime.Now.AddDays(2),
    -500);
```

Result:

```text id="8q3m5z"
Exception:

Price cannot be negative.
```

---

# 🔍 Refactoring Explanation

---

# Before

```text id="4p9m2x"
Reservation

can exist empty

↓

external code fixes it
```

---

# After

```text id="n7k3q8"
Reservation

must receive valid data

↓

object is trustworthy
```

---

# Why Remove Setters?

Before:

```csharp
reservation.Price = -100;
```

Possible.

After:

```csharp
public decimal Price { get; }
```

The value cannot change accidentally.

---

# Why Constructor Validation Matters?

Without validation:

```text id="q2m8x4"
Database

API

UI

Services

```

all need to validate.

With validation:

```text id="r9k3m6"
Reservation

owns its rules
```

---

# Benefits

## 1. Safer Objects

You cannot create:

```text id="h5m8q2"
Reservation

Price = -500
```

---

## 2. Less Duplicate Code

Validation exists in one place.

---

## 3. Easier Maintenance

Business rules are close to the object.

---

# 🎤 Interview Discussion

---

## Q1: Why should constructors validate input?

### Answer:

Because constructors define object creation and should guarantee that every created object starts in a valid state.

---

## Q2: What is an invalid object state?

### Answer:

A state that violates business rules or makes the object unusable.

Example:

```text
Reservation with negative price
```

---

## Q3: Why are public setters dangerous?

### Answer:

They allow external code to bypass validation and break object invariants.

---

## Q4: Should all validation be inside constructors?

### Answer:

No.

Constructor validation is for initial state.
Behavior methods should validate state transitions.

---

# 🧠 Refactoring Checklist

Before approving:

```text id="7q2m9x"
☑ Does the constructor require necessary data?

☑ Can the object exist incomplete?

☑ Are invalid values rejected?

☑ Are properties protected?

☑ Are object invariants guaranteed?
```

---

# 🏁 Key Takeaways

1. Constructors are object validity gates.
2. Objects should not need external fixing after creation.
3. Invalid states should be rejected early.
4. Read-only properties protect important data.
5. Good objects are trustworthy from the moment they exist.

---

<p align="center">
<strong>04-Refactoring-Challenges</strong><br>
Refactoring 02 Completed ✅
</p>

---

