#!/usr/bin/env bash
set -e
echo "Installing dependencies..."
sudo apt-get -qq update &>/dev/null

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "Configuring application service..."
sudo tee /etc/systemd/system/app.service > /dev/null <<"EOF"
[Unit]
Description=Application
Requires=network-online.target
After=network-online.target

[Service]
Restart=on-failure
Environment=CONSUL_ALLOW_PRIVILEGED_PORTS=true
ExecStart=/usr/bin/docker run -dit -e NAME=${NAME} -e BG_COLOR=${BG_COLOR} -p 8080:80 swinkler/tia-webserver
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

echo "Starting services..."
sudo systemctl daemon-reload
sudo systemctl enable app.service
sudo systemctl start app.service