

# 🎤 Interview Questions 06 — Access Modifiers

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What are Access Modifiers in C#?

## Answer

Access modifiers define the accessibility level of classes, fields, properties, and methods.

They answer:

> "Who is allowed to access this member?"

The main access modifiers are:

```text id="q5n8s3"
public
private
protected
internal
protected internal
private protected
```

---

# Q2 — What is the purpose of Access Modifiers?

## Answer

The main purpose is:

* Encapsulation.
* Protecting internal implementation.
* Controlling dependencies.
* Defining class boundaries.

Example:

Bad:

```csharp id="u7x2p4"
public decimal balance;
```

Anyone can modify it.

Better:

```csharp id="m8q4x1"
private decimal balance;
```

Only the class controls it.

---

# Q3 — Explain the `public` modifier.

## Answer

`public` means:

> Accessible from anywhere.

Example:

```csharp id="h9p2m6"
public class Customer
{
    public string Name;
}
```

Usage:

```csharp id="x3m7q8"
Customer customer =
    new Customer();


customer.Name = "Ahmed";
```

---

## When to use public?

For members that are part of the object's external API.

Example:

```csharp id="b5n8v2"
account.Deposit(500);
```

The operation is intentionally exposed.

---

# Q4 — Explain the `private` modifier.

## Answer

`private` means:

> Accessible only inside the same class.

Example:

```csharp id="k4m9x2"
public class BankAccount
{
    private decimal balance;
}
```

External code cannot:

```csharp id="7q2m5a"
account.balance = 1000;
```

---

# Why is private important?

Because it protects internal state.

Example:

```csharp id="s8x1m4"
public class BankAccount
{
    private decimal balance;


    public void Deposit(decimal amount)
    {
        if(amount > 0)
        {
            balance += amount;
        }
    }
}
```

The class controls the rules.

---

# Q5 — What is the default access modifier for class members?

## Answer

For class members:

```csharp id="9k2x6p"
private
```

is the default.

Example:

```csharp id="c3m7q1"
class User
{
    string name;
}
```

Equivalent to:

```csharp id="d8m4x2"
class User
{
    private string name;
}
```

---

# Q6 — What is the default access modifier for a class?

## Answer

A top-level class is:

```csharp id="q7x9m3"
internal
```

by default.

Example:

```csharp id="n4p8x1"
class Customer
{

}
```

Equivalent:

```csharp id="2m6q9v"
internal class Customer
{

}
```

---

# Q7 — Explain the `protected` modifier.

## Answer

`protected` means:

> Accessible inside the class and derived classes.

Example:

```csharp id="f8m2x5"
public class Animal
{
    protected string Name;
}
```

Child class:

```csharp id="w5q8m1"
public class Dog : Animal
{
    public void PrintName()
    {
        Console.WriteLine(Name);
    }
}
```

---

# Q8 — What is the difference between private and protected?

## Answer

| private              | protected                       |
| -------------------- | ------------------------------- |
| Only same class      | Same class + child classes      |
| Stronger hiding      | Allows inheritance access       |
| Better encapsulation | Useful in inheritance scenarios |

---

Example:

Private:

```text id="z3m8x4"
Parent Class

✔ Access

Child Class

✘ Access
```

Protected:

```text id="p6x2m9"
Parent Class

✔ Access

Child Class

✔ Access
```

---

# Q9 — Explain the `internal` modifier.

## Answer

`internal` means:

> Accessible only within the same assembly/project.

Example:

```csharp id="v4m7x2"
internal class PaymentService
{

}
```

Another project cannot access it.

---

Common usage:

* Hide implementation details.
* Keep public API small.

---

# Q10 — public vs internal?

## Answer

`public`:

```text id="j9m3x6"
Available everywhere
```

`internal`:

```text id="w2q8m4"
Available only inside the project
```

Example:

Public:

```csharp id="7x5m1q"
public class Customer
```

Internal:

```csharp id="8n4p2z"
internal class DatabaseHelper
```

---

# Q11 — Why should we avoid making everything public?

## Answer

Because it creates uncontrolled access.

Example:

Bad:

