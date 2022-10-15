{ lib, ... }:

{
  main = {
    enable = true;
    # Enable location bar using search
    "0800"."0801"."keyword.enabled".value = true;
  };
}
