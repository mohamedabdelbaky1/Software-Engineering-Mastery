

# 🎤 Interview Questions 07 — Valid State and Invariants

> **Module:** OOP Fundamentals
> **Level:** Intermediate
> **Language:** C#

---

# Q1 — What does it mean for an object to be in a valid state?

## Answer

A valid state means that the object satisfies all rules required to represent a meaningful entity.

Example:

A bank account:

Valid:

```text
Account Number = ACC100

Balance = 5000

Status = Active
```

Invalid:

```text
Account Number = empty

Balance = -5000
```

A good object should not allow invalid states.

---

# Q2 — Why are valid objects important?

## Answer

Because other parts of the system can trust them.

Without validation:

```text
Create Object

↓

Check everywhere if it is valid

↓

Duplicate validation
```

With valid objects:

```text
Create Object

↓

Object guarantees correctness

↓

Use safely
```

---

# Q3 — What is an invariant?

## Answer

An invariant is a rule that must always remain true during the object's lifetime.

Example:

Bank Account:

```text
Balance >= 0
```

Product:

```text
Price >= 0
```

Order:

```text
Delivered orders cannot be modified
```

---

# Q4 — Where should invariants be protected?

## Answer

Inside the object that owns the state.

Example:

Wrong:

```csharp
public class BankService
{
    public void Withdraw(
        BankAccount account,
        decimal amount)
    {
        // validation here
    }
}
```

The service owns the rule.

---

Better:

```csharp
public class BankAccount
{
    private decimal balance;


    public void Withdraw(decimal amount)
    {
        if(amount > balance)
            throw new Exception();

        balance -= amount;
    }
}
```

The account protects itself.

---

# Q5 — How do constructors help maintain valid state?

## Answer

Constructors establish the initial valid state.

Example:

Bad:

```csharp
var product =
    new Product();

product.Price = -100;
```

The object exists in an invalid state.

---

Better:

```csharp
var product =
    new Product(
        "Laptop",
        2000);
```

The constructor validates before creation.

---

# Q6 — What is the relationship between encapsulation and valid state?

## Answer

Encapsulation protects the rules that maintain valid state.

Example:

Without encapsulation:

```csharp
account.Balance = -500;
```

Invalid state.

With encapsulation:

```csharp
account.Withdraw(500);
```

The object decides whether the operation is allowed.

---

# Q7 — What is an invalid state example?

## Answer

Example:

```csharp
public class Employee
{
    public decimal Salary {get;set;}
}
```

Possible:

```csharp
employee.Salary = -1000;
```

An employee cannot have a negative salary.

The class failed to protect its invariant.

---

# Q8 — How do you design objects that cannot enter invalid states?

## Answer

Use:

### 1. Constructor validation

```csharp
public Product(
    decimal price)
{
    if(price < 0)
        throw new Exception();
}
```

---

### 2. Private setters

```csharp
public decimal Price 
{
    get;
    private set;
}
```

---

### 3. Controlled methods

```csharp
product.ChangePrice(100);
```

instead of:

```csharp
product.Price = 100;
```

---

# Q9 — Should every property validate its value?

## Answer

Not always.

Simple values:

```csharp
public string Name {get;}
```

may only need constructor validation.

Complex business rules should usually be inside methods.

Example:

Good:

```csharp
order.Cancel();
```

instead of:

```csharp
order.Status = Cancelled;
```

---

# Q10 — What is the difference between validation and business rules?

## Answer

Validation:

Checks if data is acceptable.

Example:

```text
Price cannot be negative
```

Business rule:

Defines how the system behaves.

Example:

```text
Delivered orders cannot be cancelled
```

---

# Q11 — Where should validation happen?

## Answer

Near the object that owns the rule.

Example:

Product:

```text
Price validation
```

belongs to:

```text
Product
```

Order:

```text
Cancellation rules
```

belong to:

```text
Order
```

---

# Q12 — Why are public setters dangerous for invariants?

## Answer

Because they allow uncontrolled changes.

Example:

```csharp
public class Order
{
    public string Status {get;set;}
}
```

Anyone can do:

```csharp
order.Status = "Delivered";
```

without checking:

* Payment
* Shipping
* Delivery

---

# Q13 — Explain this design problem

```csharp
public class Customer
{
    public string Email {get;set;}
}
```

## Problem

Email can become:

```text
empty

invalid format
```

The object cannot guarantee correctness.

---

Better:

```csharp
public class Customer
{
    public string Email {get;}


    public Customer(string email)
    {
        ValidateEmail(email);

        Email = email;
    }
}
```

---

# Q14 — What is a "Trustworthy Object"?

## Answer

A trustworthy object is one that:

* Starts valid.
* Protects its state.
* Controls changes.
* Maintains its rules.

Example:

```text
BankAccount

You trust:

Balance is valid

Withdraw rules are applied

State is consistent
```

---

# Q15 — Can an object temporarily enter an invalid state?

## Answer

Ideally no.

A strong object design avoids invalid intermediate states.

Bad:

```csharp
User user =
    new User();

user.Name = "Ahmed";

user.Email = "test@test.com";
```

Between creation and assignment:

```text
Invalid User
```

---

Better:

```csharp
User user =
    new User(
        "Ahmed",
        "test@test.com");
```

---

# Q16 — What is the difference between state and valid state?

## Answer

State:

Current values of the object.

Example:

```text
Balance = 500
```

Valid state:

State that follows business rules.

Example:

```text
Balance >= 0
```

---

# Q17 — Design Question

## Interviewer:

Design a Shopping Cart that cannot become invalid.

---

## Strong Answer:

Identify invariants:

```text
Cart cannot contain null products

Quantity must be positive

Price cannot be negative
```

Implementation:

```csharp
public class CartItem
{
    public int Quantity {get;}


    public CartItem(int quantity)
    {
        if(quantity <= 0)
            throw new Exception();

        Quantity = quantity;
    }
}
```

---

# Q18 — What happens if validation is duplicated everywhere?

## Answer

Problems:

* Code duplication.
* Different rules in different places.
* Bugs.

Example:

```text
CheckoutService

validates price


ReportService

validates price differently
```

The rule should have one owner.

---

# Q19 — Senior Question

## Interviewer:

"Is making fields private enough to guarantee valid state?"

## Strong Answer:

No.

Private fields are only one part of the solution.

A complete solution requires:

* Controlled access.
* Validation.
* Correct behavior placement.
* Protected transitions.

---

# Q20 — Senior Design Scenario

## Interviewer:

A developer says:

"I will create simple classes and validate everything in services."

Do you agree?

---

## Strong Answer:

No.

Services may coordinate workflows, but objects should protect their own invariants.

Otherwise:

* Objects become data containers.
* Rules become scattered.
* The system becomes harder to maintain.

---

# Common Mistakes

## Mistake 1

Creating empty objects.

```csharp
new Customer();
```

---

## Mistake 2

Allowing unrestricted modification.

```csharp
public decimal Balance {get;set;}
```

---

## Mistake 3

Putting all validation in controllers/services.

---

## Mistake 4

Having multiple places enforce the same rule.

---

# Key Takeaways

```text
Good Object Design:

Object starts valid

↓

Object protects invariants

↓

Object controls transitions

↓

Object remains trustworthy
```

---

