#!/usr/bin/env bash

echo -e "\e[1m\e[32m1. Installing cosmos-exporter... \e[0m" && sleep 1
source ~/.bashrc

# install cosmos-exporter
sudo /usr/local/go/bin/go build -o build/dora-cosmos-exporter -buildvcs=false ./
sudo /usr/bin/go build -o build/dora-cosmos-exporter -buildvcs=false ./
sudo go build -o build/dora-cosmos-exporter -buildvcs=false ./
sudo mv ./build/dora-cosmos-exporter /usr/bin

sudo useradd -rs /bin/false cosmos_exporter

sudo tee <<EOF >/dev/null /etc/systemd/system/cosmos-exporter.service
[Unit]
Description=Cosmos Exporter
After=network-online.target

[Service]
User=cosmos_exporter
Group=cosmos_exporter
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=/usr/bin/dora-cosmos-exporter --bech-prefix "dora" --denom "peaka"  --denom-exponent "18" --node "vota-grpc.dorafactory.org" --tendermint-rpc "https://vota-rpc.dorafactory.org:443"

Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable cosmos-exporter
sudo systemctl restart cosmos-exporter

echo "installed"