{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.podman;
  types = lib.types;
  podmanSetupScript = let
    registriesConf = pkgs.writeText "registries.conf" ''
      [registries.search]
      registries = ['docker.io']
      [registries.block]
      registries = []
    '';
  in
    pkgs.writeScript "podman-setup" ''
      #!${pkgs.runtimeShell}
      # Dont overwrite customised configuration
      if ! test -f ~/.config/containers/policy.json; then
        install -Dm555 ${pkgs.skopeo.src}/default-policy.json ~/.config/containers/policy.json
      fi
      if ! test -f ~/.config/containers/registries.conf; then
        install -Dm555 ${registriesConf} ~/.config/containers/registries.conf
      fi
    '';

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "docker-podman-compat" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.podman}/bin/podman $out/bin/docker
  '';
in {
  options.programs.podman = {
    enable = lib.mkEnableOption "podman";

    package = lib.mkOption {
      type = types.package;
      description = "Which package of Podman to use";
      default = pkgs.podman;
      defaultText = lib.literalExpression "pkgs.podman";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [
      cfg.package
      dockerCompat
      pkgs.runc # Container runtime
      pkgs.slirp4netns # User-mode networking for unprivileged namespaces
      pkgs.fuse-overlayfs # CoW for images, much faster than default vfs
    ];
    enterShell = ''
      # Install required configuration
      ${podmanSetupScript}

      for sock in $XDG_RUNTIME_DIR/podman/podman.sock /var/run/docker.sock /var/run/podman/podman.sock; do
        if [ -S $sock ]; then
          export DOCKER_HOST=unix://$sock
          break
        fi
      done
    '';
  };
}
