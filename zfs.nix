{ config, pkgs, ... }:

{
  boot.zfs.forceImportAll = false;
  boot.zfs.forceImportRoot = false;
}
