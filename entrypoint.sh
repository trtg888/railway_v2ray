#!/bin/bash

UUIDS=${UUIDS:-"41e4a9f6-3f92-4e03-8140-6c9ef3260a2c,94c177f1-4fd1-49ef-b770-360e4ac2ddc2,c25d49e4-e252-4a6e-a00f-f3d8dbba5d98"}
IFS=',' read -ra U <<< "$UUIDS"

cat > /etc/v2ray/config.json <<EOF
{
  "inbounds": [{
    "port": 443,
    "protocol": "vless",
    "settings": {
      "clients": [
EOF

for id in "${U[@]}"; do
  echo "        { \"id\": \"$id\", \"level\": 0, \"email\": \"$id\" }," >> /etc/v2ray/config.json
done

# Remove trailing comma and continue
sed -i '$ s/,$//' /etc/v2ray/config.json

cat >> /etc/v2ray/config.json <<EOF
      ]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/vless"
      },
      "security": "tls"
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# 启动 V2Ray
exec /usr/bin/v2ray/v2ray -config /etc/v2ray/config.json