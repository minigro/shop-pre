{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.pnpm;
  nodejs = config.languages.javascript.package;
  nodePkgs = nodejs.pkgs;
  pnpmPkg = nodePkgs.pnpm;

  nodeModulesPath = "node_modules";
  initScriptTemplate = ''
    function _devenv-pnpm-install()
    {
      # Avoid running "pnpm install" for every shell.
      # Only run it when the "pnpm-lock.yaml" file or nodejs version has changed.
      # We do this by storing the nodejs version and a hash of "pnpm-lock.yaml" in node_modules.
      local ACTUAL_NPM_CHECKSUM="${nodejs.version}:$(${pkgs.nix}/bin/nix-hash --type sha256 pnpm-lock.yaml)"
      local NPM_CHECKSUM_FILE="${nodeModulesPath}/pnpm-lock.yaml.checksum"
      if [ -f "$NPM_CHECKSUM_FILE" ]
        then
          read -r EXPECTED_NPM_CHECKSUM < "$NPM_CHECKSUM_FILE"
        else
          EXPECTED_NPM_CHECKSUM=""
      fi

      if [ "$ACTUAL_NPM_CHECKSUM" != "$EXPECTED_NPM_CHECKSUM" ]
      then
        if ${pnpmPkg}/bin/pnpm install
        then
          echo "$ACTUAL_NPM_CHECKSUM" > "$NPM_CHECKSUM_FILE"
        else
          echo "Npm install failed. Run 'pnpm install' manually."
        fi
      fi
    }

    if [ ! -f package.json ]
    then
      echo "No package.json found. Run 'pnpm init' to create one." >&2
    else
      _devenv-pnpm-install
    fi
  '';
  initNpmScript = pkgs.writeShellScript "init-pnpm.sh" initScriptTemplate;
in {
  options.programs.pnpm = {
    enable = lib.mkEnableOption "manage NodeJS packages with pnpm";
  };

  config = lib.mkIf cfg.enable {
    packages = [
      pnpmPkg
      #pkgs.nodePackages.pnpm
    ];

    enterShell = ''
      source ${initNpmScript}
    '';
  };
}
