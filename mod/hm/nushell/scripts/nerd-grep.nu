# nerd-grep.nu - Fuzzy finder for Nerd Font icons
#
# Usage:
#   nerd-grep              # Interactive fuzzy selection
#   nerd-grep "folder"     # Search for icons matching "folder"
#   nerd-grep --refresh    # Force refresh cached icons

const NERD_GREP_URL = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json"
const NERD_GREP_CACHE_INTERVAL = 7day

# Get the cache directory path
def nerd-grep-cache-dir []: nothing -> path {
    let base = $env.XDG_CACHE_HOME? | default ($nu.home-path | path join ".cache")
    $base | path join "nerd-grep"
}

# Check if cache needs refresh based on timestamp
def nerd-grep-should-refresh [timestamp_path: path]: nothing -> bool {
    if not ($timestamp_path | path exists) { return true }

    let last_check = try {
        open $timestamp_path | str trim | into datetime
    } catch {
        return true
    }

    (date now) - $last_check > $NERD_GREP_CACHE_INTERVAL
}

# Ensure icons are cached, fetching if needed
def nerd-grep-ensure-cached [--refresh (-r)]: nothing -> path {
    let cache_dir = nerd-grep-cache-dir
    let json_path = $cache_dir | path join "glyphnames.json"
    let ts_path = $cache_dir | path join "last_check"

    if not ($cache_dir | path exists) {
        mkdir $cache_dir
    }

    let needs_fetch = $refresh or (not ($json_path | path exists)) or (nerd-grep-should-refresh $ts_path)

    if $needs_fetch {
        try {
            print -e "Fetching Nerd Font icons..."
            http get $NERD_GREP_URL | save -f $json_path
            date now | format date "%+" | save -f $ts_path
        } catch {|e|
            if ($json_path | path exists) {
                print -e $"Warning: Failed to update icons: ($e.msg)"
                date now | format date "%+" | save -f $ts_path
            } else {
                error make {msg: $"Failed to fetch icons: ($e.msg)"}
            }
        }
    }

    $json_path
}

# Load icons from cached JSON file
def nerd-grep-load-icons [json_path: path]: nothing -> table {
    open $json_path
    | transpose name info
    | where name != "METADATA"
    | each {|row| {
        name: $row.name
        char: $row.info.char
        code: $row.info.code
    }}
    | sort-by name
}

# Format icon for display in list
def nerd-grep-format-line [icon: record]: nothing -> string {
    $"($icon.char)  ($icon.name) \(($icon.code)\)"
}

# Format icon with full details
def nerd-grep-format-full [icon: record]: nothing -> record {
    {
        icon: $"($icon.char) "
        name: $icon.name
        code: $icon.code
        hex: $"0x($icon.code | str upcase)"
    }
}

# Search icons by name (case-insensitive substring match)
def nerd-grep-search [icons: table, query: string, max_results: int]: nothing -> table {
    let query_lower = $query | str downcase
    $icons
    | where {|icon| ($icon.name | str downcase) =~ $query_lower }
    | first $max_results
}

# Fuzzy finder for Nerd Font icons
export def main [
    query?: string              # Search query (enters non-interactive mode if provided)
    --max-results (-n): int = 10  # Maximum number of results in non-interactive mode
    --refresh (-r)              # Force refresh of cached icon data
] {
    let json_path = nerd-grep-ensure-cached --refresh=$refresh
    let icons = nerd-grep-load-icons $json_path

    if $query != null {
        if ($query | str trim | is-empty) {
            error make {msg: "query cannot be empty"}
        }

        let results = nerd-grep-search $icons $query $max_results

        if ($results | is-empty) {
            error make {msg: $"No icons found matching '($query)'"}
        }

        $results | select char name code
    } else {
        let formatted = $icons | each {|icon| {
            display: (nerd-grep-format-line $icon)
            ...$icon
        }}

        let selected = $formatted | input list --fuzzy -d display "Select icon"

        if $selected == null {
            return
        }

        nerd-grep-format-full $selected
    }
}
