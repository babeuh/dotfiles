{ pkgs, config, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Babeuh";
    userEmail = "60193302+babeuh@users.noreply.github.com";

    aliases = { graph = "log --decorate --oneline --graph"; };

    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow";
          file-decoration-style = "none";
        };
      };
    };

    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
      url."https://github.com/".insteadOf = "git://github.com/";
      # Signing
      commit.gpgsign = true;
      tag.gpgsign = true;
      push.gpgsign = "if-asked";
      gpg.format = "ssh";
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519_sk.pub";
    };
    lfs = { enable = true; };
    ignores = [ ".direnv" "result" ];
  };
}
