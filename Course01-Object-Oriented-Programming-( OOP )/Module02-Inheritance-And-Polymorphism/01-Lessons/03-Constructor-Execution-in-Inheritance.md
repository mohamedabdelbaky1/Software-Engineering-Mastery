
# Lesson 03 — Constructor Execution in Inheritance

> **Module:** Inheritance and Polymorphism  
> **Topic:** Constructor Execution and Initialization Flow  
> **Language:** C#  
> **Focus:** Understanding Object Creation in Inheritance Hierarchies

---

# 🎯 Learning Objectives

By the end of this lesson, you should understand:

- How constructors behave when inheritance is involved.
- Why the base class constructor executes before the derived class constructor.
- How constructor chaining works.
- How the `base()` keyword controls constructor execution.
- How multiple levels of inheritance are initialized.
- How constructors affect object validity.
- Common constructor mistakes in inheritance.

---

# 1. Why Constructor Order Matters

A constructor is responsible for creating a valid object.

In a normal class:

```csharp
public class Employee
{
    public Employee()
    {
        Console.WriteLine("Employee created");
    }
}
````

The constructor runs when:

```csharp
Employee employee = new Employee();
```

However, inheritance introduces another question:

> If a class inherits from another class, which constructor runs first?

Example:

```text
Person

   ↓

Employee

   ↓

Developer
```

When we create:

```csharp
Developer developer = new Developer();
```

C# must initialize:

1. Person part
2. Employee part
3. Developer part

The object must be fully initialized from the top of the hierarchy down.

---

# 2. Constructor Execution Order

Consider this example:

```csharp
public class Person
{
    public Person()
    {
        Console.WriteLine("Person Constructor");
    }
}


public class Employee : Person
{
    public Employee()
    {
        Console.WriteLine("Employee Constructor");
    }
}


public class Developer : Employee
{
    public Developer()
    {
        Console.WriteLine("Developer Constructor");
    }
}
```

Now create an object:

```csharp
Developer developer = new Developer();
```

The output will be:

```
Person Constructor

Employee Constructor

Developer Constructor
```

---

# 3. Why Does the Base Constructor Run First?

A derived object contains the state and behavior of its parent.

Conceptually:

```
Developer Object

+----------------------+
| Person Part          |
+----------------------+
| Employee Part        |
+----------------------+
| Developer Part       |
+----------------------+
```

Before C# can create the `Developer` part, it must create:

* Person state.
* Employee state.

Therefore:

```
Base Constructor

        ↓

Derived Constructor
```

---

# 4. Constructor Chaining

Constructor chaining means that constructors call other constructors during object creation.

In inheritance, the derived class constructor usually chains to the base class constructor.

Example:

```csharp
public class Employee
{
    protected string Name;


    public Employee(string name)
    {
        Name = name;
    }
}
```

The base class requires a name.

Now:

```csharp
public class Developer : Employee
{
    public Developer(string name)
        : base(name)
    {

    }
}
```

The line:

```csharp
: base(name)
```

calls the parent constructor.

Execution:

```
Developer Constructor Called

        ↓

Employee Constructor Called

        ↓

Employee Initialization Complete

        ↓

Developer Initialization Continues
```

---

# 5. The base Keyword

The `base` keyword allows a derived class to communicate with its parent class.

It has two major uses:

---

# 5.1 Calling the Base Constructor

Example:

```csharp
public class Person
{
    public string Name { get; }


    public Person(string name)
    {
        Name = name;
    }
}


public class Employee : Person
{
    public Employee(string name)
        : base(name)
    {

    }
}
```

Here:

```csharp
base(name)
```

means:

"Run the Person constructor using this value."

---

# 5.2 Calling a Base Method

Example:

```csharp
public class Employee
{
    public virtual void Work()
    {
        Console.WriteLine("General employee work");
    }
}


public class Developer : Employee
{
    public override void Work()
    {
        base.Work();

        Console.WriteLine("Writing software");
    }
}
```

Output:

```
General employee work

Writing software
```

The child extends the parent's behavior.

---

# 6. Default Constructors and Inheritance

Consider:

```csharp
public class Employee
{
    public Employee()
    {
        Console.WriteLine("Employee");
    }
}
```

Derived class:

```csharp
public class Developer : Employee
{

}
```

Can we create:

```csharp
Developer developer = new Developer();
```

Yes.

Why?

Because C# automatically calls the default constructor of the base class.

Equivalent to:

```csharp
public class Developer : Employee
{
    public Developer()
        : base()
    {

    }
}
```

---

# 7. Parameterized Constructors in Inheritance

Now consider:

```csharp
public class Employee
{
    public Employee(string name)
    {

    }
}
```

The default constructor no longer exists.

Now:

```csharp
public class Developer : Employee
{

}
```

will cause an error.

Why?

Because C# does not know how to initialize the parent class.

The solution:

```csharp
public class Developer : Employee
{
    public Developer(string name)
        : base(name)
    {

    }
}
```

Now the initialization path is complete.

---

# 8. Multiple Levels of Constructor Execution

Inheritance can contain multiple levels.

Example:

```text
Person

   ↓

