

# 🎤 Interview Questions 08 — Encapsulation

> **Module:** OOP Fundamentals
> **Level:** Intermediate → Advanced
> **Language:** C#

---

# Q1 — What is Encapsulation in OOP?

## Answer

Encapsulation is the principle of:

* Hiding internal object details.
* Protecting object state.
* Providing controlled access through a public interface.

In simple words:

```text
Internal implementation
        ↓
Hidden

Allowed operations
        ↓
Exposed
```

Example:

```csharp
public class BankAccount
{
    private decimal balance;


    public void Deposit(decimal amount)
    {
        if(amount <= 0)
            throw new Exception();

        balance += amount;
    }
}
```

The outside world does not directly modify `balance`.

---

# Q2 — Is Encapsulation just making fields private?

## Answer

No.

This is one of the most common interview traps.

Bad understanding:

```text
Encapsulation = private fields
```

Wrong.

Example:

```csharp
public class BankAccount
{
    private decimal balance;


    public decimal Balance
    {
        get;
        set;
    }
}
```

The field is private, but anyone can still do:

```csharp
account.Balance = -5000;
```

No real protection exists.

---

Real encapsulation means:

```text
Hide state

+

Protect rules

+

Control modifications
```

---

# Q3 — Why do we need Encapsulation?

## Answer

Encapsulation solves several problems:

---

## 1. Prevent Invalid State

Without encapsulation:

```csharp
account.Balance = -1000;
```

Possible.

---

With encapsulation:

```csharp
account.Withdraw(1000);
```

The object validates the operation.

---

## 2. Reduce Coupling

External code does not depend on internal implementation.

Example:

Today:

```csharp
private decimal balance;
```

Tomorrow:

```csharp
private Money balance;
```

The external API remains:

```csharp
account.GetBalance();
```

---

## 3. Centralize Rules

Instead of:

```text
Controller validates balance

Service validates balance

UI validates balance
```

The object owns the rule.

---

# Q4 — What is the difference between Data Hiding and Encapsulation?

## Answer

They are related but not identical.

---

## Data Hiding

Means:

Prevent direct access to internal data.

Example:

```csharp
private decimal balance;
```

---

## Encapsulation

A bigger concept:

```text
Data hiding

+

Behavior protection

+

Controlled access
```

Example:

```csharp
account.Withdraw(500);
```

The object decides whether withdrawal is allowed.

---

# Q5 — Explain Encapsulation using a Real-World Example.

## Answer

ATM machine.

The user does not directly access:

* Bank database.
* Account records.
* Transaction system.

The user only uses:

```text
Insert Card

Enter PIN

Withdraw Money
```

The ATM hides complexity and exposes controlled operations.

Same idea in OOP.

---

# Q6 — What does a well-encapsulated class look like?

## Answer

Example:

```csharp
public class Wallet
{
    private decimal balance;


    public decimal Balance => balance;


    public void AddMoney(decimal amount)
    {
        if(amount <= 0)
            throw new Exception();

        balance += amount;
    }


    public void Spend(decimal amount)
    {
        if(amount > balance)
            throw new Exception();

        balance -= amount;
    }
}
```

Characteristics:

✅ Internal state hidden
✅ Rules protected
✅ Behavior exposed
✅ Invalid operations prevented

---

# Q7 — Why are public fields considered bad practice?

## Answer

Example:

```csharp
public class User
{
    public string Password;
}
```

Problems:

* Anyone can modify it.
* No validation.
* No security control.
* Implementation is exposed.

Better:

```csharp
private string password;


public void ChangePassword(string value)
{
    ValidatePassword(value);

    password = value;
}
```

---

# Q8 — Why is this not good encapsulation?

```csharp
public class Customer
{
    public string Name { get; set; }

    public decimal Balance { get; set; }
}
```

## Answer

Because external code controls the object's state.

Example:

```csharp
customer.Balance = -500;
```

The object cannot protect itself.

---

Better:

```csharp
public class Customer
{
    private decimal balance;


    public decimal Balance => balance;


    public void Deposit(decimal amount)
    {
        balance += amount;
    }
}
```

---

# Q9 — What is a public API of an object?

## Answer

The public API is everything other objects can interact with.

Example:

```csharp
public class Order
{
    public void Pay()
    {

    }

    public void Cancel()
    {

    }
}
```

Public API:

```text
Pay()

Cancel()
```

Internal details:

```text
CalculateTax()

UpdateDatabase()

ValidatePayment()
```

