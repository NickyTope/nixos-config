{pkgs, ...}: {
  programs.wofi = {
    enable = true;
    settings = {
      width = 800;
      height = 500;
      location = "center";
      show = "drun";
      prompt = "Search Apps";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 32;
      gtk_dark = true;
      sort_order = "alphabetical";
      term = "ghostty";
      columns = 1;
    };
    style = ''
      /* Enhanced Nightfox theme for wofi - comprehensive styling */
      /* Nightfox Color Palette:
         bg1: #192330, bg3: #29394f, sel0: #2b3b51, sel1: #3c5372
         fg1: #cdcecf, fg2: #aeafb0, fg3: #71839b
         blue: #719cd6, green: #81b29a, red: #c94f6d, yellow: #dbc074
         cyan: #63cdcf, magenta: #9d79d6, orange: #f4a261, pink: #d67ad2 */

      * {
          font-family: "FiraCode Nerd Font", "Iosevka", monospace;
          font-size: 14px;
          font-weight: 500;
      }

      /* Main window styling */
      window {
          margin: 0px;
          border: 2px solid #29394f;
          background-color: rgba(25, 35, 48, 0.95); /* Nightfox bg1 with transparency */
          border-radius: 8px;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
          backdrop-filter: blur(10px);
      }

      /* Input field styling */
      #input {
          margin: 12px;
          border: 2px solid #29394f;
          color: #cdcecf; /* Nightfox fg1 */
          background-color: rgba(43, 59, 81, 0.8); /* Nightfox sel0 with transparency */
          padding: 16px 20px;
          border-radius: 6px;
          font-size: 16px;
          font-weight: 600;
          transition: all 0.2s ease;
      }

      #input:focus {
          border-color: #719cd6; /* Nightfox blue */
          background-color: rgba(43, 59, 81, 1.0);
          box-shadow: 0 0 0 2px rgba(113, 156, 214, 0.2);
      }

      /* Container styling */
      #inner-box {
          margin: 0px 12px 12px 12px;
          border: 0px;
          background-color: transparent;
          border-radius: 6px;
      }

      #outer-box {
          margin: 0px;
          border: 0px;
          background-color: transparent;
      }

      /* Scroll area styling */
      #scroll {
          margin: 0px;
          border: 0px;
          background-color: transparent;
      }

      /* Text styling */
      #text {
          margin: 4px 0px;
          border: 0px;
          color: #aeafb0; /* Nightfox fg2 */
          font-size: 14px;
          font-weight: 500;
      }

      /* Entry styling with comprehensive states */
      #entry {
          margin: 2px 0px;
          border: 0px;
          background-color: transparent;
          padding: 12px 16px;
          border-radius: 4px;
          transition: all 0.15s ease;
          border-left: 3px solid transparent;
      }

      /* Hover state */
      #entry:hover {
          background-color: rgba(41, 57, 79, 0.5); /* Nightfox bg3 */
          border-left-color: #63cdcf; /* Nightfox cyan */
      }

      #entry:hover #text {
          color: #cdcecf; /* Nightfox fg1 */
      }

      /* Selected state */
      #entry:selected {
          background-color: rgba(60, 83, 114, 0.8); /* Nightfox sel1 */
          border-left-color: #719cd6; /* Nightfox blue */
          box-shadow: 0 2px 8px rgba(113, 156, 214, 0.2);
      }

      #entry:selected #text {
          color: #d6d6d7; /* Nightfox fg0 */
          font-weight: 600;
      }

      /* Icon styling */
      #img {
          margin-right: 12px;
          border-radius: 3px;
          opacity: 0.9;
          transition: opacity 0.15s ease;
      }

      #entry:hover #img,
      #entry:selected #img {
          opacity: 1.0;
      }

      /* Scrollbar styling */
      scrollbar {
          background-color: rgba(41, 57, 79, 0.3);
          border-radius: 4px;
          width: 8px;
      }

      scrollbar slider {
          background-color: rgba(113, 156, 214, 0.6);
          border-radius: 4px;
          transition: background-color 0.2s ease;
      }

      scrollbar slider:hover {
          background-color: #719cd6; /* Nightfox blue */
      }

      /* Special category styling for different app types */
      #entry[app-id*="terminal"] {
          border-left-color: #81b29a; /* Nightfox green for terminals */
      }

      #entry[app-id*="browser"] {
          border-left-color: #f4a261; /* Nightfox orange for browsers */
      }

      #entry[app-id*="editor"] {
          border-left-color: #9d79d6; /* Nightfox magenta for editors */
      }

      #entry[app-id*="media"] {
          border-left-color: #d67ad2; /* Nightfox pink for media */
      }

      /* Animation for smooth opening */
      @keyframes fadeIn {
          from {
              opacity: 0;
              transform: scale(0.95);
          }
          to {
              opacity: 1;
              transform: scale(1.0);
          }
      }

      window {
          animation: fadeIn 0.2s ease-out;
      }
    '';
  };
}