#!/bin/bash

sudo service postgresql start

# waith for postgresl to start
sleep 10


/META-SHARE-3.0.2/metashare/start-server.sh
