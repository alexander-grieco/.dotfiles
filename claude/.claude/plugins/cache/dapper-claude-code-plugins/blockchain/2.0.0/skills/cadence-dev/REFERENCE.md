# Cadence Reference Guide

For day-to-day development, see [SKILL.md](SKILL.md).

This file contains setup, deployment, and detailed reference content that isn't needed for daily development.

---

## Setup Transactions

### Setup Account Transaction

```cadence
// transactions/setup_account.cdc
import MyContract from "MyContract"

transaction {
    prepare(signer: auth(Storage, Capabilities) &Account) {
        // Check if collection already exists
        if signer.storage.borrow<&MyContract.Collection>(
            from: MyContract.CollectionStoragePath
        ) != nil {
            return
        }

        // Create and save collection
        let collection <- MyContract.createEmptyCollection()
        signer.storage.save(<- collection, to: MyContract.CollectionStoragePath)

        // Create and publish capability
        let cap = signer.capabilities.storage.issue<&MyContract.Collection>(
            MyContract.CollectionStoragePath
        )
        signer.capabilities.publish(cap, at: MyContract.CollectionPublicPath)
    }
}
```

---

## flow.json Advanced Configuration

### Test Accounts for CLI

Pre-define test accounts for multi-user CLI testing:

```json
{
  "accounts": {
    "emulator-account": {
      "address": "f8d6e0586b0a20c7",
      "key": "ae1b44c0f5e8f6992ef2348898a35e50a8b0b9684000da8b1dade1b3bcd6ebee"
    },
    "alice": {
      "address": "0x179b6b1cb6755e31",
      "key": "d5457a187e9642a8e49d4032b3b4f85c92da7202c79681d9302c6e444e7033a8"
    },
    "bob": {
      "address": "0xf3fcd2c1a78f5eee",
      "key": "d5457a187e9642a8e49d4032b3b4f85c92da7202c79681d9302c6e444e7033a8"
    }
  }
}
```

This enables CLI testing with `flow transactions send --signer alice`. Note: Overflow auto-creates accounts, so this is mainly for CLI-based manual testing.

### Full Project Configuration

Complete configuration for testnet and mainnet deployments:

```json
{
  "contracts": {
    "MyContract": "./cadence/contracts/MyContract.cdc"
  },
  "deployments": {
    "emulator": {
      "emulator-account": ["MyContract"]
    },
    "testnet": {
      "testnet-account": ["MyContract"]
    },
    "mainnet": {
      "mainnet-account": ["MyContract"]
    }
  },
  "accounts": {
    "emulator-account": {
      "address": "f8d6e0586b0a20c7",
      "key": "ae1b44c0f5e8f6992ef2348898a35e50a8b0b9684000da8b1dade1b3bcd6ebee"
    },
    "testnet-account": {
      "address": "YOUR_TESTNET_ADDRESS",
      "key": {
        "type": "file",
        "location": "./testnet-key.pkey"
      }
    },
    "mainnet-account": {
      "address": "YOUR_MAINNET_ADDRESS",
      "key": {
        "type": "file",
        "location": "./mainnet-key.pkey"
      }
    }
  },
  "networks": {
    "emulator": "127.0.0.1:3569",
    "testnet": "access.devnet.nodes.onflow.org:9000",
    "mainnet": "access.mainnet.nodes.onflow.org:9000"
  }
}
```

### Standard Contract Aliases

| Contract | Emulator | Testnet | Mainnet |
|----------|----------|---------|---------|
| FungibleToken | 0xee82856bf20e2aa6 | 0x9a0766d93b6608b7 | 0xf233dcee88fe0abe |
| NonFungibleToken | 0xf8d6e0586b0a20c7 | 0x631e88ae7f1d7c20 | 0x1d7e57aa55817448 |
| MetadataViews | 0xf8d6e0586b0a20c7 | 0x631e88ae7f1d7c20 | 0x1d7e57aa55817448 |
| ViewResolver | 0xf8d6e0586b0a20c7 | 0x631e88ae7f1d7c20 | 0x1d7e57aa55817448 |
| Burner | 0xf8d6e0586b0a20c7 | — | — |
| FlowToken | 0x0ae53cb6e3f42a79 | 0x7e60df042a9c0868 | 0x1654653399040a61 |

