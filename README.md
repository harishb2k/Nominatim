[![Build Status](https://travis-ci.org/osm-search/Nominatim.svg?branch=master)](https://travis-ci.org/osm-search/Nominatim)

Nominatim
=========

Nominatim (from the Latin, 'by name') is a tool to search OpenStreetMap data
by name and address (geocoding) and to generate synthetic addresses of
OSM points (reverse geocoding). An instance with up-to-date data can be found
at https://nominatim.openstreetmap.org. Nominatim is also used as one of the
sources for the Search box on the OpenStreetMap home page.

Documentation
=============

The documentation of the latest development version is in the
`docs/` subdirectory. A HTML version can be found at
https://nominatim.org/release-docs/develop/ .

Installation
============

**Nominatim is a complex piece of software and runs in a complex environment.
Installing and running Nominatim is something for experienced system
administrators only who can do some trouble-shooting themselves. We are sorry,
but we can not provide installation support. We are all doing this in our free
time and there is just so much of that time to go around. Do not open issues in
our bug tracker if you need help. You can ask questions on the mailing list
(see below) or on [help.openstreetmap.org](https://help.openstreetmap.org/).**

The latest stable release can be downloaded from https://nominatim.org.
There you can also find [installation instructions for the release](https://nominatim.org/release-docs/latest/admin/Installation), as well as an extensive [Troubleshooting/FAQ section](https://nominatim.org/release-docs/latest/admin/Faq/).

Detailed installation instructions for the development version can be
found at [nominatim.org](https://nominatim.org/release-docs/develop/admin/Installation)
as well. 


A quick summary of the necessary steps to use existing self-containing docker image with Postgres:
    OR go to "A quick summary of the necessary steps" section to work with local Postgres database
    NOTE - this setup given in this document does not work with remote postgres
           -> Remote setup requires some .so files to be copied to Postgres servers. So I prefer
           local setup over remote 
```
    docker run -it harishb2k/nominatim
    
    NOTE - you may want to expose Postgress port to use this data from outside this container           
           You will lose data after reboot

    # Start Postgres and create required database and user:
    ========================================================
    service postgresql restart
    su postgres
    psql -d postgres
    
    # Run following commands in Postgres console after running "psql -d postgres":
    ==============================================================================
    CREATE USER nominatim WITH PASSWORD 'nominatim';
    create database nominatim;
    grant all privileges on database nominatim to nominatim;
    ALTER USER nominatim SUPERUSER;
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
    drop database nominatim ;
    \q
    exit
    # This "exit" will take you out of "postgres" user    

        OR
    
    su postgres -c ./boot.sh 

    # Download sample data if you need (Or use your own OSM file
    wget -O muenchen.osm "https://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145"
    
    # Run the command to put data
    ./utils/setup.php --osm-file muenchen.osm --all

```


A quick summary of the necessary steps:


1. Compile Nominatim:
    ~~~~
    # Make sure you clone this project with --recursive flag
    # This project depends on a sub-module
    git clone --recursive https://github.com/harishb2k/Nominatim.git
    
    mkdir build
    cd build
    cmake ..
    make
    ~~~~
           
2. Some more helpful steps to make it work on Mac. You can do the similar steps on Ubuntu or other OS.
    
    ~~~~
   brew install postgres
   brew install postgis
   pip3 install psycopg2
   ~~~~

3. Postgres Setup
    ~~~~
    # Change passward of your choice   
    CREATE USER nominatim WITH PASSWORD 'pass';
   
    create database nominatim;
    grant all privileges on database nominatim to nominatim;
    
   # Actually you just need nominatim to be able to create new DB
   # NOTE - Dont give SUPERUSER
   
   ALTER USER nominatim SUPERUSER;
   
    Setup postgis and hstore plugin
    > psql -d postgres
        #\c nominatim
        # CREATE EXTENSION postgis; 
        # CREATE EXTENSION hstore;      
    ~~~~

4. Get OSM data and import:

        ./build/utils/setup.php --osm-file <your planet file> --all
            OR
        ./build/utils/setup.php --osm-file <Your xyz.osm.pbf file> --all --osm2pgsql-cache 2048
        
        FYI - If you want to download a data to try, use the following
        wget -O muenchen.osm "https://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145"


5. Run to make sure everything is OK
    ~~~~
    ./utils/check_import_finished.php
    ~~~~
   
6. Point your webserver to the ./build/website directory.
   Note - This step is not required for using this data with Photon



Additional Setup to setup Photon
=======
1. Clone Photon Code base & follow instruction from "harishb2k/photon" git project 
   ~~~~
   git clone https://github.com/harishb2k/photon.git
   mvn clean install  -DskipTests
   
   # You need to setup local elastic search 7.9.2 to run test case. 
   ~~~~
             
License
=======

The source code is available under a GPLv2 license.


Contributing
============

Contributions are welcome. For details see [contribution guide](CONTRIBUTING.md).

Both bug reports and pull requests are welcome.


Mailing list
============

For questions you can join the geocoding mailing list, see
https://lists.openstreetmap.org/listinfo/geocoding
