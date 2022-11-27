args@{ pkgs, lib, config, ... }:

let
  inherit (builtins) foldl';
  inherit (lib) mapAttrsToList nameValuePair;
  foldOverAttrs = init: op: attrs:
    (foldl' (acc: attr:
      let nattr = op acc.acc attr.name attr.value;
      in {
        acc = nattr.acc;
        value = acc.value // { "${attr.name}" = nattr.value; };
      }) {
        acc = init;
        value = { };
      } (mapAttrsToList nameValuePair attrs)).value;

  blackMagic = func: attrs:
    (foldl' (acc: orig:
      let result = func acc.acc orig.name orig.value;
      in {
        acc = result.acc;
        value = acc.value // result.value;
      }) {
        acc = 0;
        value = { };
      } (mapAttrsToList nameValuePair attrs)).value;

  addons = pkgs.nur.repos.rycee.firefox-addons;
  arkenfox = import ./arkenfox.nix { inherit lib; };
  themer = import ./theme.nix { inherit pkgs config; };

  profiles = {
    "Secure" = {
      default = true;
      homepage = "about:blank";
      arkenfox = [ arkenfox.main ];
      theme = true;
    };
    "Insecure" = { homepage = "about:blank"; };
  };

  buildTheme = id: name: profile: {
    acc = id + 1;
    value = {} // (if profile ? theme then import ./theme.nix ( args // { profile = name; } ) else {});
  };

  buildProfile = id: name: profile: {
    acc = id + 1;
    value = {
      inherit name id;
      settings = {
        "browser.startup.homepage" = profile.homepage;
        "browser.rememberSignons" = false; # Disable password manager
        "ui.systemUsesDarkTheme" = true;
      } // (if profile ? settings then profile.settings else { });
      isDefault = if profile ? default then profile.default else false;
      arkenfox = lib.mkMerge ([{ enable = true; }]
        ++ (if profile ? arkenfox then profile.arkenfox else [ ]));
    };
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr.override {
      extraPolicies = {
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        SearchEngines = { Default = "DuckDuckGo"; };
        Preferences = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = {
            Value = true;
            Status = "locked";
          };
        };
      };
    };

    arkenfox.version = "102.0";
    extensions = with addons; [ ublock-origin darkreader ];

    # TODO: Make this better
    profiles = foldOverAttrs 0 buildProfile profiles;
  };
  # Theming black magic
  home.file = blackMagic buildTheme profiles;
}
