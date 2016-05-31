#/usr/bin/env bash


sudo service postgresql restart
sudo -u postgres psql --command "CREATE USER metashare WITH SUPERUSER PASSWORD 'metashare';"
sudo -u postgres createdb -O metashare metashare
sudo -u postgres createdb -O metashare metashare_test