Employee

   ↓

Developer

   ↓

SeniorDeveloper
```

Code:

```csharp
public class Person
{
    public Person()
    {
        Console.WriteLine("Person");
    }
}


public class Employee : Person
{
    public Employee()
    {
        Console.WriteLine("Employee");
    }
}


public class Developer : Employee
{
    public Developer()
    {
        Console.WriteLine("Developer");
    }
}


public class SeniorDeveloper : Developer
{
    public SeniorDeveloper()
    {
        Console.WriteLine("Senior Developer");
    }
}
```

Creating:

```csharp
SeniorDeveloper developer =
    new SeniorDeveloper();
```

Output:

```
Person

Employee

Developer

Senior Developer
```

---

# 9. Constructor Responsibility

A constructor should initialize the state owned by its class.

Example:

```csharp
public class Employee
{
    protected string Name;


    public Employee(string name)
    {
        Name = name;
    }
}
```

The Employee constructor initializes:

```
Employee data
```

The Developer constructor initializes:

```
Developer-specific data
```

Example:

```csharp
public class Developer : Employee
{
    public string Language { get; }


    public Developer(string name, string language)
        : base(name)
    {
        Language = language;
    }
}
```

Each class initializes its own responsibility.

---

# 10. Common Constructor Mistakes

---

# Mistake 1 — Forgetting Base Constructor Requirements

Example:

```csharp
public class Employee
{
    public Employee(string name)
    {

    }
}


public class Developer : Employee
{

}
```

Problem:

The parent requires information.

The child does not provide it.

---

# Mistake 2 — Duplicating Parent Initialization

Bad:

```csharp
public class Developer : Employee
{
    public Developer(string name)
    {
        Name = name;
    }
}
```

Why is this bad?

Because `Employee` owns the initialization of `Name`.

The parent should control its own state.

Better:

```csharp
public Developer(string name)
    : base(name)
{

}
```

---

# Mistake 3 — Putting Too Much Logic in Constructors

Bad:

```csharp
public Employee()
{
    ConnectToDatabase();

    SendEmail();

    GenerateReport();
}
```

Constructors should create valid objects.

They should not perform unrelated operations.

---

# 11. Real-World Example — Banking System

Consider:

```
Account

    ↓

SavingsAccount
```

Base class:

```csharp
public class Account
{
    protected decimal Balance;


    public Account(decimal initialBalance)
    {
        Balance = initialBalance;
    }
}
```

Derived class:

```csharp
public class SavingsAccount : Account
{
    public decimal InterestRate { get; }


    public SavingsAccount(
        decimal balance,
        decimal interestRate)
        : base(balance)
    {
        InterestRate = interestRate;
    }
}
```

Responsibilities:

Account initializes:

```
Balance
```

SavingsAccount initializes:

```
InterestRate
```

---

# 12. Senior Engineer Considerations

When designing constructors in inheritance:

## Keep initialization ownership clear

The class that owns the data should initialize it.

---

## Avoid unnecessary constructor dependencies

A child should not know internal details of the parent.

---

## Keep objects valid after creation

After:

```csharp
new Developer()
```

the object should already be usable.

Avoid incomplete objects.

---

# 🧠 Interview Questions

## Question 1

What is the constructor execution order in inheritance?

### Answer:

The base class constructor executes first, followed by derived class constructors.

---

## Question 2

Why does the base constructor run first?

### Answer:

Because the base part of the object must be initialized before the derived part.

---

## Question 3

Are constructors inherited?

### Answer:

No. Constructors belong to the class that defines them.

---

## Question 4

What does `base()` do?

### Answer:

It calls the constructor of the parent class.

---

## Question 5

What happens if a parent class has only parameterized constructors?

### Answer:

The child class must explicitly call one of them using `base()`.

---

# 📝 Practice Questions

1. Explain constructor execution order in inheritance.
2. Why does the parent constructor execute first?
3. What is constructor chaining?
4. What is the purpose of `base()`?
5. Are constructors inherited?
6. What happens if the parent has no default constructor?
7. Where should initialization logic be placed?
8. Why should constructors avoid complex operations?

---

# ✅ Key Takeaways

```
Inheritance creates a constructor chain.

Object creation always starts from the top of the hierarchy.

Execution order:

Base Constructor

        ↓

Derived Constructor


The base keyword:

- Calls parent constructors.
- Calls parent methods.


Each class should initialize its own responsibility.
```

