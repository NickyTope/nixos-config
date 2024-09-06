# --nixos-config--

# pass setup

$HOME/.gnupg/gpg-agent.conf

```
pinentry-program /run/current-system/sw/bin/pinentry-rofi
```

reload gpg-agent

```
gpg-connect-agent reloadagent /bye
```

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
