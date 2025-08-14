# GitLab Migration Instructions

## Completed on mininix
- ✅ GitLab SSH keys configured via SOPS
- ✅ Repository migrated to GitLab
- ✅ GitLab CI workflow merged
- ✅ Origin remote updated to GitLab

## Instructions for nt-oryx

1. **Pull the latest changes** (including the GitLab CI workflow):
   ```bash
   git pull
   ```

2. **Update the origin remote** to GitLab:
   ```bash
   git remote set-url origin git@gitlab.com:nicky.tope/nixos-config.git
   ```

3. **Verify the remote configuration**:
   ```bash
   git remote -v
   ```

4. **Test GitLab SSH connection** (optional):
   ```bash
   ssh -T git@gitlab.com
   ```

5. **Add GitLab to known_hosts if needed** (optional):
   ```bash
   ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
   ```

## Notes
- SSH keys for GitLab are already configured in the NixOS config via SOPS secrets
- After rebuilding on nt-oryx, SSH authentication should work automatically
- Both systems will use GitLab as the primary repository going forward
- GitHub remote has been kept temporarily for transition purposes

## Repository URLs
- **GitLab (new primary)**: git@gitlab.com:nicky.tope/nixos-config.git
- **GitHub (legacy)**: git@github.com:NickyTope/nixos-config.git