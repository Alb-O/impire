# imp.gits Workflow

## Config file

Location: `.imp/gits/config.nix`

```nix
{
  # Optional: sparse checkout for main repo
  sparse = [ "src" "lib" "nix" ];
  
  # Optional: inject files from other repos
  injections = [
    {
      name = "lintfra";                              # required
      remote = "https://github.com/org/lintfra.git"; # required
      branch = "main";                               # optional (default: main)
      use = [                                        # required
        "lint/ast-rules"
        "nix/outputs/perSystem/packages.d/10-lint.nix"
        "nix/outputs/perSystem/devShells.d/10-lintfra.nix"
      ];
    }
  ];
}
```

## Commands

### Initialize

```bash
imp-gits init
```

- Clones injection repos to `.imp/gits/<name>.git/`
- Sets up sparse checkout for injected paths
- Checks out files into workspace

### Update

```bash
imp-gits pull          # Fetch and merge
imp-gits pull --force  # Fetch and force checkout (overwrites local changes)
```

`--force` only affects files in the injection's `use` list, not other local files.

### Status

```bash
imp-gits status
```

Shows status of main repo and all injections.

### Push changes

```bash
imp-gits push
```

Push changes back to injection remotes. Prompts for confirmation.

### Switch context

```bash
# bash/zsh
eval "$(imp-gits use lintfra)"   # Switch to injection
eval "$(imp-gits use main)"      # Switch back

# fish
eval (imp-gits use lintfra)
eval (imp-gits exit)

# nushell
imp-gits use lintfra | from json | load-env
```

When in injection context, `git log`, `git diff`, etc. operate on that injection's history.

## Directory structure

After `imp-gits init`:

```
my-project/
├── .git/                        # Main repo
├── .imp/
│   └── gits/
│       ├── config.nix           # Config (tracked by main repo)
│       ├── .gitignore           # Ignores *.git/ dirs
│       └── lintfra.git/         # Injection git dir (ignored)
├── lint/
│   └── ast-rules/               # From lintfra
├── nix/
│   └── outputs/
│       └── perSystem/
│           ├── packages.d/
│           │   ├── 00-rust.nix      # Local
│           │   └── 10-lint.nix      # From lintfra
│           └── devShells.d/
│               └── 10-lintfra.nix   # From lintfra
└── flake.nix
```

## Workflow: Adding an injection

1. Add to config:

```nix
{
  injections = [
    {
      name = "lintfra";
      remote = "https://github.com/org/lintfra.git";
      use = [
        "lint/ast-rules"
        "nix/outputs/perSystem/packages.d/10-lint.nix"
      ];
    }
  ];
}
```

2. Initialize:

```bash
imp-gits init
```

3. Verify files appeared and flake works:

```bash
ls lint/ast-rules/
nix flake check
```

## Workflow: Updating injections

```bash
imp-gits pull         # Safe merge
# or
imp-gits pull --force # Overwrite local changes to injected files
```

## Workflow: Contributing back

1. Switch context:

```bash
eval "$(imp-gits use lintfra)"
```

2. Make changes, commit:

```bash
git add -A
git commit -m "Fix lint rule"
```

3. Push:

```bash
git push
# or
eval "$(imp-gits use main)"
imp-gits push
```

## Sparse checkout (optional)

For large repos, only checkout needed directories:

```nix
{
  sparse = [ "src" "lib" ];  # Cone mode (directories)
}
```

Or with patterns:

```nix
{
  sparse = {
    mode = "no-cone";
    patterns = [
      "/src/"
      "/lib/"
      "/README.md"
    ];
  };
}
```

## External target (submodules)

Configure sparse checkout for a submodule without modifying it:

```nix
{
  target = "submodule";  # Relative path
  sparse = [ "docs" "src" ];
}
```
