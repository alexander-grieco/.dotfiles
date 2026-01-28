# Fix YAML Syntax Error in action.yml

## Problem
The `action.yml` file has a YAML syntax error at line 178. The issue is caused by escaped backticks (`\``) within a JavaScript template literal that's embedded in a YAML `script:` block.

## Root Cause
Lines 179 and 182 contain:
```
1. Ensure Atlantis has commented with \`terraform plan\` output
**Atlantis bot name:** \`${{ inputs.atlantis-bot-name }}\`
```

The combination of:
1. YAML syntax
2. JavaScript template literals (backticks)
3. Escaped backticks for markdown code formatting
4. GitHub Actions expressions `${{ }}`

...is causing the YAML parser to fail.

## Solution
Replace the escaped backticks with simple single quotes for markdown formatting, which is YAML-safe.

### File to Modify
- `/Users/alex/dapper/actions/terraform-ai-review/action.yml` (lines 179 and 182)

### Changes
**Line 179:** Change from:
```
1. Ensure Atlantis has commented with \`terraform plan\` output
```
To:
```
1. Ensure Atlantis has commented with 'terraform plan' output
```

**Line 182:** Change from:
```
**Atlantis bot name:** \`${{ inputs.atlantis-bot-name }}\`
```
To:
```
**Atlantis bot name:** '${{ inputs.atlantis-bot-name }}'
```

## Verification
After making the change:
1. Commit and push to `infra-ai-reviews` branch
2. Try to run the test workflow again in the infrastructure repo
3. The action should load successfully without YAML parsing errors
