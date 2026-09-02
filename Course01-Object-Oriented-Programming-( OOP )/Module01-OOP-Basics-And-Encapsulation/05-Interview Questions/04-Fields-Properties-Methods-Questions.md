

# 🎤 Interview Questions 04 — Fields, Properties, and Methods

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What is a Field in C#?

## Answer

A field is a variable declared inside a class that stores object state.

Example:

```csharp
public class BankAccount
{
    private decimal balance;
}
```

Here:

```text
balance
```

is a field.

It represents internal state owned by the object.

---

# Q2 — What is a Property in C#?

## Answer

A property provides controlled access to data.

Example:

```csharp
public class Employee
{
    public string Name { get; set; }
}
```

A property looks like a field when used:

```csharp
employee.Name = "Ahmed";
```

but internally it is a pair of methods:

```text
get
set
```

---

# Q3 — What is the difference between Field and Property?

## Answer

| Field                    | Property                   |
| ------------------------ | -------------------------- |
| Stores data directly     | Provides controlled access |
| Usually private          | Usually public             |
| No validation by default | Can contain logic          |
| Implementation detail    | Part of object API         |

Example:

Field:

```csharp
private decimal salary;
```

Property:

```csharp
public decimal Salary
{
    get
    {
        return salary;
    }
}
```

---

# Q4 — Why are fields usually private?

## Answer

Because fields represent internal implementation details.

Example:

Bad:

```csharp
public decimal balance;
```

Any code can do:

```csharp
account.balance = -500;
```

The object loses control.

Better:

```csharp
private decimal balance;
```

with controlled methods:

```csharp
account.Deposit(500);
```

---

# Q5 — What is an Auto-Property?

## Answer

An auto-property is a shortcut where C# automatically creates the backing field.

Example:

```csharp
public class User
{
    public string Name { get; set; }
}
```

The compiler creates something similar internally:

```csharp
private string name;

public string Name
{
    get
    {
        return name;
    }

    set
    {
        name = value;
    }
}
```

---

# Q6 — What is the problem with public setters?

## Answer

A public setter allows uncontrolled state modification.

Example:

```csharp
public decimal Balance {get;set;}
```

Allows:

```csharp
account.Balance = -1000;
```

The object cannot protect its rules.

---

Better:

```csharp
public decimal Balance {get; private set;}
```

or:

```csharp
private decimal balance;

public void Deposit(decimal amount)
{
    balance += amount;
}
```

---

# Q7 — What is the difference between get and private set?

## Answer

Example:

```csharp
public decimal Salary { get; private set; }
```

Means:

Outside classes:

```csharp
employee.Salary
```

✅ Can read

```csharp
employee.Salary = 5000;
```

❌ Cannot modify

Only the class itself can change it.

---

# Q8 — When should you use a Property?

## Answer

Use properties for:

* Exposing object information.
* Simple data access.
* Values that do not represent complex actions.

Example:

```csharp
customer.Name

product.Price
```

---

# Q9 — When should you use a Method instead of a Property?

## Answer

Use methods when the operation:

* Performs an action.
* Changes state.
* Has validation.
* Represents business behavior.

Example:

Bad:

```csharp
account.Balance = account.Balance - 500;
```

Better:

```csharp
account.Withdraw(500);
```

Because withdrawal has rules.

---

# Q10 — Why is this design bad?

```csharp
public class BankAccount
{
    public decimal Balance {get;set;}
}
```

## Answer

Because the object exposes raw state.

Problems:

1. Anyone can modify balance.
2. No validation.
3. Business rules are outside.
4. Invalid states are possible.

Example:

```csharp
account.Balance = -5000;
```

---

# Q11 — How would you design a Product class?

## Weak Design

```csharp
public class Product
{
    public string Name {get;set;}

    public decimal Price {get;set;}
}
```

Problems:

* Price can be negative.
* State is uncontrolled.

---

## Better Design

```csharp
public class Product
{
    public string Name {get;}

    public decimal Price {get;}


    public Product(
        string name,
        decimal price)
    {
        if(price < 0)
            throw new Exception();

        Name = name;

        Price = price;
    }
}
```

---

# Q12 — Are properties always better than fields?

## Answer

No.

Fields are appropriate for internal implementation.

Example:

```csharp
private decimal balance;
```

The outside world does not need to know how balance is stored.

Properties are used when exposing information.

---

# Q13 — What is a readonly property?

## Answer

A property with only a getter.

Example:

```csharp
public string Id {get;}
```

The value can only be assigned during construction.

Example:

```csharp
public User(string id)
{
    Id = id;
}
```

After creation:

```csharp
user.Id = "new";
```

Not allowed.

---

# Q14 — What is the difference between readonly field and readonly property?

## Answer

Readonly field:

```csharp
private readonly string id;
```

The field value can only be assigned:

* At declaration.
* Inside constructor.

---

Readonly property:

```csharp
public string Id {get;}
```

The property exposes a value without allowing modification.

---

Common pattern:

```csharp
private readonly string id;


public string Id => id;
```

---

# Q15 — Should methods directly access fields or properties?

## Answer

Usually methods inside the class can access private fields directly.

Example:

```csharp
private decimal balance;


public void Deposit(decimal amount)
{
    balance += amount;
}
```

This avoids unnecessary logic.

But public behavior should go through the object's API.

---

# Q16 — What makes a good object API?

## Answer

A good API should:

### Be clear

Example:

```csharp
order.Cancel();
```

is clearer than:

```csharp
order.Status = 3;
```

---

### Protect rules

Example:

```csharp
account.Withdraw(500);
```

instead of:

```csharp
account.Balance -= 500;
```

---

### Express intent

The code should explain what is happening.

---

# Q17 — Explain this design

```csharp
public class TemperatureSensor
{
    private double temperature;


    public double Temperature
    {
        get
        {
            return temperature;
        }
    }


    public void UpdateTemperature(double value)
    {
        if(value < -100)
            throw new Exception();

        temperature = value;
    }
}
```

## Answer

This design uses encapsulation.

The object controls temperature changes.

External code:

Can:

```csharp
sensor.Temperature
```

Cannot:

```csharp
sensor.Temperature = -500;
```

The class protects its invariant.

---

# Q18 — What is the difference between changing data and performing behavior?

## Answer

Changing data:

```csharp
employee.Salary = 10000;
```

Only describes a value change.

Behavior:

```csharp
employee.Promote();
```

Describes a business action.

Methods are usually better when rules exist.

---

# Q19 — Why are properties not considered pure encapsulation by themselves?

## Answer

Because this:

```csharp
public int Age {get;set;}
```

still exposes unrestricted modification.

Real encapsulation requires:

* Controlled access.
* Validation.
* Protected state.
* Meaningful operations.

---

# Q20 — Senior Question

## Interviewer:

"Should I make all properties private?"

## Strong Answer:

No.

The goal is not hiding everything.

The goal is controlling access based on responsibility.

Expose information that consumers need, but protect state that requires rules.

Example:

```csharp
public decimal Balance {get;}
```

is useful.

But:

```csharp
public decimal Balance {get;set;}
```

may violate encapsulation.

---

# Common Mistakes

## Mistake 1

Making everything public:

```csharp
public string Password;
```

---

## Mistake 2

Using properties as simple data storage everywhere.

---

## Mistake 3

Replacing every method with setters.

Example:

```csharp
order.Status = "Paid";
```

instead of:

```csharp
order.Pay();
```

---

# Key Takeaways

```text
Field:

Internal storage


Property:

Controlled access


Method:

Behavior / Action


Good OOP:

Expose behavior

Protect state

Control changes
```

---

