ssh -p 2222 s465635@se.ifmo.ru -L 16250:helios.cs.ifmo.ru:16250
bash windfly/wildfly-21.0.0.Final/bin/standalone.sh
http://localhost:16250/area-check/controller



