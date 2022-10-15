{ lib, ... }:

{
  main = {
    enable = true;
    # Allow setting homepage
    "0100"."0102"."browser.startup.page".value = 1;
    # Enable location bar using search
    "0800"."0801"."keyword.enabled".value = true;
  };
}
