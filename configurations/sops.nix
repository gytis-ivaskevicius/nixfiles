let
  secrets = [
    "desktop_public_key"
    "laptop_public_key"
    "desktop_private_key"
    "laptop_private_key"
    "zerotier_key"
  ];
  genDefaultPerms = secret: {
    ${secret} = {
      mode = "0440";
      owner = config.users.users.jrestivo.name;
      group = config.users.users.jrestivo.group;
    };
  };
  cfg = config.custom_modules.core_services;
in
{

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.secrets = (((lib.foldl' lib.mergeAttrs) { })
    (builtins.map genDefaultPerms secrets)) // { tailscale_key.owner = "root"; };
};
