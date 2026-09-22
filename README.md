# GitHub Streak & Consecutive Contribution Bot

An automated GitHub Actions workflow and local utility designed to maintain an active, unbroken consecutive contribution streak (green squares) on your GitHub profile.

---

## ⚡ How It Works

1. **Automated Daily Schedule**: A GitHub Actions workflow runs every day at **9:00 AM IST** (`03:30 UTC`).
2. **Author Attribution**: Commits are automatically authored under your verified GitHub identity (`Lohith Ravi <lohitravi69@gmail.com>`) so GitHub credits every single commit to your profile graph.
3. **Commit & Push**: Generates timestamped daily files and pushes them directly to the default `main` branch.
4. **Optional Cleanup**: Supports automatic removal and cleanup commits if you prefer keeping the repository lean.

---

## 📋 GitHub Contribution Requirements Checklist

To ensure your GitHub profile accurately reflects your daily streak:

- [x] **Author Email Matching**: Commit author email must match the primary or verified email on your GitHub account (`lohitravi69@gmail.com`).
- [x] **Default Branch**: All streak commits must target the default branch (`main`).
- [x] **Repository Permissions**: Ensure **Settings → Actions → General → Workflow permissions** is set to **Read and write permissions**.
- [x] **Private Repository Setting** *(if repo is private)*: In your GitHub Profile settings, make sure **"Include private contributions on my profile"** is enabled.

---

## 🚀 Usage

### Option 1: Automated (GitHub Actions)
The workflow runs on autopilot every day at 03:30 UTC (9:00 AM IST). No manual intervention is needed.

### Option 2: Manual Trigger in GitHub UI
1. Navigate to the **Actions** tab on GitHub.
2. Select **Auto commit two files** from the workflow list.
3. Click **Run workflow**.
4. *(Optional)* Provide custom filenames or author overrides, then click **Run workflow**.

### Option 3: Run Locally (PowerShell on Windows)
Run the PowerShell script directly from the repository root:

```powershell
# Create daily streak commit and prompt to push
.\scripts\streak-commit.ps1

# Automatically commit and push in one step
.\scripts\streak-commit.ps1 -Push

# Commit, push, and perform cleanup
.\scripts\streak-commit.ps1 -Push -Cleanup
```

### Option 4: Run Locally (Bash / Git Bash / WSL / Linux)
```bash
./scripts/streak-commit.sh --push
```

---

## ⚙️ Configuration & Secrets (Optional)

If you wish to override author details dynamically via GitHub Secrets, add these under **Settings → Secrets and variables → Actions**:
- `COMMIT_AUTHOR_NAME`: Your GitHub username / full name (defaults to `Lohith Ravi`).
- `COMMIT_AUTHOR_EMAIL`: Your GitHub verified email (defaults to `lohitravi69@gmail.com`).