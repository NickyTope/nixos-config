{pkgs, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[](bold blue)[](yellow)";
        error_symbol = "💩";
        vimcmd_symbol = "[](bold green)";
      };
      battery.display = [
        {
          threshold = 30;
          style = "bold yellow";
          discharging_symbol = "󰁽";
          charging_symbol = "󰂉";
        }
      ];
    };
  };

  home.packages = [pkgs.figlet];

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gaa = "git add . --all";
      gc = "git commit";
      gg = "lazygit";
      gpp = "git pull --rebase && git push";
      gpl = "git pull --rebase --autostash";
      gps = "git push";
      conf = "cd ~/.config";
      nconf = "conf && nvim";
      n = "nvim";
      ":q" = "exit";
      wk = "cd ~/Documents/Notes/ && nvim";
      docker-rmq = "docker ps -a -q -f status=exited | xargs docker rm";
      keys = "~/.config/sxhkd/keys.sh";
      nkeys = "n ~/.config/sxhkd/sxhkdrc";
      lspbuninstall = "bun add --global cssmodules-language-server@latest @vtsls/language-server@latest @tailwindcss/language-server@latest";
      ssh = "TERM=linux ssh";
      ls = "ls --color";
      shares = "python ~/.config/bspwm/stocks.py";
      fact = "curl --no-progress-meter https://uselessfacts.jsph.pl/api/v2/facts/random\?language\=en | jq .text";
      pandoc = "docker run --rm -v \"`pwd`:/data\" -v \"/run/current-system/sw/share/X11/fonts:/fonts\" pandoc/extra";
      top = "bpytop";
      ttq = "curl http://api.quotable.io/random|jq '[.text=.content|.attribution=.author]'|tt -oneshot -quotes -";
      ttd = "tt -n 10 -oneshot -showwpm -w 10 -csv >> ~/wpm.csv";
      "-" = "cd -";
      ".." = "cd ..";
      "..." = "cd ../..";
      "rebuild" = "sudo nixos-rebuild switch --flake ~/code/nixos-config";
      "la" = "ls -la --color";
    };

    sessionVariables = {
      APP_URI = "https://dev-client.isw.net.au";
      API_GATEWAY = "https://dev-server.isw.net.au";
      KUBECONFIG = "/home/nicky/.config/kube/config";
      VISUAL = "nvim";
      EDITOR = "nvim";
      BAT_THEME = "base16";
      TERM_ITALICS = "true";
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
    };

    enableCompletion = true;
    autocd = true;
    cdpath = ["$HOME/code"];

    history = {
      extended = true;
      append = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      path = "$HOME/.zsh_history";
    };

    historySubstringSearch = {
      enable = true;
      searchUpKey = [
        "^[[A"
        "$terminfo[kcuu1]"
      ];
      searchDownKey = [
        "^[[B"
        "$terminfo[kcud1]"
      ];
    };

    autosuggestion = {
      enable = true;
      highlight = "fg=#777777";
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "cursor"
      ];
    };

    initContent = ''
      . ${pkgs.fzf}/share/fzf/completion.zsh
      # . ${pkgs.fzf}/share/fzf/key-bindings.zsh
      # alt+.
      bindkey '\e.' insert-last-word

      function subdir_do() {
        for d in ./*/ ; do (echo "=== $d ===" && cd "$d" && "$@") ; done
      }

      function fzfz() {
        cd $(zoxide query --list | fzf --scheme=path --tac)
        local precmd
        for precmd in $precmd_functions; do
          $precmd
        done
        zle reset-prompt
      }

      zle -N fzfz
      bindkey '^g' fzfz # <c-g>
    '';
  };

  home.sessionPath = [
    "/home/nicky/go/bin/"
    "/home/nicky/.cargo/bin"
    "/home/nicky/bin"
    "/home/nicky/.local/bin"
    "/home/nicky/.cache/.bun/bin"
  ];
}
