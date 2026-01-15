# worktree-jump.nu - Fuzzy jump to git worktree directories
#
# Usage:
#   worktree-jump      # Interactive fuzzy selection
#   worktree-jump foo  # Filter to repos matching "foo"
#   j                  # Alias

const BRANCH_PRIORITY = ["main", "master", "dev"]

# Scan for worktree directories, preferring main > master > dev branches
def jump-scan []: nothing -> table {
    glob "~/@/dev/*/@"
    | each {|repo_at|
        let parts = $repo_at | path split
        let dev_idx = $parts | enumerate | where item == "dev" | first | get index
        let repo = $parts | get ($dev_idx + 1)

        # Find the first existing branch in priority order
        let branch = $BRANCH_PRIORITY | where {|b| ($repo_at | path join $b | path exists)} | first

        if $branch != null {
            { name: $repo, path: ($repo_at | path join $branch) }
        }
    }
    | compact
    | sort-by name
}

# Fuzzy jump to a git worktree
export def --env main [
    query?: string  # Optional filter for repo name
] {
    let repos = jump-scan

    if ($repos | is-empty) {
        error make {msg: "No worktrees found in ~/@/dev/*/@"}
    }

    let filtered = if $query != null {
        let q = $query | str downcase
        $repos | where {|r| ($r.name | str downcase) =~ $q }
    } else {
        $repos
    }

    if ($filtered | is-empty) {
        error make {msg: $"No repos matching '($query)'"}
    }

    let selected = if ($filtered | length) == 1 {
        $filtered | first
    } else {
        let formatted = $filtered | each {|r| {
            display: $"($r.name)  (ansi dark_gray)($r.path)(ansi reset)"
            ...$r
        }}
        $formatted | input list --fuzzy -d display "Jump to:"
    }

    if $selected == null {
        return
    }

    cd $selected.path
}
