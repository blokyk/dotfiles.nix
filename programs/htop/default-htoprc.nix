{
  htop_version = "3.4.0";
  config_reader_min_version = 3;
  #fields = [ 0 48 17 18 38 39 40 2 46 47 49 1 ]; # i don't think this is used?

  header_layout = "two_50_50"; # 50%/50% split column layout
  column_meters_0 = [ "LeftCPUs2" "Memory" "Swap" ];
  column_meter_modes_0 = [ 1 1 ]; # 1 = bar, 2 = text/blank
  column_meters_1 = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
  column_meter_modes_1 = [ 1 2 2 2 ]; # 1 = bar, 2 = text/blank

  show_cpu_usage = true;
  show_cpu_frequency = false;
  show_cpu_temperature = false;
  degree_fahrenheit = false;

  screens = {
    "Main" = {
      order = 0;
      columns = [ "PID" "USER" "PRIORITY" "NICE" "M_VIRT" "M_RESIDENT" "M_SHARE" "STATE" "PERCENT_CPU" "PERCENT_MEM" "TIME" "Command" ];

      sort_key = "PERCENT_CPU";
      tree_sort_key = "PID";
      tree_view_always_by_pid = 0;
      tree_view = 0;
      sort_direction = -1;
      tree_sort_direction = 1;
      all_branches_collapsed = 0;
    };

    "I/O" = {
      order = 1;
      columns = [ "PID" "USER" "IO_PRIORITY" "IO_RATE" "IO_READ_RATE" "IO_WRITE_RATE" "PERCENT_SWAP_DELAY" "PERCENT_IO_DELAY" "Command" ];

      sort_key = "IO_RATE";
      tree_sort_key = "PID";
      tree_view_always_by_pid = 0;
      tree_view = 0;
      sort_direction = -1;
      tree_sort_direction = 1;
      all_branches_collapsed = 0;
    };
  };

  tree_view = true;
  sort_key = 46; # PERCENT_CPU
  tree_sort_key = 0; # PID
  sort_direction = -1; # from highest to lowest
  tree_sort_direction = 1; # from lowest to highest
  tree_view_always_by_pid = false;
  all_branches_collapsed = false;

  # 0: default
  # 1: monochromatic
  # 2: Black on White
  # 3: Light Terminal
  # 4: MC (midnight commander?)
  # 5: Black Night
  # 6: Black Gray
  color_scheme = 0;

  cpu_count_from_one = false;
  delay = 15; # update delay, in tenth of seconds
  enable_mouse = true;
  header_margin = true; # leave 2-char margin around header meters
  screen_tabs = true; # show tabs for the different screens

  # hide shortcuts/function bar:
  #   0 = always show
  #   1 = hide on ESC, show on any input
  #   2 = always hide
  hide_function_bar = 0;

  highlight_changes = false;
  highlight_changes_delay_secs = 5; # how long to highlight for, in seconds
  update_process_names = false; # update proc name on every refresh

  # merge `exe`, `comm`, and `cmdline` in 'Command' column
  show_merged_command = false;
    find_comm_in_cmdline = true;
    strip_exe_from_cmdline = true;

  show_program_path = true;
  highlight_base_name = false;
  highlight_deleted_exe = true;

  highlight_threads = true;
  show_thread_names = false;
  hide_kernel_threads = true;
  hide_userland_threads = false;

  hide_running_in_container = false;

  detailed_cpu_time = false;
  highlight_megabytes = true; # highlight large numbers in memory counters
  show_cached_memory = true;

  shadow_other_users = false;
  shadow_distribution_path_prefix = false;
  account_guest_in_cpu_meter = false;
}