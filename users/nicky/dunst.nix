{pkgs, ...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        width = 350;
        height = 300;
        origin = "bottom-center";
        offset = "10x50";
        notification_limit = 0;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Appearance
        indicate_hidden = true;
        transparency = 10;
        separator_height = 2;
        padding = 12;
        horizontal_padding = 12;
        frame_width = 2;
        frame_color = "#475072";
        separator_color = "frame";
        sort = true;

        # Text
        font = "JetBrainsMono Medium 10";
        line_height = 0;
        markup = "basic";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;

        # History
        sticky_history = true;
        history_length = 20;

        # Misc/Advanced
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 8;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      # Nightfox theme colors
      urgency_low = {
        background = "#192330";
        foreground = "#9d79d6";
        frame_color = "#475072";
        timeout = 10;
      };

      urgency_normal = {
        background = "#192330";
        foreground = "#9d79d6";
        frame_color = "#84cee4";
        timeout = 10;
      };

      urgency_critical = {
        background = "#192330";
        foreground = "#ff757f";
        frame_color = "#ff757f";
        timeout = 0;
      };
    };
  };
}
