

# 🎤 Interview Questions 09 — C# OOP Specific Questions

> **Module:** OOP Fundamentals
> **Level:** Intermediate → Advanced
> **Language:** C#

---

# Q1 — Is a Class a Reference Type or Value Type in C#?

## Answer

A class is a **reference type**.

Example:

```csharp
public class Person
{
    public string Name { get; set; }
}
```

When creating:

```csharp
Person person1 =
    new Person();

Person person2 =
    person1;
```

Both variables reference the same object.

Conceptually:

```
Stack

person1 ───┐
           |
           ↓

        Person Object

           ↑
           |
person2 ───┘
```

Changing through one reference affects the same object.

---

Example:

```csharp
person1.Name = "Ahmed";

Console.WriteLine(person2.Name);
```

Output:

```
Ahmed
```

---

# Q2 — What is the difference between Reference Type and Value Type?

## Answer

## Value Type

Stores the actual value.

Examples:

```csharp
int
double
bool
struct
```

Example:

```csharp
int x = 10;

int y = x;

y = 20;
```

Result:

```
x = 10

y = 20
```

They are independent.

---

## Reference Type

Stores a reference to an object.

Examples:

```csharp
class
interface
array
string
```

Example:

```csharp
Person p1 =
    new Person();


Person p2 =
    p1;
```

Both point to the same object.

---

# Q3 — What is the difference between Class and Struct in C#?

## Answer

Both can contain:

* Fields
* Properties
* Methods
* Constructors

But they differ fundamentally.

| Class                    | Struct                             |
| ------------------------ | ---------------------------------- |
| Reference type           | Value type                         |
| Heap allocation          | Usually stack-like behavior        |
| Supports inheritance     | Does not support class inheritance |
| Good for complex objects | Good for small data values         |

---

Example:

Struct:

```csharp
public struct Point
{
    public int X;
    public int Y;
}
```

Good usage:

```text
Coordinates
Small measurements
```

---

Class:

```csharp
public class Customer
{

}
```

Good usage:

```text
Business entities
Complex objects
```

---

# Q4 — Why are classes usually preferred for business objects?

## Answer

Because business objects usually have:

* Identity.
* Mutable state.
* Complex behavior.

Example:

Bank Account:

```
Account Number
Balance
Transactions
Rules
```

This represents an entity.

A class fits this model.

---

# Q5 — What is object identity in C#?

## Answer

For reference types, identity means the object instance itself.

Example:

```csharp
Person p1 =
    new Person();


Person p2 =
    new Person();
```

Even if:

```text
Name = Ahmed
```

They are different objects.

Check:

```csharp
Console.WriteLine(
    ReferenceEquals(p1,p2));
```

Output:

```
False
```

---

# Q6 — What happens when you assign one object variable to another?

## Answer

You copy the reference, not the object.

Example:

```csharp
Person p1 =
    new Person();


Person p2 = p1;
```

Memory:

```
p1 ──┐
     ↓
  Object
     ↑
p2 ──┘
```

There is only one object.

---

# Q7 — What is object cloning?

## Answer

Creating a separate object with the same data.

Example:

```csharp
Person p2 =
    new Person
    {
        Name = p1.Name
    };
```

Now:

```
p1 → Object A

p2 → Object B
```

Changing one does not affect the other.

---

# Q8 — What is the difference between `==` and `ReferenceEquals()` for objects?

## Answer

For reference types:

`ReferenceEquals()` checks:

> Are these the exact same object?

Example:

```csharp
ReferenceEquals(a,b);
```

---

`==` depends on implementation.

For classes, it can be overloaded.

Example:

```csharp
public override bool Equals(object obj)
{

}
```

The meaning can change.

---

# Q9 — What is the difference between Object State and Object Reference?

## Answer

Reference:

Points to the object.

Example:

```csharp
Person person;
```

State:

The values inside the object.

Example:

```text
Name = Ahmed
Age = 25
```

---

# Q10 — What is an immutable object?

## Answer

An immutable object cannot change after creation.

Example:

```csharp
public class Money
{
    public decimal Amount { get; }


    public Money(decimal amount)
    {
        Amount = amount;
    }
}
```

After creation:

```csharp
money.Amount = 500;
```

