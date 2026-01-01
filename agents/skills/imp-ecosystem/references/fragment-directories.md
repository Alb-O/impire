# Fragment Directories

## Auto-merged directories

Only these `.d` directories are auto-merged by `imp.tree`:

| Directory | Flake Output |
|-----------|--------------|
| `packages.d/` | `self'.packages` |
| `devShells.d/` | `self'.devShells` |
| `checks.d/` | `self'.checks` |
| `apps.d/` | `self'.apps` |
| `overlays.d/` | `self.overlays` |
| `nixosModules.d/` | `self.nixosModules` |
| `homeModules.d/` | `self.homeModules` |
| `darwinModules.d/` | `self.darwinModules` |
| `flakeModules.d/` | `self.flakeModules` |
| `nixosConfigurations.d/` | `self.nixosConfigurations` |
| `darwinConfigurations.d/` | `self.darwinConfigurations` |
| `homeConfigurations.d/` | `self.homeConfigurations` |
| `legacyPackages.d/` | `self.legacyPackages` |

## Merge behavior

Files sorted alphabetically, merged with `lib.recursiveUpdate`:

```
packages.d/
  00-base.nix      # { default = basePkg; core = { version = "1.0"; }; }
  10-extras.nix    # { extra = extraPkg; core = { debug = true; }; }
```

Result:
```nix
{
  default = basePkg;
  extra = extraPkg;
  core = { version = "1.0"; debug = true; };  # recursively merged
}
```

## Base file + fragments

When both exist, they merge (base first, fragments on top):

```
devShells.nix        # { default = myShell; }
devShells.d/
  10-injected.nix    # { lintfra = lintShell; }
```

Result: `{ default = myShell; lintfra = lintShell; }`

## Fragment file patterns

### Simple attrset
```nix
{ myPkg = derivation; }
```

### Function (receives flake-parts args)
```nix
{ pkgs, self', inputs', ... }:
{ myPkg = pkgs.hello; }
```

### With file-level inputs
```nix
{
  __inputs = {
    foo.url = "github:owner/foo";
  };
  __functor = _: { pkgs, foo, ... }:
    { myPkg = foo.packages.${pkgs.system}.default; };
}
```

## Manual fragments (imp.fragments)

For non-output `.d` directories, use `imp.fragments` or `imp.fragmentsWith`:

```nix
{ imp, pkgs, ... }:
let
  # String concatenation (shell scripts)
  hooks = imp.fragments ./shellHook.d;
  
  # With args passed to each .nix file
  envVars = imp.fragmentsWith { inherit pkgs; } ./env.d;
in
{
  shellHook = hooks.asString;
  env = envVars.asAttrs;
}
```

### Fragment collection methods

| Method | Use case | Example |
|--------|----------|---------|
| `.list` | Raw list of fragments | Iteration |
| `.asString` | Concatenate with newlines | Shell scripts |
| `.asList` | Flatten nested lists | Package lists |
| `.asAttrs` | Merge attrsets | Environment variables |
