# cornflake

`cornflake` is an aggregate flake for my standalone public flakes.

It provides one place to discover and consume:

- [`bcompare5-flake`](https://github.com/W4T4r/bcompare5-flake)
- [`catppuccin-fcitx5-flake`](https://github.com/W4T4r/catppuccin-fcitx5-flake)
- [`catppuccin-gtk-flake`](https://github.com/W4T4r/catppuccin-gtk-flake)
- [`catppuccin-kvantum-flake`](https://github.com/W4T4r/catppuccin-kvantum-flake)
- [`sddm-theme`](https://github.com/W4T4r/sddm-theme)

It is intended to be used alongside your own `nixpkgs` input rather than acting
as a shared `nixpkgs` pin for every member flake.

## What This Flake Exposes

### Packages

For each supported system, `cornflake` re-exports selected packages from the
member flakes:

- `packages.<system>.bcompare5`
- `packages.<system>.catppuccin-fcitx5`
- `packages.<system>.catppuccin-fcitx5-rounded`
- `packages.<system>.catppuccin-gtk`
- `packages.<system>.catppuccin-kvantum`
- `packages.<system>.sddm-theme`
- `packages.<system>.sddm-theme-nixos-*`

### Apps

- `apps.x86_64-linux.bcompare5`
- `apps.x86_64-linux.default`

### Modules

- `homeManagerModules.bcompare5`
- `homeManagerModules.catppuccin-fcitx5`
- `homeManagerModules.catppuccin-kvantum`
- `homeManagerModules.default`
- `nixosModules.catppuccin-fcitx5`
- `nixosModules.catppuccin-kvantum`
- `nixosModules.sddm-theme`
- `nixosModules.default`

### Overlays

- `overlays.catppuccin-fcitx5`
- `overlays.catppuccin-kvantum`
- `overlays.default`

## Add As An Input

```nix
{
  inputs.cornflake.url = "github:W4T4r/cornflake";
}
```

## Usage

### Install packages directly

```nix
{
  home.packages = [
    inputs.cornflake.packages.${pkgs.system}.bcompare5
    inputs.cornflake.packages.${pkgs.system}.catppuccin-gtk
    inputs.cornflake.packages.${pkgs.system}.catppuccin-kvantum
    inputs.cornflake.packages.${pkgs.system}.sddm-theme
  ];
}
```

For attributes containing hyphens, use quoted access when needed:

```nix
{
  home.packages = [
    inputs.cornflake.packages.${pkgs.system}."catppuccin-fcitx5"
    inputs.cornflake.packages.${pkgs.system}."catppuccin-fcitx5-rounded"
  ];
}
```

### Import all bundled modules

```nix
{
  imports = [
    inputs.cornflake.homeManagerModules.default
  ];
}
```

For NixOS:

```nix
{
  imports = [
    inputs.cornflake.nixosModules.default
  ];
}
```

To enable the bundled SDDM theme module:

```nix
{
  services.sddmTheme.enable = true;
  services.sddmTheme.variant = "nixos-catppuccin-mocha";
}
```

### Use the bundled overlays

```nix
{
  nixpkgs.overlays = [
    inputs.cornflake.overlays.default
  ];
}
```

## Notes

- `cornflake` does not replace the member repositories.
- Each project remains independently versioned and usable on its own.
- `cornflake` does not provide or pin a top-level `nixpkgs` follow target for
  the member flakes.
- `bcompare5` is re-exported from `bcompare5-flake`; the older `bcompare5`
  repository name is intentionally not used here.
