# worktree-jump.nu - Fuzzy jump to git worktree directories
#
# Usage:
#   worktree-jump      # Interactive fuzzy selection
#   worktree-jump foo  # Filter to repos matching "foo"
#   j                  # Alias

const JUMP_PATTERN = "~/@/dev/*/@/main"

# Scan for worktree directories matching the pattern
def jump-scan []: nothing -> table {
    glob $JUMP_PATTERN
    | each {|p|
        let parts = $p | path split
        let dev_idx = $parts | enumerate | where item == "dev" | first | get index
        let repo = $parts | get ($dev_idx + 1)
        { name: $repo, path: $p }
    }
    | sort-by name
}

# Fuzzy jump to a git worktree
export def --env main [
    query?: string  # Optional filter for repo name
] {
    let repos = jump-scan

    if ($repos | is-empty) {
        error make {msg: $"No worktrees found matching ($JUMP_PATTERN)"}
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
