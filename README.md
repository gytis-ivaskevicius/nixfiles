
# My personal NixOS configuration

### File structure
The configuration is separated into two parts:
1. `bundles` - More abstract configurations that often depend on multiple `modules` and implement more complex configurations.
2. `modules` - Small package-specific configurations.


Here are a few commonly used configs:
```
├── bundles
│  ├── apps.nix          - Adds desktop applications that I usually use.
│  ├── base.nix          - Base system configuration, a lot of magic goes on in here.
│  ├── clean_home.nix    - Adds environment variables which reduce clutter in '$HOME' directory.
│  ├── dev.nix           - Adds modules that I use on daily basis for development purposes.
│  ├── i3rice.nix        - My glorious I3 configuration.
│  └── unstable.nix      - Allows to specify unstable packages with such syntax: 'unstable.<package-name>'.
├── modules
│  └── autostart-systemd - Adds systemd user target which I use to start desktop applications.
├── configuration.nix    - Base configuration file.
└── personal.nix         - Untracted file, used for system-specific changes.
```

