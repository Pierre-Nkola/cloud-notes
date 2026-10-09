# Using cfn-guard as a CI/CD gate instead of fixing AWS Config findings after the fact

**Problem.** After a migration, an account had hundreds of open AWS Config findings. Fixing them one by one was slow, some fixes were destructive, and nothing stopped the same issues from coming back.

**What worked.** Move the checks left. Every CloudFormation template goes through two gates before any deployment:

```bash
cfn-lint templates/**/*.yaml
cfn-guard validate --data templates/ --rules rules/nist/ --show-summary fail
```

The pipeline fails if either gate fails. A change set is created and discarded early to catch deploy-time errors before the real StackSet rollout.

**Why it matters.** Config tells you what is already wrong. A guard gate keeps it from becoming wrong. Pair them: Config for drift, cfn-guard for prevention.
