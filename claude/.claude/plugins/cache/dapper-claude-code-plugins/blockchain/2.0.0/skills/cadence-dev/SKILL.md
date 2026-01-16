---
name: cadence-dev
description: Use PROACTIVELY when creating .cdc files, writing Cadence contracts/scripts/transactions, configuring flow.json, or using Flow CLI for local development and deployments. Covers Cadence 1.0 syntax with modern access control, entitlements, and capability-based security.
model: inherit
---

# Cadence Development (Flow Blockchain)

## Goal
Write secure, idiomatic Cadence code using resource-oriented programming, modern Cadence 1.0 access control, and Flow CLI best practices.

## Quick Reference

| Task | Command |
|------|---------|
| Init project | `flow init` |
| Start emulator | `flow emulator` |
| Deploy (emulator) | `flow project deploy --network=emulator` |
| Deploy (testnet) | `flow project deploy --network=testnet` |
| Deploy (mainnet) | `flow project deploy --network=mainnet` |
| Run script | `flow scripts execute ./path/script.cdc --network=emulator` |
| Send transaction | `flow transactions send ./path/tx.cdc --signer account --network=emulator` |
| Run tests | `flow test ./cadence/tests/*_test.cdc` |
| Create account | `flow accounts create --network=testnet` |
| Get account info | `flow accounts get ADDRESS --network=testnet` |

| Context7 Library | Use For |
|------------------|---------|
| `/onflow/cadence` | Language syntax, types, resources, capabilities |
| `/onflow/flow-cli` | CLI commands, deployment, emulator, testing |

## Access Control (Cadence 1.0)

**CRITICAL**: Use Cadence 1.0 syntax only. Never use legacy `pub`/`priv` keywords.

### Access Modifiers

| Modifier | Visibility |
|----------|------------|
| `access(all)` | Public - anyone can access |
| `access(self)` | Private - only current type |
| `access(contract)` | Contract scope only |
| `access(account)` | Same account only |
| `access(E)` | Entitled access (requires entitlement E) |

### Legacy to Modern Syntax

| Old (pre-1.0) | New (1.0) |
|---------------|-----------|
| `pub` | `access(all)` |
| `priv` | `access(self)` |
| `pub(set)` | Not available - use entitlements |

### Entitlements

```cadence
// Define entitlements at contract level
access(all) entitlement Withdraw
access(all) entitlement Admin

// Use in function signatures - requires caller to have entitlement
access(Withdraw) fun withdraw(amount: UFix64): @Vault {
    // Only callable with Withdraw entitlement
}

// Combine entitlements
access(Withdraw | Admin) fun sensitiveOperation() {
    // Requires Withdraw OR Admin
}
```

### Authorization in Transactions

```cadence
// Request specific entitlements in prepare phase
transaction {
    prepare(signer: auth(Storage, Capabilities) &Account) {
        // signer has Storage and Capabilities entitlements
    }
}

// Common entitlement combinations:
// auth(Storage) - read/write account storage
// auth(Capabilities) - manage capabilities
// auth(Storage, Capabilities) - full account access
```

## Cadence 1.0 Breaking Changes

### Reserved Field Names

**`owner` is reserved in resources.** All resources have a built-in `owner` property that returns `&Account?`. You cannot declare a field named `owner` in a resource.

```cadence
// WRONG - will fail with type mismatch errors
access(all) resource UserEscrow {
    access(all) let owner: Address  // 'owner' is reserved!
}

// CORRECT - use a different name
access(all) resource UserEscrow {
    access(all) let userAddress: Address
}
```

### Transaction Field Initialization

Transaction fields must be guaranteed to be initialized. Conditional initialization inside if/else blocks is NOT recognized as guaranteed.

```cadence
// WRONG - compiler can't prove vault is always initialized
transaction(token: String) {
    let vault: @{FungibleToken.Vault}  // Error: missing initialization

    prepare(signer: auth(Storage) &Account) {
        if token == "CATS" {
            self.vault <- ...  // Conditional - not guaranteed!
        } else {
            self.vault <- ...
        }
    }
}

// CORRECT - use optional with force-unwrap, or move all logic to prepare
transaction(token: String) {
    prepare(signer: auth(Storage) &Account) {
        var vault: @{FungibleToken.Vault}? <- nil

        if token == "CATS" {
            vault <-! catsVaultRef.withdraw(amount: amount)
        } else {
            vault <-! bartVaultRef.withdraw(amount: amount)
        }

        // Use the vault within prepare
        doSomething(vault: <-vault!)
    }
}
```

### Resource Assignment Operators

Resources require the move operator `<-` not `=`:

