
# 🔍 Code Review Challenges

## Overview

This section is designed to practice reviewing code like a professional software engineer.

The goal is not only to find bugs, but to evaluate:

- Code quality.
- Object design.
- Encapsulation.
- Responsibilities.
- Maintainability.

---

# 🧠 How To Approach Code Reviews

## 1. Understand The Intent

Before reviewing the code, understand:

- What problem is being solved?
- What should this code achieve?

Do not judge code without understanding its purpose.

---

## 2. Review Object Design

Ask:

- Does each class have a clear responsibility?
- Does the object represent a meaningful concept?
- Is behavior placed in the correct class?

---

## 3. Check Encapsulation

Look for:

❌ Public fields

```csharp
public decimal Balance;
````

❌ Uncontrolled setters

```csharp
public decimal Balance {get;set;}
```

Ask:

* Can external code break the object's state?
* Are changes controlled?

---

## 4. Look For Invalid States

Ask:

* Can this object become invalid?
* Are business rules protected?

Examples:

```
Balance < 0

Invalid Order Status

Negative Price
```

---

## 5. Think Like A Maintainer

Imagine modifying this code after 6 months.

Ask:

* Is it easy to understand?
* Is it easy to extend?
* Are responsibilities clear?

---

# ✅ Review Checklist

Before finishing a review, check:

* [ ] Clear class responsibilities
* [ ] Proper encapsulation
* [ ] Protected object state
* [ ] No duplicated business rules
* [ ] Meaningful methods and naming
* [ ] Maintainable design

---

# 🏆 Recommended Practice

For every challenge:

1. Review the code before seeing the solution.
2. Write your observations.
3. Explain the problems and their impact.
4. Suggest a better design.
5. Compare your review with the expected solution.

---

# 💡 Senior Engineer Mindset

A good reviewer does not ask:

> "Does this code work?"

A good reviewer asks:

> "Is this code safe, maintainable, and easy to evolve?"

```

