# transmission

BitTorrent via Transmission: RPC, peer firewall, `downloads` group, and download directory layout.

NixOS only. Requires `./common`. Independent of slskd (Soulseek); the host may point both at the same path.

Enable with `services.transmissionClient.enable = true`.