```cadence
// WRONG
var vault: @{FungibleToken.Vault}? = nil

// CORRECT
var vault: @{FungibleToken.Vault}? <- nil
```

## Contract Structure

### Basic Contract Template

```cadence
access(all) contract MyContract {

    // --- Events ---
    access(all) event ItemCreated(id: UInt64)
    access(all) event ItemDestroyed(id: UInt64)

    // --- State ---
    access(all) var totalSupply: UInt64
    access(contract) let items: @{UInt64: Item}

    // --- Paths ---
    access(all) let CollectionStoragePath: StoragePath
    access(all) let CollectionPublicPath: PublicPath

    // --- Entitlements ---
    access(all) entitlement Owner

    // --- Resource Interfaces ---
    access(all) resource interface ItemPublic {
        access(all) let id: UInt64
        access(all) fun getMetadata(): {String: String}
    }

    // --- Resources ---
    access(all) resource Item: ItemPublic {
        access(all) let id: UInt64
        access(self) let metadata: {String: String}

        access(all) fun getMetadata(): {String: String} {
            return self.metadata
        }

        init(id: UInt64, metadata: {String: String}) {
            self.id = id
            self.metadata = metadata
        }
    }

    // --- Collection Resource ---
    access(all) resource Collection {
        access(all) var ownedItems: @{UInt64: Item}

        access(all) fun deposit(item: @Item) {
            let id = item.id
            let oldItem <- self.ownedItems[id] <- item
            destroy oldItem
        }

        access(Owner) fun withdraw(id: UInt64): @Item {
            let item <- self.ownedItems.remove(key: id)
                ?? panic("Item not found")
            return <- item
        }

        access(all) fun getIDs(): [UInt64] {
            return self.ownedItems.keys
        }

        access(all) fun borrowItem(id: UInt64): &Item? {
            return &self.ownedItems[id]
        }

        init() {
            self.ownedItems <- {}
        }
    }

    // --- Public Functions ---
    access(all) fun createItem(metadata: {String: String}): @Item {
        let id = self.totalSupply
        self.totalSupply = self.totalSupply + 1

        let item <- create Item(id: id, metadata: metadata)
        emit ItemCreated(id: id)
        return <- item
    }

    access(all) fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    // --- Contract Init ---
    init() {
        self.totalSupply = 0
        self.items <- {}
        self.CollectionStoragePath = /storage/MyContractCollection
        self.CollectionPublicPath = /public/MyContractCollection
    }
}
```

## Scripts (Read-Only Queries)

```cadence
// scripts/get_collection_ids.cdc
import MyContract from "MyContract"

access(all) fun main(address: Address): [UInt64] {
    let account = getAccount(address)

    let collectionRef = account.capabilities
        .borrow<&MyContract.Collection>(MyContract.CollectionPublicPath)
        ?? panic("Could not borrow collection reference")

    return collectionRef.getIDs()
}
```

### Running Scripts

```bash
# With arguments (JSON format)
flow scripts execute ./cadence/scripts/get_collection_ids.cdc \
  --args-json '[{"type": "Address", "value": "0xf8d6e0586b0a20c7"}]' \
  --network=emulator
```

## Transactions

### Basic Transaction Structure

```cadence
// transactions/transfer_item.cdc
import MyContract from "MyContract"

transaction(recipientAddress: Address, itemID: UInt64) {

    let senderCollection: auth(MyContract.Owner) &MyContract.Collection
    let recipientCollection: &MyContract.Collection

    prepare(signer: auth(Storage) &Account) {
        // Borrow sender's collection with Owner entitlement
        self.senderCollection = signer.storage
            .borrow<auth(MyContract.Owner) &MyContract.Collection>(
                from: MyContract.CollectionStoragePath
            ) ?? panic("Could not borrow sender collection")

        // Get recipient's public collection capability
        let recipientAccount = getAccount(recipientAddress)
        self.recipientCollection = recipientAccount.capabilities
            .borrow<&MyContract.Collection>(MyContract.CollectionPublicPath)
            ?? panic("Could not borrow recipient collection")
    }

    execute {
        let item <- self.senderCollection.withdraw(id: itemID)
        self.recipientCollection.deposit(item: <- item)
    }

    post {
        // Post-conditions verify state after execution
        !self.senderCollection.getIDs().contains(itemID): "Item still in sender"
    }
}
```

### Running Transactions

```bash
flow transactions send ./cadence/transactions/transfer_item.cdc \
  --args-json '[{"type": "Address", "value": "0x01cf0e2f2f715450"}, {"type": "UInt64", "value": "1"}]' \
  --signer emulator-account --network=emulator
```

