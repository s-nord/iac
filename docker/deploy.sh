sudo curl --unix-socket /var/run/unit/control.sock http://localhost
sudo curl --unix-socket /var/run/unit/control.sock -X PUT -d@config.json http://localhost/config


sudo curl --unix-socket /var/run/unit/control.sock -X DELETE http://localhost/config/listeners/*:8300
sudo curl --unix-socket /var/run/unit/control.sock -X DELETE http://localhost/config/applications/phpinfo


# Inside Docker
curl --unix-socket /var/run/control.unit.sock http://localhost
curl --unix-socket /var/run/control.unit.sock -X PUT -d @/app/config.phpinfo.json http://localhost/config

# Access log
curl --unix-socket /var/run/control.unit.sock -X PUT -d '"/var/log/access.log"' http://localhost/config/access_log

# Add empty database
docker exec -it app sqlite3 /data/telemetry.db "VACUUM;"
