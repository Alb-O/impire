# pandoc-media.nu - Extract embedded media from markdown files
#
# Usage:
#   pandoc-media input.md                    # Output to input/input.md + input/assets/
#   pandoc-media input.md --assets images    # Custom assets directory name

# Extract media from a markdown file using pandoc
export def main [
    input: path                              # Input markdown file
    --assets (-a): string = "assets"         # Directory name for extracted media
    --verbose (-v)                           # Show pandoc output
] {
    # Validate input file exists
    if not ($input | path exists) {
        error make {msg: $"Input file not found: ($input)"}
    }

    # Validate input is a file
    if ($input | path type) != "file" {
        error make {msg: $"Input is not a file: ($input)"}
    }

    # Parse input path
    let parsed = $input | path parse
    let stem = $parsed.stem
    let filename = $parsed.stem + "." + ($parsed.extension | default "md")
    let parent = $parsed.parent | default "."

    # Create output directory named after the file
    let out_dir = [$parent $stem] | path join
    let out = [$out_dir $filename] | path join
    let assets_dir = [$out_dir $assets] | path join

    # Create directories
    mkdir $out_dir
    mkdir $assets_dir
    if $verbose {
        print $"Created output directory: ($out_dir)"
        print $"Created assets directory: ($assets_dir)"
    }

    # Run pandoc
    if $verbose {
        print $"Converting: ($input) -> ($out)"
        print $"Extracting media to: ($assets_dir)"
    }

    let result = (
        pandoc $input
            -f markdown+rebase_relative_paths
            -t markdown
            $"--extract-media=($assets_dir)"
            -o $out
        | complete
    )

    if $result.exit_code != 0 {
        error make {msg: $"pandoc failed: ($result.stderr)"}
    }

    if $verbose and ($result.stderr | str trim | is-not-empty) {
        print $"pandoc: ($result.stderr | str trim)"
    }

    # Report results
    let media_files = if ($assets_dir | path exists) {
        glob $"($assets_dir)/**/*" | where {|f| ($f | path type) == "file" }
    } else {
        []
    }

    {
        input: ($input | path expand)
        output: ($out | path expand)
        assets: ($assets_dir | path expand)
        media_count: ($media_files | length)
    }
}
