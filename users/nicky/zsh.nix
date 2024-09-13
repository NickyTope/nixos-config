{ pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      gs="git status";
      gaa="git add . --all";
      gc="git commit";
      gg="lazygit";
      gpp="git pull --rebase && git push";
      gpl="git pull --rebase --autostash";
      gps="git push";
      conf="cd ~/.config";
      nconf="conf && nvim";
      n="nvim";
      ":q"="exit";
      wk="cd ~/Documents/Notes/ && nvim";
      docker-rmq="docker ps -a -q -f status=exited | xargs docker rm";
      keys="~/.config/sxhkd/keys.sh";
      nkeys="n ~/.config/sxhkd/sxhkdrc";
      lspbuninstall="bun add --global @babel/cli @babel/core @babel/node concurrently dockerfile-language-server-nodejs eslint eslint_d neovim nodemon prettier stylelint stylelint-lsp tslib typescript vim-language-server vscode-css-languageserver-bin vscode-json-languageserver cssmodules-language-server @tailwindcss/language-server vscode-langservers-extracted emmet-ls @vtsls/language-server";
      ssh="TERM=linux ssh";
      ls="ls --color";
      shares="python ~/.config/bspwm/stocks.py";
      fact="curl --no-progress-meter https://uselessfacts.jsph.pl/api/v2/facts/random\?language\=en | jq .text";
      pandoc="docker run --rm -v \"`pwd`:/data\" -v \"/usr/share/fonts/TTF:/fonts\" pandoc/extra";
      top="bpytop";
      ttq="curl http://api.quotable.io/random|jq '[.text=.content|.attribution=.author]'|tt -oneshot -quotes -";
      ttd="tt -n 10 -oneshot -showwpm -w 10 -csv >> ~/wpm.csv";
      "-"="cd -";
      ".."="cd ..";
      "..."="cd ../..";
      "rebuild"="sudo nixos-rebuild switch --flake ~/code/nixos-config";
      "la"="ls -la --color";
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
    autosuggestion.enable = true;
    autocd = true;
    cdpath = [ "$HOME/code" "$HOME/.config" ];

    history = {
      extended = true;
      append = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$HOME/.zsh_history";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    initExtra = ''
      bindkey  fzf-cd-widget
    '';

  };

  home.sessionPath = [
    "/home/nicky/go"
    "/home/nicky/.cargo/bin"
    "/home/nicky/bin"
    "/home/nicky/.local/bin"
  ];
}
