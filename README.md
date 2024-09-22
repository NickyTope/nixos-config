# --nixos-config--

# secrets setup

get key from proton-pass and put in $HOME/.config/sops/age/keys.txt

edit / add secrets with:

```
nixos-config
sops users/nicky/secrets.yaml
```

# pass setup

import keys

```
gpg --import private.key
gpg --edit-key <key id>
gpg> trust
gpg> 5
gpg> save

gpg --import public.key
```

clone password store to .password-store
