# Docker Devbox

This project should be usefully for web development targeting PHP.

## Setup

MacOS should resolve the tld's of the PHP domains and forward those to Dnsmasq.
Run the following commands on the command line:
```bash
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/php74'
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/php80'
```

Let's publish the devbox command and symlink it:
```bash
cd "into/the/devbox/folder"
./devbox.sh link
```

> now the command `devbox` is available throughout the system.
