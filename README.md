
# My personal NixOS configuration
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

### File structure
1. `configurations` - Main system configuration. `base.nix` contains lots of useful defaults. `*.host.nix` files contain host specific configurations.
2. `home-manager` - Holds most of the desktop configuration. Obviously relies on `home-manager` flake.
3. `modules` - Represents `flake.nixosModules`.
4. `overlays` - Contains riced and custom packages. Riced packages have the name prefix `g-`.
5. `flake.nix` - Kickass flake config ;)
6. `repl.nix` - Kickass repl ;)
