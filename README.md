# **Smart Contract Risk Analyzer**

### *Static analysis + heuristic risk scoring for Solidity smart contracts*

<p align="center">
  <img src="https://img.shields.io/badge/Security-Analyzer-blue?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Solidity-%5E0.8.0-black?style=for-the-badge&logo=solidity"/>
  <img src="https://img.shields.io/badge/Python-3.10%2B-yellow?style=for-the-badge&logo=python"/>
  <img src="https://img.shields.io/badge/Static%20Analysis-Heuristic-red?style=for-the-badge"/>
</p>

---

## **Overview**

**Smart Contract Risk Analyzer** is a lightweight, extensible **static analysis tool** for auditing Solidity contracts.
It uses **rule-based heuristics**, **pattern detection**, and **surface-level code metrics** to produce:

* A **risk score (0–100)**
* A **risk level (Low / Medium / High)**
* A detailed **feature breakdown** extracted from the contract’s source code
* A **cryptographic source hash** for traceability

This project provides a minimal but powerful foundation for building more advanced analyzers, ML-driven detectors, AST-based analysis, or on-chain verification tools.

---

## **Why This Project Exists**

Security is the #1 priority in smart contract development.
Even simple mistakes, like unsafe access control, reentrancy windows, or misuse of `delegatecall`, can lead to millions in losses.

Most developers:

* Don’t have access to high-end auditing tools
* Don’t know how to build static analyzers
* Want a lightweight tool they can run locally

This project solves that by offering:

* A **simple CLI-based analyzer**
* A **dangerous-pattern detector**
* A **clear scoring system**
* A set of **sample vulnerable contracts**
* A structure designed for **future expansion**

---

## **Features**

### **Static Feature Extraction**

The analyzer extracts:

|      Feature       |                  Meaning                       |
| ------------------ | ---------------------------------------------- |
| `n_lines`          | Total number of code lines (size/complexity)   |
| `n_payable`        | Count of `payable` functions                   |
| `has_delegatecall` | High-risk opcode for proxy & dynamic execution |
| `has_call_value`   | Deprecated low-level call pattern              |
| `has_tx_origin`    | Critical access-control vulnerability          |

---

### **Heuristic Risk Scoring**

Risk score out of **100**, based on:

* High-risk opcodes
* Misleading patterns
* Exposure surfaces
* Code size

#### **Scoring rules (current version)**

| Pattern                           | Score |
| --------------------------------- | ----- |
| `delegatecall`                    | +50   |
| `tx.origin`                       | +40   |
| `call.value`                      | +30   |
| Many payable functions (>3)       | +25   |
| Some payable functions (>0)       | +5    |
| Large contracts (>100 lines)      | +5    |
| Very large contracts (>300 lines) | +15   |

Risk buckets:

* **0–20** → Low
* **21–60** → Medium
* **61–100** → High

---

### **Built-In Example Contracts**

The project includes multiple real security scenarios:

* Safe contract
* Many-payable (expanded attack surface)
* Delegatecall vulnerability
* Proxy pattern
* Reentrancy vulnerability
* Access-control bug
* Oracle manipulation bug
* More...

Full analysis for each is included below.

---

## **Project Structure**

```
smart-contract-risk-analyzer/
├── contracts/
│   └── RiskRegistry.sol              # (optional, not used)
├── data/
│   └── examples/                     # All test Solidity contracts
│       ├── safe_contract.sol
│       ├── medium_risk.sol
│       ├── high_risk_delegatecall.sol
│       ├── reentrancy_vuln.sol
│       ├── oracle_manipulation.sol
│       ├── proxy_contract.sol
│       ├── access_control_bug.sol
│       └── sample_contract.sol
├── src/
│   ├── analyzer/
│   │   ├── features.py               # feature extraction
│   │   ├── risk.py                   # scoring engine
│   └── cli.py                        # CLI entry point
├── scripts/
│   ├── train_model.py                # placeholder
│   └── analyze_and_register.py       # placeholder
└── templates/
    └── report.html                   # placeholder
```

