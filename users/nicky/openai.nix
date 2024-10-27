{config, ...}: let
  key = config.sops.secrets.openai.path;
in {
  home.sessionVariables = {
    OPENAI_API_KEY = "$(cat ${key})";
  };
}
