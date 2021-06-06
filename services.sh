#!/bin/sh

if [ ! -e /opt/aozoraepub3/kindlegen ]; then
  chmod 755 /opt/aozoraepub3/kindlegen
fi

if [ ! -e /var/opt/narou/.narou ]; then
  mkdir .narou
  mkdir -p .narousetting
  {
    echo "---";
    echo 'aozoraepub3dir: "/opt/aozoraepub3"';
    echo 'over18: true';
    echo 'server-port: 33000';
    echo 'server-bind: 0.0.0.0';
  } | tee .narousetting/global_setting.yaml

  {
    echo "---";
    echo "already-server-boot: true";
  } | tee .narousetting/server_setting.yaml

  narou s convert.no-open=true
  narou s device=kindle
fi

exec "$@"
