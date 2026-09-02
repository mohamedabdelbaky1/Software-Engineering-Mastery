

# 🎤 Interview Questions 02 — Classes and Objects

> **Module:** OOP Fundamentals
> **Level:** Beginner → Intermediate
> **Language:** C#

---

# Q1 — What is a Class in C#?

## Answer

A class is a blueprint that defines the structure and behavior of objects.

A class can contain:

* Fields
* Properties
* Methods
* Constructors
* Events

Example:

```csharp
public class Employee
{
    public string Name { get; }

    public void Work()
    {
        Console.WriteLine("Working...");
    }
}
```

The class describes what an employee object should have and what it can do.

---

# Q2 — What is an Object?

## Answer

An object is an actual instance created from a class.

Example:

Class:

```csharp
public class Employee
{
    public string Name { get; }
}
```

Object:

```csharp
Employee employee =
    new Employee();
```

The object exists in memory and contains actual values.

---

# Q3 — What is the relationship between Class and Object?

## Answer

The relationship is:

```text
Class
 |
 | creates
 ↓
Object
```

Example:

Class:

```csharp
Car
```

Objects:

```csharp
Car bmw = new Car();

Car audi = new Car();

Car tesla = new Car();
```

One class can create many objects.

---

# Q4 — Can multiple objects be created from the same class?

## Answer

Yes.

Each object has its own state.

Example:

```csharp
public class BankAccount
{
    public decimal Balance {get; private set;}
}
```

Creating objects:

```csharp
BankAccount account1 =
    new BankAccount();


BankAccount account2 =
    new BankAccount();
```

Memory:

```text
account1

Balance = 500


account2

Balance = 1000
```

Changing one object does not affect the other.

---

# Q5 — If two objects come from the same class, are they identical?

## Answer

No.

They share the same structure, but each object has:

* Different identity.
* Different state.

Example:

```csharp
Employee e1 =
    new Employee();


Employee e2 =
    new Employee();
```

Even though:

```text
Same Class
```

they are different objects.

---

# Q6 — What is Object Identity?

## Answer

Object identity means that every object is a unique entity in memory.

Example:

```csharp
Customer customer1 =
    new Customer();


Customer customer2 =
    new Customer();
```

They may have:

```text
Name = Ahmed
```

Both.

But:

```text
customer1 != customer2
```

because they are different objects.

---

# Q7 — What are the three characteristics of an object?

## Answer

Every object has:

---

## 1. Identity

What makes it unique.

Example:

```text
Customer ID
```

---

## 2. State

The current data of the object.

Example:

```text
Balance = 5000
```

---

## 3. Behavior

What the object can do.

Example:

```csharp
Withdraw();
Deposit();
```

---

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

Identity:

```text
Account Number
```

---

# Q8 — What happens when you create an object using new?

## Answer

When we write:

```csharp
Employee employee =
    new Employee();
```

Several things happen:

---

## Step 1

Memory is allocated for the object.

---

## Step 2

The constructor is executed.

---

## Step 3

The reference points to the object.

Conceptually:

```text
Stack

employee
   |
   |
   ↓

Heap

Employee Object
```

---

# Q9 — Where are objects stored in C#?

## Answer

Objects created with `new` are stored in managed heap memory.

The variable stores a reference to the object.

Example:

```csharp
Person person =
    new Person();
```

Conceptually:

```text
Stack:

person
  |
  |
Heap:

Person Object
```

---

# Q10 — What happens if two variables reference the same object?

## Answer

Both variables point to the same object.

Example:

```csharp
Person person1 =
    new Person();


Person person2 =
    person1;
```

Now:

```text
person1
   |
   |
   ↓

 Person Object

   ↑
   |
person2
```

Changing through one reference affects the same object.

---

Example:

```csharp
person1.Name = "Ahmed";


Console.WriteLine(person2.Name);
```

Output:

```text
Ahmed
```

Because they reference the same object.

---

# Q11 — What is the difference between creating an object and declaring a variable?

## Answer

Declaration:

```csharp
Employee employee;
```

Means:

A variable exists that can reference an employee.

No object exists yet.

---

Creation:

```csharp
employee =
    new Employee();
```

Creates the actual object.

---

Difference:

```text
Declaration:
Reference only


Creation:
Actual object in memory
```

---

# Q12 — Can a class exist without creating objects?

## Answer

Yes.

A class is only a definition.

Example:

```csharp
public class Product
{
    public string Name {get;}
}
```

Until:

```csharp
Product product =
    new Product();
```

No object exists.

---

# Q13 — Why should objects represent real concepts?

## Answer

Because good object modeling makes software easier to understand.

Bad:

```csharp
class DataManager
{

}
```

The responsibility is unclear.

Better:

```csharp
class Customer
{

}
```

The concept is clear.

---

# Q14 — How do you identify objects in a system?

## Answer

Analyze the problem domain.

Look for:

* Important entities.
* Things with state.
* Things with behavior.

Example: Banking System

Possible objects:

```text
Customer

Account

Transaction

Bank
```

---

# Q15 — What makes a class well-designed?

## Answer

A good class:

✅ Represents one clear concept
✅ Has meaningful state
✅ Owns related behavior
✅ Protects its data
✅ Creates valid objects

Example:

Good:

```csharp
account.Withdraw(500);
```

Weak:

```csharp
account.Balance -= 500;
```

---

# 🎯 Senior Interview Scenario

## Interviewer:

"Design a simple User class. What would you consider?"

---

## Strong Answer:

I would first identify:

### Identity:

```text
UserId
```

### State:

```text
Name
Email
Status
```

### Behavior:

```text
ChangePassword()

Activate()

Deactivate()
```

Then I would protect important state using encapsulation and validate object creation.

---

# Common Beginner Mistakes

---

## Mistake 1

Creating classes only as data containers.

```csharp
class User
{
    public string Name;
}
```

No behavior.

---

## Mistake 2

Making everything public.

```csharp
public string Password;
```

---

## Mistake 3

Using one giant class.

```text
ApplicationManager
```

that handles everything.

---

# Key Takeaways

```text
Class =
Blueprint


Object =
Instance


Object =
Identity
+
State
+
Behavior


Good OOP =
Objects that own responsibilities
```

---

