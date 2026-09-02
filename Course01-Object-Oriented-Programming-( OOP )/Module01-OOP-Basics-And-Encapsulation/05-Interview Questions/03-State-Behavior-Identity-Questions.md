

# 🎤 Interview Questions 03 — State, Behavior, Identity

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What are State, Behavior, and Identity in OOP?

## Answer

Every object can be described using three characteristics:

```text
Object

+
|
├── Identity
|
├── State
|
└── Behavior
```

---

## Identity

Defines what makes an object unique.

Example:

```text
Bank Account

Account Number:
ACC-10001
```

Two accounts may have:

```text
Balance = 5000
```

but different account numbers.

They are different objects.

---

## State

Represents the current condition of an object.

Example:

```text
Bank Account

Balance = 5000
Status = Active
```

State can change over time.

---

## Behavior

Represents what the object can do.

Example:

```csharp
account.Deposit(1000);

account.Withdraw(500);
```

---

# Q2 — Why is Identity important?

## Answer

Identity allows us to distinguish between objects even when their state is identical.

Example:

```csharp
Customer customer1 =
    new Customer();


Customer customer2 =
    new Customer();
```

Both may have:

```text
Name = Ahmed
```

But:

```text
customer1 ≠ customer2
```

because they are different entities.

---

# Q3 — What is the difference between State and Identity?

## Answer

Identity answers:

> "Which object is this?"

State answers:

> "What condition is this object currently in?"

Example:

```text
Employee

Identity:
Employee ID = 101


State:
Salary = 5000
Status = Active
```

Salary can change.

Employee ID usually remains.

---

# Q4 — Can two objects have the same state but different identities?

## Answer

Yes.

Example:

```csharp
Car car1 =
    new Car();


Car car2 =
    new Car();
```

Both:

```text
Brand = BMW
Model = M3
```

But:

```text
car1
```

and

```text
car2
```

are different objects.

---

# Q5 — Can an object's state change without changing its identity?

## Answer

Yes.

This is normal object behavior.

Example:

```csharp
BankAccount account =
    new BankAccount();
```

Initial state:

```text
Balance = 1000
```

After:

```csharp
account.Deposit(500);
```

New state:

```text
Balance = 1500
```

Identity:

```text
Same account
```

---

# Q6 — What is the difference between State and Behavior?

## Answer

State:

```text
What the object has
```

Behavior:

```text
What the object does
```

Example:

```csharp
public class BankAccount
{
    private decimal balance;


    public void Deposit(decimal amount)
    {
        balance += amount;
    }
}
```

State:

```text
balance
```

Behavior:

```text
Deposit()
```

---

# Q7 — Why should behavior live with the object that owns the state?

## Answer

Because the object knows its own rules.

Bad design:

```csharp
BankService.Deposit(account,1000);
```

The service manipulates account data.

Better:

```csharp
account.Deposit(1000);
```

The account controls its state.

---

# Q8 — What is an anemic object?

## Answer

An anemic object is an object that contains only data with little or no behavior.

Example:

```csharp
public class Customer
{
    public string Name {get;set;}

    public decimal Balance {get;set;}
}
```

Problems:

* Rules move outside the object.
* Validation becomes duplicated.
* Object has no responsibility.

---

Better:

```csharp
public class Customer
{
    private decimal balance;


    public void Pay(decimal amount)
    {
        if(amount <= 0)
            throw new Exception();

        balance -= amount;
    }
}
```

---

# Q9 — How do you identify an object's state?

## Answer

Ask:

> "What information describes this object at a specific moment?"

Example:

For a car:

State:

```text
Brand
Model
Speed
Engine Status
```

For an order:

State:

```text
Items
Total
Status
Customer
```

---

# Q10 — How do you identify an object's behavior?

## Answer

Ask:

> "What actions does this object naturally perform?"

Example:

Car:

```text
Start()
Accelerate()
Brake()
```

Bank Account:

```text
Deposit()
Withdraw()
Transfer()
```

Order:

```text
Pay()
Ship()
Cancel()
```

---

# Q11 — Should every noun become a class?

## Answer

No.

This is a common beginner mistake.

Not every noun needs to become an object.

Example:

Requirement:

> "The customer places an order using a website."

Possible classes:

```text
Customer

Order
```

But:

```text
Website
```

may not necessarily be a domain object.

You must identify meaningful responsibilities.

---

# Q12 — Should every behavior become a method?

## Answer

No.

A method should represent meaningful behavior.

Bad:

```csharp
customer.ChangeNameValue();
```

Better:

```csharp
customer.ChangeName("Ahmed");
```

The method should communicate intent.

---

# Q13 — How would you model a Bank Account object?

## Answer

First identify:

## Identity

```text
Account Number
```

---

## State

```text
Balance
Owner
Status
```

---

## Behavior

```text
Deposit()

Withdraw()

Transfer()
```

Example:

```csharp
public class BankAccount
{
    private decimal balance;


    public void Deposit(decimal amount)
    {
        balance += amount;
    }
}
```

---

# Q14 — How would you model an Order object?

## Answer

Identity:

```text
Order ID
```

State:

```text
Items
Status
Customer
```

Behavior:

```text
AddItem()

RemoveItem()

Pay()

Cancel()
```

Important:

The order should control its lifecycle.

---

# Q15 — What happens when behavior is placed in the wrong object?

## Answer

The design becomes harder to maintain.

Example:

Bad:

```text
OrderService

calculates order total

changes order status

validates products
```

Problems:

* Order becomes passive.
* Rules are scattered.
* Changes become risky.

Better:

```text
Order

owns order behavior
```

---

# 🎯 Senior Interview Scenario

## Interviewer:

"You are designing a payment system. How do you find objects?"

---

## Strong Answer:

I start by identifying domain concepts.

Possible objects:

```text
Payment

Customer

Transaction

PaymentMethod
```

For each object I define:

### Identity

What uniquely identifies it?

### State

What information does it own?

### Behavior

What operations belong to it?

Then I decide relationships and responsibilities.

---

# Common Mistakes

---

## Mistake 1

Creating classes only from database tables.

Example:

```text
CustomerTable
OrderTable
```

Database structure is not always object design.

---

## Mistake 2

Putting all logic in services.

Example:

```text
OrderService
```

doing everything.

---

## Mistake 3

Making objects only properties.

Example:

```csharp
class Product
{
    public decimal Price {get;set;}
}
```

No rules.

---

# Key Takeaways

```text
Object =

Identity
+
State
+
Behavior


Good OOP:

Objects own their state

Objects control their behavior

Objects protect their rules
```

---

