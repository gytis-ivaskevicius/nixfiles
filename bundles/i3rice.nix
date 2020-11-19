
{ config, pkgs, ... }:

{
  imports = [
    ../modules/compton
    ../modules/i3
    ../modules/styling
    ../modules/ui-daemons
  ];

}
