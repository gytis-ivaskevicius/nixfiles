{ lib, ... }:
let
  inherit (builtins) attrNames pathExists isAttrs readDir listToAttrs;
  inherit (lib) hasPrefix filterAttrs hasSuffix mapAttrs' nameValuePair removeSuffix;

  # mapFilterAttrs ::
  #   (name -> value -> bool )
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = seive: f: attrs: filterAttrs seive (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);

in
{
  inherit mapFilterAttrs genAttrs';

  mapModules = dir: fn:
    mapFilterAttrs
      (n: v:
        v != null &&
        !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in
        if v == "directory" && pathExists "${path}/default.nix"
        then nameValuePair n (fn path)
        else if v == "regular" &&
                n != "default.nix" &&
                hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  overlay = pkg: final: prev: {
    "${pkg.pname}" = pkg;
  };

  recImport = { dir, _import ? base: import "${dir}/${base}.nix" }:
    mapFilterAttrs
      (_: v: v != null)
      (n: v:
        if n != "default.nix" && hasSuffix ".nix" n && v == "regular"
        then
          let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)

        else
          nameValuePair ("") (null))
      (readDir dir);

  # Convert a list to file paths to attribute set
  # that has the filenames stripped of nix extension as keys
  # and imported content of the file as value.
  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });

}
