{ lib, pkgs, ... }:
let
  inherit (lib) getExe getExe';
in
{
  systemd.services.zfullfs = {
    serviceConfig = {
      ExecStartPre = [ "${getExe' pkgs.coreutils "mkdir"} -p /full" ];
      ExecStart = "${getExe pkgs.zfullfs} rpool /full";
    };

    wantedBy = [ "multi-user.target" ];
  };

  home-manager.sharedModules = [{
    # sometimes waybar starts before hyprland and then crashes
    # fix: just restart it until it works
    systemd.user.services.waybar = {
      Service.RestartSec = 1;
      Unit.StartLimitIntervalSec = 0;
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.targets = [ "graphical-session.target" ];
      style = ./style.css;

      settings.mainBar = {
        layer = "top";
        position = "top";
        spacing = 2;
        ipc = true;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "disk"
          "temperature"
          "backlight"
          "battery"
          "clock"
          "idle_inhibitor"
          "tray"
        ];

        "hyprland/workspaces" = {
          all-outputs = false;
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "10" = "10";
            "2" = "";  
            "3" = "";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
          };       
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = " ";
            default = [ " " " " "󰕾 " " " ];
          };
        };

        network = {
          family = "ipv4";

          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ipaddr}/{cidr} 󰈀 ";
          tooltip-format = "{ifname} via {gwaddr} 󰈀 ";
          format-linked = "{ifname} (No IP) 󰀦 ";
          format-disconnected = "Disconnected 󰀦 ";
        };

        cpu = {
          format = "{usage}%  ";
          tooltip = false;
        };

        memory = {
          format = "{}%  ";
        };

        disk = {
          format = "{percentage_used}% 󰋊 ";
          path = "/full";
        };

        temperature = {
          critical-threshold = 70;
          format = "{temperatureC}°C {icon}";
          format-critical = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" "" ];
          hwmon-path = "/dev/cpu_temp";
        };

        backlight = {
          device = "amdgpu";
          format = "{percent}% {icon}";
          format-icons = [ "󰃚 " "󰃛 " "󰃜 " "󰃝 " "󰃞 " "󰃟 " "󰃠 " ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{time} {capacity}% {icon}";
          format-charging = "{time} {capacity}% {icon} 󱐋";
          format-plugged = "{capacity}%  ";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        clock = {
          format = "{:%T}";
          interval = 1;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "months";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        idle_inhibitor = {
          format = "{icon} ";
          format-icons = {
            activated = "󰈈";
            deactivated = "󰈉";
          };
        };

        tray.spacing = 10;
      };
    };
  }];
}
