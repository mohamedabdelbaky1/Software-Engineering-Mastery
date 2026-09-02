

# 🎤 Interview Questions 05 — Constructors

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What is a Constructor in C#?

## Answer

A constructor is a special method used to initialize an object when it is created.

It:

* Has the same name as the class.
* Has no return type.
* Runs automatically when using `new`.

Example:

```csharp
public class Employee
{
    public string Name { get; }


    public Employee(string name)
    {
        Name = name;
    }
}
```

Creating an object:

```csharp
Employee employee =
    new Employee("Ahmed");
```

The constructor executes automatically.

---

# Q2 — Why do we need constructors?

## Answer

Constructors ensure that objects start in a valid state.

Without constructor:

```csharp
Employee employee =
    new Employee();

employee.Name = "Ahmed";
```

The object exists before it is complete.

---

With constructor:

```csharp
Employee employee =
    new Employee("Ahmed");
```

The object is created with required data.

---

# Q3 — What happens when an object is created using `new`?

## Answer

Example:

```csharp
var account =
    new BankAccount();
```

The process:

```text
1. Allocate memory for object

2. Initialize fields

3. Execute constructor

4. Return object reference
```

Conceptually:

```text
Stack

account
   |
   |
   ↓

Heap

BankAccount Object
```

---

# Q4 — Can a class have multiple constructors?

## Answer

Yes.

This is called:

```text
Constructor Overloading
```

Example:

```csharp
public class User
{
    public string Name { get; }


    public User()
    {
        Name = "Unknown";
    }


    public User(string name)
    {
        Name = name;
    }
}
```

Usage:

```csharp
User user1 =
    new User();


User user2 =
    new User("Ahmed");
```

---

# Q5 — What is the default constructor?

## Answer

A parameterless constructor automatically created by the compiler if you do not define any constructor.

Example:

```csharp
public class Product
{

}
```

Compiler provides:

```csharp
public Product()
{

}
```

---

But:

If you create your own constructor:

```csharp
public Product(string name)
{

}
```

The compiler no longer creates the empty constructor.

---

# Q6 — Why can removing the default constructor break code?

## Answer

Before:

```csharp
Product product =
    new Product();
```

works.

Then:

```csharp
public Product(string name)
{

}
```

Now:

```csharp
new Product();
```

fails.

Because the parameterless constructor no longer exists.

---

# Q7 — What is a parameterized constructor?

## Answer

A constructor that receives values needed to create a valid object.

Example:

```csharp
public class BankAccount
{
    public string AccountNumber {get;}


    public decimal Balance {get;}



    public BankAccount(
        string accountNumber,
        decimal balance)
    {
        AccountNumber = accountNumber;
        Balance = balance;
    }
}
```

---

# Q8 — Should constructors contain validation?

## Answer

Yes, especially for maintaining object invariants.

Example:

Bad:

```csharp
public Product(
    string name,
    decimal price)
{
    Name = name;
    Price = price;
}
```

Allows:

```text
Price = -500
```

---

Better:

```csharp
public Product(
    string name,
    decimal price)
{
    if(price < 0)
        throw new Exception();

    Price = price;
}
```

---

# Q9 — What is an object invariant?

## Answer

An invariant is a rule that must always be true during the object's lifetime.

Example:

Bank Account:

```text
Balance cannot be negative
```

Product:

```text
Price cannot be negative
```

Order:

```text
Delivered order cannot return to Pending
```

Constructors establish the initial invariant.

---

# Q10 — Should constructors do too much work?

## Answer

Usually no.

A constructor should:

✅ Initialize state
✅ Validate input
✅ Establish invariants

Avoid:

❌ Database calls
❌ API calls
❌ Heavy calculations
❌ Sending emails

Example:

Bad:

```csharp
public Customer()
{
    Database.Save(this);
}
```

Why?

Because object creation now has hidden side effects.

---

# Q11 — What is constructor chaining?

## Answer

Calling one constructor from another using `this`.

Example:

