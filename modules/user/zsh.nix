{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      gs="git status";
      gaa="git add . --all";
      gc="git commit";
      gk="gitk";
      gg="lazygit";
      gpp="git pull --rebase && git push";
      gpl="git pull --rebase --autostash";
      gps="git push";
      conf="cd ~/.config";
      nconf="conf && nvim";
      x="startx";
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

    plugins = [
      {                                                                                   
        name = "powerlevel10k";                                                           
        src = pkgs.zsh-powerlevel10k;                                                     
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";                         
      }
    ];

    initExtra = ''
source ~/.p10k.zsh
[[ -f ~/.env.sh ]] && source ~/.env.sh

# alt+.
bindkey '\e.' insert-last-word

function subdir_do() {
  for d in ./*/ ; do (echo "=== $d ===" && cd "$d" && "$@") ; done
}

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

function fzfz() {
  cd $(z | awk '{print $2}' | fzf --scheme=path --tac)
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
      "/home/nicky/go"
      "/home/nicky/.cargo/bin"
      "/home/nicky/bin"
      "/home/nicky/.local/bin"
    ];

}
