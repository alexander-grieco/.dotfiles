# Go Testing with Overflow

The Overflow library provides Go-based testing for Cadence contracts with automatic emulator management.

## When to Use Overflow

Overflow is the preferred choice for:
- **End-to-end flows** - Test complete user journeys across multiple transactions
- **Multi-user scenarios** - Test interactions between different accounts
- **Transaction sequences** - Test state changes across related operations

Overflow auto-creates and funds test accounts, so you don't need to pre-define accounts in flow.json for Go tests. For CLI-based manual testing, pre-define accounts like `alice` and `bob` in flow.json instead.

For pure Cadence unit tests (testing individual contract functions in isolation), `flow test` may be simpler. See the Testing Strategy section in [SKILL.md](SKILL.md).

## CGO Requirement

**Flow/Overflow libraries require CGO** for cryptographic operations:

```bash
CGO_ENABLED=1 go test -v ./...
```

Without CGO, you'll see errors like `undefined: blsInstance` or `undefined: initBLS12381`.

## Setup Configuration

```go
func setupOverflow() *overflow.OverflowState {
    basePath := "../.."  // Adjust based on test file location
    return overflow.Overflow(
        overflow.WithBasePath(basePath),
        overflow.WithFlowConfig(basePath+"/flow.json"),
        overflow.WithLogNone(),  // Or WithLogInfo() for debugging
        overflow.WithTransactionFolderName("cadence/transactions"),
        overflow.WithScriptFolderName("cadence/scripts"),
    )
}
```

## Key Configuration Options

| Option | Purpose |
|--------|---------|
| `WithBasePath(path)` | Sets base directory for finding contracts |
| `WithFlowConfig(path)` | Explicitly specifies flow.json location |
| `WithTransactionFolderName(name)` | Where to find .cdc transaction files |
| `WithScriptFolderName(name)` | Where to find .cdc script files |
| `WithLogNone()` | Suppresses output (use for tests) |
| `WithLogInfo()` | Shows transaction/deployment info (debugging) |
| `WithNoPrefixToAccountNames()` | Don't prepend network name to accounts |
| `WithReturnErrors()` | Return errors instead of panicking |

## Account Naming Convention

By default, overflow prepends the network name to account names:

- `"account"` becomes `"emulator-account"`
- `"first"` becomes `"emulator-first"`

The conventional names `alice`, `bob`, etc. work the same way - Overflow looks for `emulator-alice`, `emulator-bob` in flow.json. However, Overflow auto-creates these accounts when running tests, so you typically don't need to define them manually (only define them if you need CLI-based testing with `flow transactions send --signer alice`).

**Use short names in tests**, and let overflow prepend the network:

```go
// In test code
overflow.WithSigner("first")    // Uses "emulator-first" from flow.json
overflow.WithSigner("account")  // Uses "emulator-account"

// DON'T do this (double prefix)
overflow.WithSigner("emulator-account")  // Becomes "emulator-emulator-account"!
```

## flow.json Account Setup for Tests

Accounts must be defined in flow.json with valid addresses AND listed in deployments for overflow to create them:

```json
{
  "accounts": {
    "emulator-account": {
      "address": "f8d6e0586b0a20c7",
      "key": "ae1b44c0f5e8f6992ef2348898a35e50a8b0b9684000da8b1dade1b3bcd6ebee"
    },
    "emulator-first": {
      "address": "0x179b6b1cb6755e31",
      "key": "d5457a187e9642a8e49d4032b3b4f85c92da7202c79681d9302c6e444e7033a8"
    },
    "emulator-second": {
      "address": "0xf3fcd2c1a78f5eee",
      "key": "d5457a187e9642a8e49d4032b3b4f85c92da7202c79681d9302c6e444e7033a8"
    }
  },
  "deployments": {
    "emulator": {
      "emulator-account": ["MyContract"],
      "emulator-first": [],
      "emulator-second": []
    }
  }
}
```

**Important:** The addresses `0x179b6b1cb6755e31` and `0xf3fcd2c1a78f5eee` are the exact addresses the embedded emulator assigns to the first two created accounts. Using different addresses will cause failures.

## Common API Patterns

```go
// Transaction with signer and arguments
o.Tx("transaction_name",
    overflow.WithSigner("first"),
    overflow.WithArg("amount", "100.0"),
    overflow.WithArg("token", "CATS"),
).AssertSuccess(t)

// Script with arguments
result := o.Script("script_name",
    overflow.WithArg("user", "first"),
    overflow.WithArg("token", "CATS"),
)
require.NoError(t, result.Err)

// Check for expected failure
result := o.Tx("should_fail_transaction",
    overflow.WithSigner("first"),
)
assert.Error(t, result.Err)
```

## Reading Script Results

`OverflowScriptResult` does NOT have a `.String()` method. Use:

```go
// Access the cadence.Value directly
result.Result.String()

// Or get as Go interface
data, err := result.GetAsInterface()
priceMap := data.(map[string]interface{})

// Or get as JSON string
jsonStr, err := result.GetAsJson()
```

**Note:** `GetAsInterface()` returns `float64` for UFix64 values, not strings.

## Handling Expected Errors in Tests

By default, overflow panics on transaction errors. For tests that expect failures, use `WithReturnErrors()`:

```go
// Create a separate setup for error tests
func setupOverflowForErrorTests() *overflow.OverflowState {
    basePath := "../.."
    return overflow.Overflow(
        overflow.WithBasePath(basePath),
        overflow.WithFlowConfig(basePath+"/flow.json"),
        overflow.WithLogInfo(),
        overflow.WithTransactionFolderName("cadence/transactions"),
        overflow.WithScriptFolderName("cadence/scripts"),
        overflow.WithReturnErrors(), // Return errors instead of panicking
    )
}

// In test
func TestShouldFail(t *testing.T) {
    o := setupOverflowForErrorTests()

    result := o.Tx("should_fail_transaction",
        overflow.WithSigner("first"),
    )
    assert.Error(t, result.Err)
    assert.Contains(t, result.Err.Error(), "expected error message")
}
```

**Bug note:** `WithPanicInteractionOnError(false)` does NOT fully work in overflow v2.14.0 due to dual panic check locations. Use `WithReturnErrors()` in setup instead.

## Debugging Tips

1. **Enable logging** with `WithLogInfo()` to see account creation and contract deployment
2. **Check transaction events** in the result output to verify state changes
3. **Use `.Print()` on results** for formatted output during debugging
4. **Verify flow.json paths** are correct relative to test file location

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| `WithoutLog()` not working | Use `WithLogNone()` (builder option vs interaction option) |
| Path errors in tests | Test working directory is the package directory, not project root. Adjust `WithBasePath()` |
| "account not found" errors | Accounts must appear in `deployments` section, even with empty arrays |
| Address mismatch | Embedded emulator uses deterministic addresses. Use exact addresses shown above |
