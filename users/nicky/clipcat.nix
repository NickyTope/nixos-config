{pkgs, ...}: {
  # Install clipcat package
  home.packages = with pkgs; [
    clipcat
  ];

  xdg.configFile."clipcat/clipcatd.toml".text = ''
    daemonize = false
    pid_file = "/run/user/1000/clipcatd.pid"
    primary_threshold_ms = 5000
    max_history = 5000
    synchronize_selection_with_clipboard = true
    history_file_path = "/home/nicky/.cache/clipcat/clipcatd-history"
    snippets = []

    [log]
    emit_journald = true
    emit_stdout = false
    emit_stderr = false
    level = "INFO"

    [watcher]
    enable_clipboard = true
    enable_primary = false
    enable_secondary = false
    sensitive_x11_atoms = ["x-kde-passwordManagerHint"]
    filter_text_min_length = 1
    filter_text_max_length = 20000000
    denied_text_regex_patterns = []
    capture_image = true
    filter_image_max_size = 5242880

    [grpc]
    enable_http = true
    enable_local_socket = true
    host = "127.0.0.1"
    port = 45045
    local_socket = "/run/user/1000/clipcat/grpc.sock"

    [dbus]
    enable = true

    [metrics]
    enable = true
    host = "127.0.0.1"
    port = 45047

    [desktop_notification]
    enable = false
    icon = "accessories-clipboard"
    timeout_ms = 2000
    long_plaintext_length = 2000
  '';

  xdg.configFile."clipcat/clipcatctl.toml".text = ''
    # Server endpoint.
    # clipcatctl connects to server via unix domain socket if `server_endpoint` is a file path like:
    # "/run/user/<user-id>/clipcat/grpc.sock".
    # clipcatctl connects to server via http if `server_endpoint` is a URL like: "http://127.0.0.1:45045".
    server_endpoint = "/run/user/1000/clipcat/grpc.sock"

    [log]
    # Emit log message to a log file.
    # Delete this line to disable emitting to a log file.
    # file_path = "/path/to/log/file"
    # Emit log message to systemd-journald
    emit_journald = true
    # Emit log message to stdout.
    emit_stdout = false
    # Emit log message to stderr.
    emit_stderr = false
    # Log level
    level = "INFO"
  '';

  xdg.configFile."clipcat/clipcat-menu.toml".text = ''
    # Server endpoint
    # clipcat-menu connects to server via unix domain socket if `server_endpoint` is a file path like:
    # "/run/user/<user-id>/clipcat/grpc.sock".
    # clipcat-menu connects to server via http if `server_endpoint` is a URL like: "http://127.0.0.1:45045".
    server_endpoint = "/run/user/1000/clipcat/grpc.sock"

    # The default finder to invoke when no "--finder=<finder>" option provided.
    finder = "rofi"

    [log]
    # Emit log message to a log file.
    # Delete this line to disable emitting to a log file.
    file_path = "/path/to/log/file"
    # Emit log message to systemd-journald.
    emit_journald = true
    # Emit log message to stdout.
    emit_stdout = false
    # Emit log message to stderr.
    emit_stderr = false
    # Log level.
    level = "INFO"

    # Options for "wofi".
    [wofi]
    # Length of line.
    line_length = 100
    # Length of menu.
    menu_length = 30
    # Prompt of menu.
    menu_prompt = "Clipcat"
    # Extra arguments to pass to `wofi`.
    extra_arguments = ["--prompt", "Clipcat"]

    # Options for "rofi" (kept for compatibility).
    [rofi]
    # Length of line.
    line_length = 100
    # Length of menu.
    menu_length = 30
    # Prompt of menu.
    menu_prompt = "Clipcat"
    # Extra arguments to pass to `rofi`.
    extra_arguments = ["-mesg", "Please select a clip"]

    # Options for "dmenu".
    [dmenu]
    # Length of line.
    line_length = 100
    # Length of menu.
    menu_length = 30
    # Prompt of menu.
    menu_prompt = "Clipcat"
    # Extra arguments to pass to `dmenu`.
    extra_arguments = [
      "-fn",
      "SauceCodePro Nerd Font Mono-12",
      "-nb",
      "#282828",
      "-nf",
      "#ebdbb2",
      "-sb",
      "#d3869b",
      "-sf",
      "#282828",
    ]

    # Customize your finder.
    [custom_finder]
    # External program name.
    program = "fzf"
    # Arguments for calling external program.
    args = []
  '';

  systemd.user.services.clipcatd = {
    Unit = {
      Description = "Clipcat daemon";
    };
    Service = {
      ExecStart = "${pkgs.clipcat}/bin/clipcatd --no-daemon --replace";
      ExecStop = "rm -f %t/clipcat/grpc.sock";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
