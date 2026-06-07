# Scripts (`bin/`)

Automation scripts for environment provisioning.

## `setup-ssh`
Generates and configures GitHub SSH keys.

**Usage:**
```bash
./setup-ssh
```
Prompts for an email, generates an `ed25519` key, starts `ssh-agent`, configures macOS Keychain integration, and copies the public key to the clipboard.

## `setup-llm`
Provisions local LLM infrastructure.

**Usage:**
```bash
./setup-llm
```
Starts the Ollama daemon, pulls Gemma 4 models (9B, 12B, 26B), and installs Aider via `uv`.
