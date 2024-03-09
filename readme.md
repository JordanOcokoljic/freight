# Freight

Freight is a tool for quickly sharing work in progress code within `git`
repositories between people or devices. It does so by leveraging the existing
features within `git` ensuring compatability with both remote hosts and local
clients.

## Usage
Run `freight help` for usage instructions.

## Installation
### Manual
1. Clone this repository into a convinent location on your machine.
```
git clone git@github.com:JordanOcokoljic/freight.git ~/.local/godl
```

2. Create a symlink to the script in a location on your path
```
ln -s ~/.local/freight/freight.sh ~/.local/bin/freight
```

### Script
Run the installation script via `curl`. Note that `~/.local/bin` needs to be
in `PATH`.

```
curl -L https://raw.githubusercontent.com/JordanOcokoljic/freight/master/install.sh | bash