# When you add custom packages, list them here
# These are similar to nixpkgs packages
{ pkgs }:
{
  gtkcord4 = pkgs.callPackage ./gtkcord4.nix { };
}