Not possible.

---

Benefits:

* Safer code.
* Easier debugging.
* Thread safety.

---

# Q11 — Why is immutability useful in OOP?

## Answer

Because objects cannot unexpectedly change.

Mutable:

```
Object created

↓

Many places modify it

↓

Hard to track
```

Immutable:

```
Object created

↓

State never changes

↓

Predictable behavior
```

---

# Q12 — What is the difference between `readonly` field and `const`?

## Answer

## const

Compile-time constant.

Example:

```csharp
public const double Pi = 3.14;
```

Must have a value immediately.

---

## readonly

Assigned during construction.

Example:

```csharp
public readonly string Id;


public User(string id)
{
    Id = id;
}
```

---

Difference:

| const            | readonly         |
| ---------------- | ---------------- |
| Compile time     | Runtime          |
| Fixed everywhere | Fixed per object |

---

# Q13 — Can readonly objects still change?

## Answer

Yes, depending on what is readonly.

Example:

```csharp
readonly Person person;
```

means:

The reference cannot change.

But:

```csharp
person.Name = "Ahmed";
```

may still be possible.

Because:

```
Reference is readonly

Object is mutable
```

---

# Q14 — What is the difference between `readonly` and immutability?

## Answer

Readonly:

Protects a reference or field assignment.

Immutability:

Protects the entire object's state.

Example:

Readonly:

```csharp
readonly List<int> numbers;
```

The list reference cannot change:

```csharp
numbers = new List<int>();
```

but:

```csharp
numbers.Add(5);
```

is possible.

---

# Q15 — What are access modifiers commonly used for in OOP?

## Answer

They define object boundaries.

Example:

```csharp
public class BankAccount
{
    private decimal balance;


    public void Deposit(decimal amount)
    {

    }
}
```

Public:

```
External API
```

Private:

```
Internal implementation
```

---

# Q16 — Why should we avoid exposing collections?

## Answer

Bad:

```csharp
public List<Order> Orders {get;set;}
```

Allows:

```csharp
customer.Orders.Clear();
```

The object loses control.

---

Better:

```csharp
private readonly List<Order> orders;


public IReadOnlyList<Order> Orders =>
    orders;
```

---

# Q17 — What is the difference between method overloading and overriding?

## Answer

## Overloading

Same method name, different parameters.

Example:

```csharp
void Print(string value)

void Print(int value)
```

Compile-time.

---

## Overriding

Child class changes parent behavior.

Example:

```csharp
public override void Speak()
{

}
```

Runtime polymorphism.

---

# Q18 — Why are constructors important in C# OOP?

## Answer

Because they guarantee object initialization.

Example:

Bad:

```csharp
new Customer();
```

Object may be incomplete.

Better:

```csharp
new Customer(
    "Ahmed",
    "email@test.com");
```

Required state exists immediately.

---

# Q19 — What is a sealed class?

## Answer

A sealed class cannot be inherited.

Example:

```csharp
public sealed class DatabaseConnection
{

}
```

Cannot:

```csharp
class MyConnection :
DatabaseConnection
{

}
```

Used when:

* Preventing modification.
* Protecting design.
* Improving security.

---

# Q20 — Senior Question

## Interviewer:

"What makes a C# class well designed?"

## Strong Answer:

A well-designed class:

* Represents a clear concept.
* Has a single responsibility.
* Protects its internal state.
* Exposes meaningful behavior.
* Creates valid objects.
* Minimizes unnecessary dependencies.

Example:

Good:

```csharp
order.Pay();
```

Weak:

```csharp
order.Status = 2;
```

---

# Common C# OOP Mistakes

## Mistake 1

Using classes only as data containers.

---

## Mistake 2

Public setters everywhere.

```csharp
public int Balance {get;set;}
```

---

## Mistake 3

Confusing readonly with immutable.

---

## Mistake 4

Exposing internal collections.

---

## Mistake 5

Creating objects without enforcing validity.

---

# Key Takeaways

```
Class = Reference Type

Object = Identity + State + Behavior

readonly ≠ Immutable

Private fields protect state

Methods represent behavior

Constructors create valid objects
```

---


* Object modeling scenarios
* Senior-level discussion questions 🚀
