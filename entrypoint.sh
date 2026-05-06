#!/bin/sh

# دانلود و استخراج Xray
wget -qO /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip -q /tmp/xray.zip -d /usr/local/bin/
chmod +x /usr/local/bin/xray

# ساخت فایل کانفیگ Xray با پورت 10000 و مسیر مخفی
cat <<EOF > /etc/xray_config.json
{
  "inbounds": [{
    "port": 10000,
    "protocol": "vless",
    "settings": {
      "clients": [
        {
          "id": "a7b59381-1c58-4034-b26a-9a84124c96b7"
        }
      ],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/v1/api/update"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom"
  }]
}
EOF

# اجرای Xray در پس‌زمینه
/usr/local/bin/xray run -c /etc/xray_config.json &

# اجرای Nginx در پیش‌زمینه (برای اینکه کانتینر روشن بمونه)
nginx -g 'daemon off;'

