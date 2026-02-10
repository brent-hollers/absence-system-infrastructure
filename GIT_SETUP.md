**Here's GIT_SETUP.md - Your Git Workflow Guide:**

```markdown
# Git Repository Setup Guide

## Step 1: Verify Bootstrap is Complete

Before setting up Git, ensure your bootstrap terraform apply has completed:

```bash
cd infrastructure/bootstrap
terraform output
```

You should see outputs like:
```
backend_config = ...
lock_table_name = "absence-system-terraform-locks"
state_bucket_name = "hollers-absence-tfstate-123456789012"
```

## Step 2: Create GitHub Repository

### Option A: Via GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `staff-absence-system` (or your preferred name)
3. Description: "Enterprise absence tracking system with IaC (Terraform) and SRE practices"
4. **Keep it Private** (for now - contains AWS account info)
5. **Do NOT** initialize with README, .gitignore, or license (we have those)
6. Click "Create repository"

### Option B: Via GitHub CLI

```bash
gh repo create staff-absence-system --private --description "Enterprise absence tracking system with IaC"
```

## Step 3: Review Files Before Committing

**CRITICAL CHECK:** Make sure these are in .gitignore:

```powershell
# Check .gitignore contains:
type .gitignore | findstr /C:"tfstate" /C:"tfvars" /C:"credentials" /C:".env"
```

You should see:
```
*.tfstate
*.tfvars
**/credentials
.env
```

**EXCEPTION:** Bootstrap state IS committed (this is intentional):
```
!infrastructure/bootstrap/terraform.tfstate
```

## Step 4: Review What Will Be Committed

```powershell
# Check current status
git status

# See all files that will be added
git ls-files --others --exclude-standard
```

**VERIFY:** You should see:
- ✅ .gitignore
- ✅ README.md
- ✅ LICENSE
- ✅ INTERVIEW_CHECKLIST.md
- ✅ INTERVIEW_QUICK_REF.md
- ✅ infrastructure/bootstrap/main.tf
- ✅ infrastructure/bootstrap/outputs.tf
- ✅ infrastructure/bootstrap/README.md
- ✅ infrastructure/bootstrap/terraform.tfstate (intentionally included!)
- ✅ infrastructure/modules/ (empty folders OK)

**MUST NOT SEE:**
- ❌ .terraform/ directories
- ❌ *.tfvars files (except .example)
- ❌ AWS credentials
- ❌ .env files
- ❌ .terraform.lock.hcl

## Step 5: Stage Files

```powershell
# Add all files
git add .

# Check what's staged
git status

# Review the files to be committed
git diff --cached --name-only
```

## Step 6: Make Initial Commit

```powershell
git commit -m "feat: bootstrap remote state backend and project structure

- Created S3 bucket for Terraform state storage
- Created DynamoDB table for state locking
- Implemented modular directory structure
- Added comprehensive documentation
- Security: versioning, encryption, public access block

Bootstrap state intentionally committed for team reference."
```

## Step 7: Connect to GitHub

Replace `YOUR_USERNAME` with your actual GitHub username and `REPO_NAME` with your repository name:

```powershell
# Add remote (HTTPS method)
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

**If using SSH instead:**
```powershell
git remote add origin git@github.com:YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

## Step 8: Verify on GitHub

1. Go to your repository: `https://github.com/YOUR_USERNAME/REPO_NAME`
2. Check that files are present
3. Verify .gitignore is working (no .terraform/ folders visible)
4. Check that bootstrap terraform.tfstate IS visible (intentional)
5. Review README.md renders correctly

## Step 9: Set Up Branch Protection (Optional but Recommended)

For interview demonstration purposes:

1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Check "Require pull request reviews before merging"
4. Save changes

This shows you understand Git workflow best practices.

## Common Issues

### Issue: Too many files being committed

**Problem:** Seeing .terraform/ or *.tfstate files (other than bootstrap)
**Solution:** 
```powershell
git reset
git rm --cached -r .terraform/
git rm --cached **/*.tfstate
git add .
git commit -m "fix: update gitignore"
```

### Issue: Can't push to GitHub - Authentication failed

**Problem:** Username/password authentication no longer works
**Solution:** Use personal access token instead of password

1. Generate token: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token
2. Select scopes: `repo` (full control)
3. Copy the token (you won't see it again!)
4. Use token as password when pushing

Or set up SSH:
```powershell
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to SSH agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
type ~\.ssh\id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
# Then use SSH remote URL
git remote set-url origin git@github.com:YOUR_USERNAME/REPO_NAME.git
```

### Issue: Bootstrap state accidentally excluded

**Problem:** terraform.tfstate not in repo
**Solution:**
```powershell
git add -f infrastructure/bootstrap/terraform.tfstate
git commit -m "fix: include bootstrap state for team reference"
git push
```

### Issue: Wrong branch name

**Problem:** On "master" instead of "main"
**Solution:**
```powershell
git branch -M main
git push -u origin main
```

## Git Workflow for Future Changes

```powershell
# Create feature branch
git checkout -b feature/add-monitoring-module

# Make changes
# ...

# Stage and commit
git add .
git commit -m "feat: add CloudWatch monitoring module"

# Push branch
git push origin feature/add-monitoring-module

# Create pull request on GitHub
# After review and approval, merge to main
```

## Interview Talking Points

**Why commit bootstrap state?**
"Bootstrap state is an exception to the 'never commit state' rule because:
1. It rarely changes (one-time setup)
2. Aids disaster recovery
3. Documents the backend configuration
4. The repo has restricted access
5. Contains no sensitive credentials, just resource IDs"

**Git workflow for infrastructure?**
"I use feature branches for all changes, requiring pull requests for main branch. Each PR includes terraform plan output for review. This ensures infrastructure changes are peer-reviewed before applying, preventing costly mistakes."

**How do you handle secrets?**
"Never commit secrets to Git. Use AWS Secrets Manager, environment variables, or terraform.tfvars (which is gitignored). For CI/CD, inject secrets at runtime from secure vaults."

---

## Next Steps After Git Setup

Once your repo is live:

1. ✅ Bootstrap deployed and committed
2. ⏭️ Create `infrastructure/backend.tf` with remote state config
3. ⏭️ Build networking module
4. ⏭️ Build compute module
5. ⏭️ Deploy full infrastructure

You're making excellent progress! 🚀

---

## Commit Message Convention

Use semantic commit messages:

- `feat:` - New feature or module
- `fix:` - Bug fix
- `docs:` - Documentation only
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks
- `test:` - Adding tests

Examples:
```
feat: add CloudWatch monitoring module
fix: correct security group ingress rules
docs: update README with architecture diagram
refactor: modularize networking configuration
```

---

## Emergency Git Commands

**Undo last commit (before push):**
```powershell
git reset --soft HEAD~1  # Keep changes staged
git reset HEAD~1         # Keep changes unstaged
```

**Undo changes to a file:**
```powershell
git checkout -- filename.tf
```

**See commit history:**
```powershell
git log --oneline
git log --graph --oneline --all
```

**Check what changed:**
```powershell
git diff                 # Unstaged changes
git diff --staged        # Staged changes
git diff HEAD~1          # Last commit
```
```

---

**Save this as `GIT_SETUP.md` in your project root.**

---

**Quick check after saving:**

```powershell
git status
```

You should now see 6 untracked files:
1. `.gitignore`
2. `README.md`
3. `LICENSE`
4. `INTERVIEW_CHECKLIST.md`
5. `INTERVIEW_QUICK_REF.md`
6. `GIT_SETUP.md`
7. `infrastructure/` (directory)

