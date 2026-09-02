

````markdown
# 🏦 Secure Banking System

# Software Requirements Document (SRD)

**Document Version:** 1.0  
**Project Type:** Object-Oriented Programming Mini Project  
**Technology:** C#  
**Module:** OOP Fundamentals → Encapsulation  

---

# 1. Introduction

## 1.1 Purpose

The purpose of this document is to define the functional and non-functional requirements of the Secure Banking System.

This document describes the system scope, features, business rules, constraints, and expected behavior before implementation.

The project is designed to demonstrate professional object-oriented programming practices, focusing on:

- Encapsulation.
- Object responsibility.
- Valid object states.
- Controlled state transitions.

---

## 1.2 Project Scope

Secure Banking System is a simplified banking domain application that allows users to manage customers, accounts, and financial transactions.

The system should provide a secure object-oriented model where domain objects:

- Maintain their own state.
- Control their own behavior.
- Prevent invalid operations.
- Enforce business rules internally.

---

# 2. System Overview

## 2.1 System Description

The system represents the core operations of a banking platform.

The main entities are:

- Bank.
- Customer.
- Bank Account.
- Transaction.
- Money.

The system allows customers to perform financial operations while maintaining data integrity.

---

## 2.2 System Goals

The system should:

- Create and manage customers.
- Create and manage bank accounts.
- Perform financial transactions.
- Maintain transaction history.
- Protect account state.
- Prevent invalid financial operations.

---

# 3. Functional Requirements

---

# 3.1 Customer Management

## Description

The system shall allow creating and managing customer profiles.

---

## Customer Attributes

Each customer shall contain:

| Attribute | Description |
|---|---|
| Customer ID | Unique customer identifier |
| Full Name | Customer full name |
| Email | Customer email address |
| Phone Number | Customer contact number |
| Status | Customer current status |

---

## Customer Operations

The system shall support:

- Creating a customer.
- Updating customer information.
- Activating customer.
- Deactivating customer.

---

## Business Rules

The system shall ensure:

- Customer name cannot be empty.
- Email must follow a valid format.
- Inactive customers cannot perform banking operations.

---

# 3.2 Bank Account Management

## Description

The system shall allow customers to own and manage bank accounts.

---

## Account Attributes

Each account shall contain:

| Attribute | Description |
|---|---|
| Account Number | Unique account identifier |
| Balance | Current available balance |
| Status | Account state |
| Transactions | List of performed transactions |

---

## Account Operations

The system shall support:

- Deposit funds.
- Withdraw funds.
- Transfer funds.
- Freeze account.
- Activate account.
- Retrieve transaction history.

---

# 3.3 Deposit Operation

## Description

The system shall allow depositing money into an active account.

---

## Requirements

The system shall verify:

- Deposit amount is greater than zero.
- Account is valid.
- Transaction is recorded successfully.

---

## Invalid Cases

The operation shall fail when:

- Amount is zero.
- Amount is negative.
- Account does not exist.

---

# 3.4 Withdrawal Operation

## Description

The system shall allow withdrawing money from an account.

---

## Requirements

The system shall verify:

- Withdrawal amount is greater than zero.
- Account has sufficient balance.
- Account is active.

---

## Invalid Cases

The operation shall fail when:

- Amount exceeds balance.
- Account is frozen.
- Amount is invalid.

---

# 3.5 Money Transfer

## Description

The system shall allow transferring money between accounts.

---

## Requirements

The system shall verify:

- Source account exists.
- Destination account exists.
- Source account has sufficient funds.
- Both accounts are active.
- Transfer transaction is recorded.

---

# 3.6 Transaction Management

## Description

The system shall record every financial operation.

---

## Transaction Attributes

| Attribute | Description |
|---|---|
| Transaction ID | Unique identifier |
| Amount | Transaction value |
| Date | Creation date |
| Type | Transaction category |
| Status | Transaction state |

---

## Transaction Types

The system shall support:

- Deposit.
- Withdrawal.
- Transfer.

---

## Transaction States

A transaction shall have one of the following states:

```text
Pending

Completed

Failed
````

---

# 4. Business Rules

---

## BR-001: Account Balance Rule

The system shall guarantee that:

```
Account Balance >= 0
```

An account shall never enter a negative balance state.

---

## BR-002: Direct State Modification

The system shall prevent external modification of sensitive account data.

Example:

Not allowed:

```csharp
account.Balance = -500;
```

---

## BR-003: Account Status Rule

Frozen accounts shall not be allowed to:

* Withdraw money.
* Transfer money.

---

## BR-004: Transaction Integrity

Every successful financial operation shall create a transaction record.

---

# 5. Non-Functional Requirements

---

# 5.1 Maintainability

The system should:

* Follow clean coding practices.
* Have clear object responsibilities.
* Avoid duplicated logic.

---

# 5.2 Security

The system should:

* Protect sensitive information.
* Prevent unauthorized state changes.
* Validate all financial operations.

---

# 5.3 Extensibility

The system design should allow future expansion:

* Different account types.
* Loans.
* Cards.
* Authentication.
* Payment services.

---

# 6. Object-Oriented Design Constraints

The implementation shall follow:

## Encapsulation

Objects must:

* Hide internal state.
* Expose controlled operations.
* Protect invariants.

---

## Responsibility Ownership

Each object should own its related behavior.

Example:

Account should control:

* Balance changes.
* Withdrawal rules.
* Transfer rules.

---

## Avoided Practices

The implementation should avoid:

* Public fields.
* Uncontrolled setters.
* God classes.
* Business logic duplication.

---

# 7. Technical Requirements

## Programming Language

C#

---

## Development Approach

Object-Oriented Programming.

---

## Required Concepts

The implementation must demonstrate:

* Classes.
* Objects.
* Constructors.
* Properties.
* Methods.
* Access modifiers.
* Encapsulation.
* Validation.

---

# 8. Acceptance Criteria

The project is considered complete when:

* All required entities are implemented.
* Business rules are enforced.
* Invalid operations are prevented.
* Objects maintain valid states.
* Encapsulation principles are applied.
* Code structure is maintainable.

---

# 9. Future Enhancements

Future versions may introduce:

* Inheritance.
* Interfaces.
* Polymorphism.
* SOLID principles.
* Design patterns.
* Persistence layer.

---

# End of Document

````