```csharp
public class User
{
    public string Name {get;}


    public int Age {get;}



    public User()
        : this("Unknown",0)
    {

    }



    public User(
        string name,
        int age)
    {
        Name = name;
        Age = age;
    }
}
```

Benefits:

* Avoid duplicate initialization.
* Keep one source of construction logic.

---

# Q12 — What is constructor chaining with inheritance?

## Answer

Using `base` to call the parent constructor.

Example:

```csharp
public class Animal
{
    public string Name {get;}


    public Animal(string name)
    {
        Name = name;
    }
}
```

Child:

```csharp
public class Dog : Animal
{
    public Dog(string name)
        : base(name)
    {

    }
}
```

---

# Q13 — What happens if a constructor throws an exception?

## Answer

The object is not created.

Example:

```csharp
public Product(decimal price)
{
    if(price < 0)
        throw new Exception();
}
```

Usage:

```csharp
var product =
    new Product(-100);
```

Result:

```text
No Product object exists
```

The invalid object never enters the system.

---

# Q14 — Constructor vs Object Initializer?

## Answer

Object initializer:

```csharp
var user =
    new User
    {
        Name = "Ahmed"
    };
```

Constructor:

```csharp
var user =
    new User("Ahmed");
```

---

For required data:

Prefer constructor.

Example:

```text
User must have Email
```

Use:

```csharp
new User(email);
```

---

For optional properties:

Object initializer can be useful.

Example:

```csharp
new Product("Laptop")
{
    Description = "Gaming laptop"
};
```

---

# Q15 — Why are constructors important for encapsulation?

## Answer

Because they prevent incomplete objects.

Without constructor:

```text
Object created

↓

Missing data

↓

Invalid state
```

With constructor:

```text
Required data provided

↓

Validation

↓

Valid object
```

---

# Q16 — Should all properties be initialized in constructors?

## Answer

No.

Only required state.

Example:

Customer:

Required:

```text
Name
Email
```

Optional:

```text
Profile Picture
Address
```

Do not force unnecessary initialization.

---

# Q17 — What is a private constructor?

## Answer

A constructor accessible only inside the class.

Example:

```csharp
public class DatabaseConnection
{
    private DatabaseConnection()
    {

    }
}
```

Used for:

* Singleton patterns.
* Factory methods.
* Preventing direct creation.

---

# Q18 — What is a constructor's relationship with encapsulation?

## Answer

The constructor controls how an object enters the system.

Example:

Without:

```csharp
new BankAccount();
```

Object may be incomplete.

With:

```csharp
new BankAccount(
    "ACC100",
    5000);
```

Object guarantees validity.

---

# Q19 — Senior Design Question

## Interviewer:

"Would you prefer a constructor with 10 parameters or public setters?"

---

## Strong Answer:

Neither is automatically good.

A constructor should contain required state.

If there are too many parameters:

* The object may have too many responsibilities.
* A parameter object may be needed.
* The design may need reconsideration.

Public setters are usually worse because they allow invalid intermediate states.

---

# Q20 — Design a BankAccount Constructor

## Question:

How would you create a safe BankAccount?

---

## Weak:

```csharp
public class BankAccount
{
    public decimal Balance {get;set;}
}
```

---

## Better:

```csharp
public class BankAccount
{
    public string Number {get;}

    public decimal Balance {get; private set;}



    public BankAccount(
        string number,
        decimal balance)
    {
        if(balance < 0)
            throw new Exception();

        Number = number;
        Balance = balance;
    }
}
```

---

# Common Mistakes

## Mistake 1

Empty constructor everywhere:

```csharp
new Customer();
```

---

## Mistake 2

Constructor without validation:

```csharp
Price = -100;
```

---

## Mistake 3

Putting business operations inside constructors.

Example:

```text
Create Order

↓

Charge Credit Card

↓

Send Email
```

---

# Key Takeaways

```text
Constructor

=
Object Creation Gate


Good Constructor:

✔ Initializes required state

✔ Validates input

✔ Creates valid objects


Bad Constructor:

✘ Heavy operations

✘ Hidden side effects

✘ Allows invalid objects
```

---