```csharp id="s6q9m2"
public class User
{
    public string Password;
}
```

Problems:

* Anyone can change it.
* No validation.
* Security risk.

---

Better:

```csharp id="x8m3q7"
private string password;


public void ChangePassword(string newPassword)
{
    // validation
}
```

---

# Q12 — How do access modifiers support encapsulation?

## Answer

Encapsulation requires:

1. Hide internal state.
2. Expose controlled operations.

Example:

```csharp id="y5m8q1"
public class Wallet
{
    private decimal balance;


    public decimal Balance => balance;


    public void AddMoney(decimal amount)
    {
        balance += amount;
    }
}
```

Outside code:

Can:

```csharp id="a4m7x9"
wallet.AddMoney(100);
```

Cannot:

```csharp id="n8q2m5"
wallet.balance = -500;
```

---

# Q13 — Why are private fields commonly combined with public properties?

## Answer

Pattern:

```csharp id="m7x4q8"
private string name;


public string Name
{
    get
    {
        return name;
    }
}
```

Benefits:

* Internal storage is hidden.
* Reading is allowed.
* Modification is controlled.

---

# Q14 — What is `private set`?

## Answer

A property where:

* Everyone can read.
* Only the class can modify.

Example:

```csharp id="r2m8x5"
public class Employee
{
    public decimal Salary
    {
        get;
        private set;
    }
}
```

Outside:

```csharp id="q6m1x9"
employee.Salary
```

Allowed.

```csharp id="z8p4m2"
employee.Salary = 5000;
```

Not allowed.

---

# Q15 — Why is `private set` useful?

## Answer

It allows controlled mutation.

Example:

```csharp id="w3m7q2"
public class Employee
{
    public decimal Salary {get; private set;}


    public void IncreaseSalary(decimal amount)
    {
        Salary += amount;
    }
}
```

The class controls salary changes.

---

# Q16 — Should fields ever be public?

## Answer

Usually no.

Public fields expose implementation details.

Bad:

```csharp id="h4m8x2"
public int age;
```

Better:

```csharp id="p7q3m9"
public int Age {get;}
```

or:

```csharp id="v5m1x8"
public void UpdateAge(int age)
```

---

# Q17 — How do you decide what should be public?

## Answer

Ask:

> Does the outside world need this?

Expose:

* Necessary behavior.
* Required information.

Hide:

* Internal calculations.
* Internal state.
* Helper methods.

---

Example:

Good:

```csharp id="n2x7m4"
order.Pay();
```

Hidden:

```csharp id="c8m3q5"
CalculateTaxInternally();
```

---

# Q18 — Design Question

## Interviewer:

Design a BankAccount class. What should be private and public?

---

## Strong Answer:

Private:

```text id="f5m8q2"
Balance storage

Transaction logic
```

Public:

```text id="x7q3m9"
Deposit()

Withdraw()

Balance getter
```

Example:

```csharp id="h2m9x5"
public class BankAccount
{
    private decimal balance;


    public decimal Balance => balance;


    public void Deposit(decimal amount)
    {

    }
}
```

---

# Q19 — Why is encapsulation not just making fields private?

## Answer

Because this:

```csharp id="u8m2x6"
private decimal balance;


public decimal Balance
{
    get;
    set;
}
```

still allows uncontrolled modification.

Real encapsulation means:

```text id="p4m7x1"
Hide state

+

Protect rules

+

Control behavior
```

---

# Q20 — Senior Question

## Interviewer:

"Should everything be private by default?"

## Strong Answer:

Yes, as a starting point.

Then expose only what the object needs to provide as part of its public contract.

This minimizes coupling and protects the design.

---

# Common Mistakes

## Mistake 1

Making all properties public:

```csharp
public int Age {get;set;}
```

---

## Mistake 2

Using protected everywhere in inheritance.

---

## Mistake 3

Exposing implementation details:

```csharp
public List<Order> Orders;
```

---

# Key Takeaways

```text id="r9m4x7"
public:

External API


private:

Internal implementation


protected:

Inheritance access


internal:

Same project access


Good OOP:

Expose what is needed

Hide what should be protected
```

---

