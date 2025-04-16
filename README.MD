# 🌀 Ethereum Mixer - A Tornado-like Mixer in Solidity & Python

An Ethereum mixer smart contract built with **Solidity** and **Python**, designed to enhance transaction privacy using **Merkle Trees** and **zkSNARKs**. Inspired by [Tornado Cash](https://tornado.cash), this project aims to demonstrate how zero-knowledge cryptography can enable anonymous transactions on Ethereum.

---

## 📌 What is an Ethereum Mixer?

An Ethereum mixer (also known as a tumbler) allows users to deposit and withdraw cryptocurrency in a way that **breaks the on-chain link** between sender and receiver, enabling **privacy** in a fully transparent blockchain environment.

---

## 🧱 Types of Ethereum Mixers

Before diving into the implementation, it's important to understand the different architectural models for mixers:

### 1. Simple Mixer (Direct Deposit & Withdraw)
- Users deposit and later withdraw funds.
- 🟠 **Low privacy** – deposits and withdrawals are easily correlated.

### 2. Timed Mixer
- Funds are locked for a period before becoming withdrawable.
- 🟡 **Moderate privacy** – makes timing correlation harder.

### 3. Hashed Commitments
- Users deposit a hash of a secret.
- Later, the secret is revealed for withdrawal.
- 🟡 **Moderate privacy** – no direct address linkage, but patterns still traceable.

### 4. ✅ Merkle Tree + zkSNARKs (Tornado-Style)
- Users deposit a commitment added to a Merkle Tree.
- Withdrawals are done using **zkSNARK proofs** to show knowledge of a valid (but unspent) commitment.
- 🟢 **High privacy** – no address or amount linkage, full anonymity.

---

## 🔐 How the Tornado-Style Mixer Works

### 🧩 Core Components

- **Merkle Tree:** Stores all deposit commitments.
- **Commitment:** A hash of a secret (e.g., `hash(nullifier, secret)`).
- **Nullifier:** Prevents double withdrawals by keeping track of spent commitments.
- **zkSNARK Proof:** Proves that the user knows a valid commitment without revealing it.

### 🔄 Workflow

#### 1. Deposit
- Generate a random `nullifier` and `secret`.
- Compute `commitment = hash(nullifier, secret)`.
- Submit `deposit(commitment)` to the smart contract.
- Commitment is added to the Merkle Tree.

#### 2. Withdraw
- Generate a zkSNARK proof that:
  - Your commitment exists in the Merkle Tree.
  - You haven't withdrawn it before (nullifier is unused).
- Call `withdraw(proof, root, nullifierHash, recipient)`.

---

## 🧰 Tech Stack

### 💻 Smart Contracts
- **Solidity** for writing the Mixer and Verifier contracts.
- **Hardhat** or **Foundry** for development & testing.

### 🧪 zkSNARKs
- **circom**: DSL for writing zk circuits.
- **snarkjs**: CLI tool for circuit compilation, proving & verifying.
- **Poseidon Hash**: Efficient zk-friendly hashing.

### 🐍 Python (Optional Tooling)
- For handling:
  - Circuit input generation
  - Merkle Tree operations
  - Account/key management
  - Proof generation automation using subprocess

---

## 🗂️ Suggested Project Structure

```bash
    ethereum-mixer/
    │
    ├── contracts/
    │ ├── Mixer.sol # Main mixer contract
    │ └── Verifier.sol # zkSNARK verifier contract
    │
    ├── circuits/
    │ └── mixer.circom # zkSNARK circuit
    │
    ├── scripts/
    │ └── generate_proof.py # Python script to generate proof
    │
    ├── merkle/
    │ └── merkle_tree.py # Python Merkle Tree helper
    │
    ├── test/
    │ └── test_mixer.py # Python or Hardhat tests
    │
    ├── hardhat.config.js
    └── README.md

```