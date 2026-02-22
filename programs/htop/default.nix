{ lib, ... }:
let
  rc = import ./rc-format.nix { inherit lib; };
  defaultConfig = import ./default-htoprc.nix;
in {
  xdg.configFile = {
    "htop/htoprc".text = rc.generate (defaultConfig // {
      header_layout = "two_50_50";
      column_meters_0 = [ "AllCPUs2" ];
      column_meter_modes_0 = [ 1 ];
      column_meters_1 = [
        "Memory" "Swap"
        "Blank"
        "GPU"
        "Blank"
        "NetworkIO" "DiskIO" "Uptime"
      ];
      column_meter_modes_1 = [ 1 1 2 1 2 2 2 2 ];

      cpu_count_from_one = true;
      show_cpu_temperature = true;

      screens = {
        "Main" = {
          order = 0;
          columns = [
            "PID" "USER" "PRIORITY" "NICE" "M_VIRT" "M_RESIDENT" "M_SHARE"
            "STATE" "PERCENT_CPU" "PERCENT_MEM" "TIME" "Command"
          ];

          sort_key = "PERCENT_CPU";
          sort_direction = -1;
          tree_sort_key = "PERCENT_CPU";
          tree_sort_direction = -1;
        };

        "I/O" = {
          order = 1;
          columns = [
            "PID" "USER" "IO_PRIORITY" "IO_RATE" "IO_READ_RATE" "IO_WRITE_RATE"
            "PERCENT_SWAP_DELAY" "PERCENT_IO_DELAY" "Command"
          ];

          sort_key = "IO_RATE";
          sort_direction = -1;
        };
      };

      delay = 1 * 10; # 1 second

      show_program_path = false;
      show_thread_names = true;
      highlight_base_name = true;
    });
  };
}