# set-git-branch-env.ps1

# Ensure you're in a Git repo
try {
    $gitBranch = git rev-parse --abbrev-ref HEAD
} catch {
    Write-Error "Not in a Git repository. Make sure you're in the root of your project."
    exit 1
}

# Set environment variable for Terraform
$env:TF_VAR_git_branch = $gitBranch
Write-Host "Set TF_VAR_git_branch to '$gitBranch'"