### Dependencies Configuration

**Prefer manual configuration with empty hashes** over `flow deps add`:

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

**Why prefer manual config:**
- No `imports/` folder to commit (smaller repo)
- Standard library contracts are stable and resolved at runtime
- Avoids version drift between local copies and deployed contracts

**When to use `flow deps install`:**
- When you need reproducible builds with pinned contract versions
- When working offline frequently
- When depending on third-party contracts that might change

---

## Testing with flow test

### Complete Test File Example

```cadence
// cadence/tests/MyContract_test.cdc
import Test
import "MyContract"

access(all) fun setup() {
    let err = Test.deployContract(
        name: "MyContract",
        path: "../contracts/MyContract.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all) fun testCreateItem() {
    let metadata: {String: String} = {"name": "Test Item"}
    let item <- MyContract.createItem(metadata: metadata)

    Test.assertEqual(item.id, 0 as UInt64)
    Test.assertEqual(item.getMetadata()["name"], "Test Item")

    destroy item
}

access(all) fun testTotalSupplyIncreases() {
    let initialSupply = MyContract.totalSupply

    let item <- MyContract.createItem(metadata: {})
    destroy item

    Test.assertEqual(MyContract.totalSupply, initialSupply + 1)
}
```

### Running Tests

```bash
# Run all tests
flow test ./cadence/tests/*_test.cdc

# Run specific test file
flow test ./cadence/tests/MyContract_test.cdc
```

**Note:** `flow test` requires `testing` network and aliases in flow.json. Only use object notation with testing aliases when required:

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

If you only use Overflow for testing, you can skip the `testing` network and testing aliases entirely.

---

## Deployment Workflows

### Testnet Deployment

```bash
# 1. Create testnet account
flow accounts create --network=testnet
# Save the address and configure in flow.json

# 2. Fund account at https://testnet-faucet.onflow.org/

# 3. Verify account is funded
flow accounts get YOUR_ADDRESS --network=testnet

# 4. Deploy contracts
flow project deploy --network=testnet

# 5. Verify deployment
flow accounts get YOUR_ADDRESS --network=testnet
# Should show deployed contracts
```

### Mainnet Deployment

```bash
# 1. Create mainnet account
flow accounts create --network=mainnet

# 2. IMPORTANT: Use key file, not raw key in flow.json
# Configure account with:
# "key": { "type": "file", "location": "./mainnet-key.pkey" }

# 3. Fund account with FLOW tokens

# 4. Double-check contract code before deployment!

# 5. Deploy
flow project deploy --network=mainnet

# 6. Update contracts (must be backwards compatible)
flow project deploy --network=mainnet --update
```

---

## Additional Anti-Patterns

### Hardcoded Addresses

```cadence
// WRONG - Hardcoded address
import FungibleToken from 0x9a0766d93b6608b7

// CORRECT - Use import alias (resolved via flow.json)
import FungibleToken from "FungibleToken"
```

### Raw Keys in flow.json (Mainnet)

```json
// WRONG - Raw private key for mainnet
"mainnet-account": {
  "address": "0x...",
  "key": "abc123def456..."
}

// CORRECT - Use key file
"mainnet-account": {
  "address": "0x...",
  "key": {
    "type": "file",
    "location": "./mainnet-key.pkey"
  }
}
```

---

## Verification Prompts

Test this skill with these prompts:

- "Create a basic NFT contract with minting"
  - **Expected**: Uses `access(all)` syntax, entitlements for withdraw, Collection pattern, events

- "Write a script to check if an account has a collection"
  - **Expected**: Uses `getAccount()`, capability borrow with nil check, returns Bool

- "Set up flow.json for testnet deployment"
  - **Expected**: Proper network config, account with key file, contract paths, deployments section

- "Write a transaction that transfers an item between accounts"
  - **Expected**: Uses `auth(Storage)` in prepare, proper entitlement for withdraw, pre/post conditions

- "How do I deploy my contract to mainnet?"
  - **Expected**: Account creation, key file security, deployment command, update flag for changes
