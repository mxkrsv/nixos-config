{ config, lib, ... }: {
  # Do not automatically start on boot
  systemd.services.sing-box = {
    wantedBy = lib.mkForce [ ];
  };

  services.sing-box = {
    enable = true;

    settings = {
      dns = {
        servers = [
          {
            tag = "google";
            address = "tls://8.8.8.8";
          }
          #{
          #  tag = "cloudflare";
          #  address = "https://1.1.1.1/dns-query";
          #  detour = "vless-out";
          #}
          {
            tag = "local";
            address = "1.1.1.1";
            detour = "direct";
          }
        ];

        rules = [
          {
            outbound = "any";
            server = "local";
          }
        ];

        #final = "local";

        strategy = "ipv4_only";
      };

      inbounds = [
        {
          type = "tun";
          address = [ "172.19.0.1/30" ];
          auto_route = true;
          strict_route = true;
          #sniff = true;
          #sniff_override_destination = true;
        }
      ];

      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
        {
          type = "block";
          tag = "block";
        }
        {
          type = "dns";
          tag = "dns-out";
        }
        {
          type = "vless";
          tag = "vless-out";

          server = "kyoko.mxkrsv.dev";
          server_port = 443;

          flow = "xtls-rprx-vision";
          #flow = "";
          #network = "tcp";
          packet_encoding = "xudp";

          uuid = {
            _secret = config.age.secrets.singbox_uuid.path;
          };

          tls = {
            enabled = true;
            server_name = "kyoko.mxkrsv.dev";
            utls = {
              enabled = true;
              fingerprint = "chrome";
            };
          };
        }
      ];

      route = {
        rules = [
          {
            protocol = "dns";
            outbound = "dns-out";
          }
          {
            ip_is_private = true;
            outbound = "direct";
          }
        ];

        final = "vless-out";

        auto_detect_interface = true;
      };
    };
  };
}
