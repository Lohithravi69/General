# Auto commit two files

This repository contains a GitHub Actions workflow that commits exactly two files and can optionally remove them in a follow-up cleanup commit so the remote repository stays consistent.

## Usage

1. Open the Actions tab in GitHub.
2. Run the `Auto commit two files` workflow.
3. Provide two file paths that already exist in the repository.
4. Set `delete_after_push` to `true` if you want the files removed after the commit.

The workflow will:

1. Stage the two paths you provide.
2. Create and push a commit for those files.
3. Optionally delete both files and push a second cleanup commit.

## Notes

- The workflow requires `contents: write` permission.
- If either path does not exist, the workflow stops before committing.