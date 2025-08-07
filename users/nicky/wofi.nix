{pkgs, ...}: {
  programs.wofi = {
    enable = true;
    settings = {
      width = 700;
      height = 400;
      location = "center";
      show = "drun";
      prompt = " ";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
    };
    style = ''
      /* Nightfox theme for wofi - matching rofi configuration */

      window {
          margin: 0px;
          border: 0px solid #475072;
          background-color: #192330;
          border-radius: 0px;
          font-family: "JetBrainsMono Medium", monospace;
          font-size: 10pt;
      }

      #input {
          margin: 0px;
          border: 0px;
          color: #9d79d6;
          background-color: #475072;
          padding: 12px;
          font-family: "Cascadia Code", monospace;
          font-size: 12pt;
      }

      #inner-box {
          margin: 0px;
          border: 0px;
          background-color: #192330;
      }

      #outer-box {
          margin: 0px;
          border: 0px;
          background-color: #192330;
      }

      #scroll {
          margin: 0px;
          border: 0px;
      }

      #text {
          margin: 0px;
          border: 0px;
          color: #9d79d6;
          font-family: "JetBrainsMono Medium", monospace;
          font-size: 10pt;
      }

      #entry {
          margin: 0px;
          border: 0px;
          background-color: #192330;
          padding: 12px;
      }

      #entry:selected {
          background-color: #192330;
      }

      #entry:selected #text {
          color: #84cee4;
      }
    '';
  };
}