---

## **Quick Start**

### **1. Install**

```bash
cd smart-contract-risk-analyzer
python -m venv .venv
.\.venv\Scripts\activate  # Windows
pip install -r requirements.txt   # (optional; no dependencies required yet)
```

### **2. Run the analyzer**

```bash
python src\cli.py --file data\examples\sample_contract.sol
```

### **3. Output example**

```json
{
  "source_hash": "1da354a9b...",
  "features": {
    "n_lines": 16,
    "n_payable": 0,
    "has_delegatecall": 1,
    "has_call_value": 0,
    "has_tx_origin": 1
  },
  "risk_score": 90,
  "risk_level": "High"
}
```

---

# **Detailed Analysis of Included Contracts**

Below is a breakdown of how the analyzer evaluates each contract.

---

## **1. safe_contract.sol, Safe Contract**

No dangerous patterns
Simple owner-withdraw logic
Some payable functions but low quantity
**Risk: Low (score ~5)**

---

## **2. medium_risk.sol, Many Payable Functions**

No dangerous opcodes
5+ payable functions → expanded attack surface
**Risk: Medium (score ~25)**

---

## **3. high_risk_delegatecall.sol, Critical Security Risks**

Contains **two extremely dangerous patterns**:

* `delegatecall`
* `tx.origin` for authorization

This is catastrophic in real-world deployments.

**Risk: High (score ~90)**

---

## **4. reentrancy_vuln.sol, Classic Reentrancy Bug**

Calls:

```solidity
(bool ok,) = msg.sender.call{value: amount}("");
```

**Effect-before-interaction**, making it reentrancy-vulnerable.
Current version does **not yet detect this**, but future improvements will.

**Risk (current): Low–Medium (score ~5)**
**Risk (real-world): High**

---

## **5. access_control_bug.sol, Anyone Can Change Owner**

```solidity
function setOwner(address newOwner) public {
    owner = newOwner;
}
```

There is no `require(msg.sender == owner)` check.
Current heuristics do NOT yet detect this.

**Risk (current): Low (score ~0)**
**Risk (actual): High**

---

## **6. oracle_manipulation.sol, Open Price Oracle**

Anyone can update the price.

Again: current heuristics do NOT detect this.

**Risk (current): Low**
**Risk (actual): Medium–High**

---

## **7. proxy_contract.sol, Upgradeable Proxy**

Legitimate use of `delegatecall`, but still inherently dangerous.

**Risk: Medium (score ~55)**

---

# **How to Improve the Analyzer**

The analyzer is intentionally simple.
Here’s how you can extend it:

### **1. Add more pattern detectors**

* Detect `call{value:...}` syntax
* Detect unprotected setters
* Detect missing `require()` on critical operations
* Detect unsafe `public` variables
* Detect unguarded external calls

### **2. Use an AST parser**

Replace regex with:

* `solidity-parser-antlr` (Node.js)
* `slither` JSON AST output
* `tree-sitter-solidity`

### **3. Add ML model (RandomForest/XGBoost)**

Steps:

1. Compute features for all example contracts
2. Label them manually (`Low/Medium/High`)
3. Train a classifier
4. Replace heuristics with prediction

### **4. Generate HTML/PDF Reports**

Use Jinja2 + templates to create:

* contract summary
* risk indicators
* function-level breakdown
* recommendations

---

## **Roadmap**

|              Feature              | Status |
| --------------------------------- | ------ |
| Static feature extraction         |  Done  |
| Heuristic scoring engine          |  Done  |
| CLI interface                     |  Done  |
| Built-in sample contracts         |  Done  |
| ML-based scoring                  |  Next  |
| AST-based analysis                |  Next  |
| Web interface                     | Planned |
| Report generation                 | Planned |
| Rule-based vulnerability patterns | Planned |
