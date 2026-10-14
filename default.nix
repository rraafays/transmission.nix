{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = config.common.username;
  cfg = config.services.transmissionClient;
in
{
  options.services.transmissionClient = {
    enable = lib.mkEnableOption "Transmission BitTorrent client";
    downloadPath = lib.mkOption {
      type = lib.types.str;
      default = "/away/main/Downloads";
      description = "Download directory for Transmission.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open Transmission peer ports via services.transmission.openFirewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.downloads = { };

    users.users.${user} = {
      extraGroups = lib.mkAfter [ "downloads" ];
    };

    users.users.transmission.extraGroups = [ "downloads" ];

    services.transmission = {
      enable = true;
      openRPCPort = true;
      openFirewall = cfg.openFirewall;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = "*";
        download-dir = cfg.downloadPath;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.downloadPath} 2775 ${user} downloads -"
    ];

    systemd.services.transmission.serviceConfig.UMask = lib.mkForce "0002";
  };
}
