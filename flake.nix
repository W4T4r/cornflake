{
  description = "Aggregated flake catalog for W4T4r's standalone Nix flakes";

  inputs = {
    bcompare5Flake = {
      url = "github:W4T4r/bcompare5-flake";
    };

    catppuccinFcitx5 = {
      url = "github:W4T4r/catppuccin-fcitx5-flake";
    };

    catppuccinGtk = {
      url = "github:W4T4r/catppuccin-gtk-flake";
    };

    catppuccinKvantum = {
      url = "github:W4T4r/catppuccin-kvantum-flake";
    };

    sddmTheme = {
      url = "github:W4T4r/sddm-theme";
    };
  };

  outputs = {
    bcompare5Flake,
    catppuccinFcitx5,
    catppuccinGtk,
    catppuccinKvantum,
    sddmTheme,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = f:
      builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        })
        systems);
    packageCatalogFor = system:
      builtins.foldl' (acc: attrs: acc // attrs) {} [
        (
          if bcompare5Flake ? packages && builtins.hasAttr system bcompare5Flake.packages
          then {
            bcompare5 = bcompare5Flake.packages.${system}.default;
          }
          else {}
        )
        (
          if catppuccinFcitx5 ? packages && builtins.hasAttr system catppuccinFcitx5.packages
          then {
            catppuccin-fcitx5 = catppuccinFcitx5.packages.${system}.catppuccin-fcitx5;
            catppuccin-fcitx5-rounded = catppuccinFcitx5.packages.${system}.catppuccin-fcitx5-rounded;
          }
          else {}
        )
        (
          if catppuccinGtk ? packages && builtins.hasAttr system catppuccinGtk.packages
          then {
            catppuccin-gtk = catppuccinGtk.packages.${system}.default;
          }
          else {}
        )
        (
          if catppuccinKvantum ? packages && builtins.hasAttr system catppuccinKvantum.packages
          then {
            catppuccin-kvantum = catppuccinKvantum.packages.${system}.default;
          }
          else {}
        )
        (
          if sddmTheme ? packages && builtins.hasAttr system sddmTheme.packages
          then {
            inherit
              (sddmTheme.packages.${system})
              sddm-theme
              sddm-theme-nixos-binary-black
              sddm-theme-nixos-binary-blue
              sddm-theme-nixos-catppuccin-macchiato
              sddm-theme-nixos-catppuccin-mocha
              sddm-theme-nixos-gear
              sddm-theme-nixos-moonscape
              sddm-theme-nixos-mosaic-blue
              sddm-theme-nixos-nineish-dark-gray
              sddm-theme-nixos-recursive
              sddm-theme-nixos-simple-dark-gray
              sddm-theme-nixos-waterfall
              sddm-theme-nixos-watersplash
              ;
          }
          else {}
        )
      ];
  in {
    packages = forAllSystems packageCatalogFor;

    apps = forAllSystems (system:
      if bcompare5Flake ? apps && builtins.hasAttr system bcompare5Flake.apps
      then {
        bcompare5 = bcompare5Flake.apps.${system}.default;
        default = bcompare5Flake.apps.${system}.default;
      }
      else {});

    overlays = {
      catppuccin-fcitx5 = catppuccinFcitx5.overlays.default;
      catppuccin-kvantum = catppuccinKvantum.overlays.default;
      default = final: prev:
        catppuccinFcitx5.overlays.default final prev
        // catppuccinKvantum.overlays.default final prev;
    };

    homeManagerModules = {
      bcompare5 = bcompare5Flake.homeManagerModules.default;
      catppuccin-fcitx5 = catppuccinFcitx5.homeManagerModules.default;
      catppuccin-kvantum = catppuccinKvantum.homeManagerModules.default;
      default = {
        imports = [
          bcompare5Flake.homeManagerModules.default
          catppuccinFcitx5.homeManagerModules.default
          catppuccinKvantum.homeManagerModules.default
        ];
      };
    };

    nixosModules = {
      catppuccin-fcitx5 = catppuccinFcitx5.nixosModules.default;
      catppuccin-kvantum = catppuccinKvantum.nixosModules.default;
      sddm-theme = sddmTheme.nixosModules.default;
      default = {
        imports = [
          catppuccinFcitx5.nixosModules.default
          catppuccinKvantum.nixosModules.default
          sddmTheme.nixosModules.default
        ];
      };
    };

    lib.catalog = {
      bcompare5 = {
        repo = "github:W4T4r/bcompare5-flake";
        systems = ["x86_64-linux"];
      };
      catppuccin-fcitx5 = {
        repo = "github:W4T4r/catppuccin-fcitx5-flake";
        systems = ["x86_64-linux" "aarch64-linux"];
      };
      catppuccin-gtk = {
        repo = "github:W4T4r/catppuccin-gtk-flake";
        systems = systems;
      };
      catppuccin-kvantum = {
        repo = "github:W4T4r/catppuccin-kvantum-flake";
        systems = ["x86_64-linux" "aarch64-linux"];
      };
      sddm-theme = {
        repo = "github:W4T4r/sddm-theme";
        systems = systems;
      };
    };
  };
}
