# Freight

Freight is a tool for quickly sharing work in progress code within `git`
repositories between people or devices. It does so by leveraging the existing
features within `git` ensuring compatability with both remote hosts and local
clients.


## Usage

`freight <command> <tag>`

Freight supports two commands:
- `send` will push any changes to the remote, associating them with the
  provided _freight tag_.
- `accept` will pull any changes from the remote associated with the provided
  _freight tag_.

Any text value can be used as a _freight tag_ - just ensure that is memorable,
and short enough to be easily typed.