## flow.json Configuration

### Contract Paths

**Prefer simple string paths** for contract definitions:

```json
{
  "contracts": {
    "MyContract": "./cadence/contracts/MyContract.cdc",
    "CATS": "./cadence/contracts/CATS.cdc"
  }
}
```

Only use object notation with testing aliases when required for `flow test`:

```json
{
  "contracts": {
    "MyContract": {
      "source": "./cadence/contracts/MyContract.cdc",
      "aliases": {
        "testing": "0000000000000007"
      }
    }
  }
}
```

Overflow-based Go tests don't require testing aliases.

### Dependencies

Prefer manual configuration with empty hashes over `flow deps add` (no imports folder, stable contracts resolved at runtime):

```json
{
  "dependencies": {
    "FungibleToken": {
      "source": "mainnet://f233dcee88fe0abe.FungibleToken",
      "hash": "",
      "aliases": {
        "emulator": "ee82856bf20e2aa6",
        "testnet": "9a0766d93b6608b7",
        "mainnet": "f233dcee88fe0abe"
      }
    }
  }
}
```

Use `flow deps install` when you need pinned versions or offline access. See [REFERENCE.md](REFERENCE.md#dependencies-configuration) for details.

### Minimal Configuration

```json
{
  "networks": {
    "emulator": "127.0.0.1:3569",
    "testnet": "access.devnet.nodes.onflow.org:9000",
    "mainnet": "access.mainnet.nodes.onflow.org:9000"
  },
  "accounts": {
    "emulator-account": {
      "address": "f8d6e0586b0a20c7",
      "key": "ae1b44c0f5e8f6992ef2348898a35e50a8b0b9684000da8b1dade1b3bcd6ebee"
    }
  },
  "contracts": {},
  "deployments": {}
}
```

For full project configuration (testnet/mainnet) and standard contract aliases, see [REFERENCE.md](REFERENCE.md#flow.json-advanced-configuration).

## Local Development

### Project Structure

```
project/
  cadence/
    contracts/
      MyContract.cdc
    scripts/
      get_data.cdc
    transactions/
      setup_account.cdc
      transfer.cdc
    tests/
      MyContract_test.cdc
  flow.json
```

### Files to Commit vs Ignore

**Commit:**
- `flow.json` - Project configuration
- `cadence/` - All contracts, transactions, scripts, tests

**Add to `.gitignore`:**
```
# Flow
imports/
flowdb/
```

- `imports/` contains downloaded copies of standard contracts (not needed with empty hashes)
- `flowdb/` is emulator state persistence (local only)

### Emulator Workflow

```bash
# Terminal 1: Start emulator (keeps running)
flow emulator

# Terminal 2: Deploy and interact
flow project deploy --network=emulator

# Create additional test accounts
flow accounts create --network=emulator

# Check deployment
flow accounts get f8d6e0586b0a20c7 --network=emulator
```

### Testing

| Approach | Best For | Details |
|----------|----------|---------|
| **Overflow (Go)** | Multi-user flows, e2e testing | [OVERFLOW.md](OVERFLOW.md) |
| **`flow test`** | Unit testing contract functions | [REFERENCE.md](REFERENCE.md#testing-with-flow-test) |

Overflow auto-creates accounts and needs no special config. `flow test` requires `testing` aliases in flow.json.

## Deployment

For testnet and mainnet deployment workflows, see [REFERENCE.md](REFERENCE.md#deployment-workflows).

## Anti-Patterns (Avoid)

| Pattern | Wrong | Correct |
|---------|-------|---------|
| **Legacy Syntax** | `pub var data` | `access(all) var data` |
| **Unsafe Resources** | Early return without `destroy` | Always destroy before return |
| **Missing Nil Checks** | `borrow<&T>()` then use | `borrow<&T>() ?? panic("...")` |
| **Overly Permissive** | `access(all) fun withdraw()` | `access(Withdraw) fun withdraw()` |

```cadence
// WRONG - Resource lost on early return
fun processItem(item: @Item) {
    if someCondition { return }  // item lost!
    destroy item
}

// CORRECT
fun processItem(item: @Item) {
    if someCondition { destroy item; return }
    destroy item
}
```

See [REFERENCE.md](REFERENCE.md#additional-anti-patterns) for more anti-patterns.

## Using Context7

Query Context7 for up-to-date documentation:
- `/onflow/cadence` - Language syntax, types, resources, capabilities
- `/onflow/flow-cli` - CLI commands, deployment, testing

Prefer Context7 over training data for latest Cadence 1.0 syntax, CLI flags, and contract addresses.