should remain hidden.

---

# Q10 — How does Encapsulation reduce complexity?

## Answer

Without encapsulation:

Every caller must understand:

* Internal data.
* Rules.
* Valid states.

Example:

```text
100 classes
+
100 different validations
```

With encapsulation:

```text
Object owns rules
```

Other code only calls:

```csharp
order.Pay();
```

---

# Q11 — What is the difference between exposing data and exposing behavior?

## Answer

Exposing data:

```csharp
account.Balance = 5000;
```

The caller controls the state.

---

Exposing behavior:

```csharp
account.Deposit(5000);
```

The object controls the operation.

---

Professional OOP prefers exposing behavior.

---

# Q12 — Why are methods often better than setters?

## Answer

Because methods communicate intent and can contain rules.

Example:

Weak:

```csharp
order.Status = "Paid";
```

Questions:

* Is payment successful?
* Is order already cancelled?

---

Better:

```csharp
order.Pay();
```

The object handles the rules.

---

# Q13 — Can properties be part of encapsulation?

## Answer

Yes.

Example:

Read-only property:

```csharp
public decimal Balance { get; }
```

Allows:

```csharp
account.Balance
```

But prevents:

```csharp
account.Balance = 1000;
```

---

# Q14 — What is the difference between these two designs?

## Design A

```csharp
public decimal Balance {get;set;}
```

## Design B

```csharp
public decimal Balance {get;private set;}
```

---

## Answer

Design A:

Anyone can change balance.

```csharp
account.Balance = 0;
```

---

Design B:

Only the class can change it.

```csharp
Deposit()

Withdraw()
```

maintain control.

---

# Q15 — What is "Tell, Don't Ask" principle?

## Answer

It means:

Tell objects what to do instead of asking for data and manipulating it externally.

---

Bad:

```csharp
if(account.Balance > 100)
{
    account.Balance -= 100;
}
```

External code controls logic.

---

Better:

```csharp
account.Withdraw(100);
```

The account decides.

---

# Q16 — How does Encapsulation improve maintainability?

## Answer

Because internal changes do not affect external code.

Example:

Before:

```csharp
public decimal Balance;
```

Everyone depends on the implementation.

---

After:

```csharp
public decimal GetBalance();
```

Internal storage can change.

---

# Q17 — Design Question

## Interviewer:

Design a ShoppingCart with proper encapsulation.

---

## Weak Design:

```csharp
public class ShoppingCart
{
    public List<Product> Items {get;set;}
}
```

Problem:

Anyone can:

```csharp
cart.Items.Clear();
```

---

## Better:

```csharp
public class ShoppingCart
{
    private readonly List<Product> items =
        new();


    public IReadOnlyList<Product> Items =>
        items;


    public void Add(Product product)
    {
        items.Add(product);
    }
}
```

---

# Q18 — Does Encapsulation mean hiding everything?

## Answer

No.

Encapsulation is not about maximum hiding.

It is about:

> Exposing the right things and hiding the dangerous things.

Example:

Expose:

```csharp
order.Pay();
```

Hide:

```csharp
CalculatePaymentHash();
```

---

# Q19 — Senior Question

## Interviewer:

"Why is this class poorly designed?"

```csharp
public class User
{
    public string PasswordHash {get;set;}
}
```

---

## Strong Answer:

Because it exposes sensitive internal state.

The class should control password changes.

Example:

```csharp
user.ChangePassword(newPassword);
```

The object can:

* Validate rules.
* Hash password.
* Maintain security.

---

# Q20 — Senior Design Question

## Interviewer:

"When should a class expose a setter?"

## Strong Answer:

Only when external modification is safe and does not violate invariants.

Example:

Acceptable:

```csharp
public string Description {get;set;}
```

Possibly dangerous:

```csharp
public decimal Balance {get;set;}
```

because changing it requires business rules.

---

# Common Mistakes

## Mistake 1

Thinking:

```text
private = encapsulation
```

---

## Mistake 2

Creating classes with only getters/setters.

---

## Mistake 3

Moving all logic to services.

---

## Mistake 4

Exposing collections directly.

Bad:

```csharp
public List<Order> Orders;
```

Better:

```csharp
public IReadOnlyList<Order> Orders;
```

---

# Key Takeaways

```text
Encapsulation =

Protect state

+

Control behavior

+

Expose meaningful operations


Good Object:

"I control myself"


Bad Object:

"Everyone can modify me"
```

---

