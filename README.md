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

5. Run to make sure everything is OK
    ~~~~
    ./utils/check_import_finished.php
    ~~~~
   
6. Point your webserver to the ./build/website directory.
   Note - This step is not required for using this data with Photon



Additional Setup to setup Photon
=======
1. Clone Photon Code base
   ~~~~
   git clone https://github.com/komoot/photon.git
   mvn clean install   
   ~~~~
   
2. Load data to ES first (Note photon runs a embedded ES node) 
   ~~~~
   # Change DB user name, password, host, port accordngilly 
   java -jar target/photon-0.3.4.jar -nominatim-import -host localhost -port 5432 -database nominatim -user nominatim -password pass -languages es,fr,en
   
   NOTE - if you see problem related to index exist then do the following
   java -jar target/photon-0.3.4.jar
   curl --location --request DELETE 'http://localhost:9200/photon';  
   ~~~~

3. Run Photon
   ~~~~
   java -jar target/photon-0.3.4.jar
   ~~~~

4. Try it
   ~~~~
   curl --location --request GET 'http://localhost:2322/api?q=mindspace&limit=10&lang=en'
   
   Response:
   {
       "features": [
           {
               "geometry": {
                   "coordinates": [
                       13.3901333,
                       52.5123455
                   ],
                   "type": "Point"
               },
               "type": "Feature",
               "properties": {
                   "osm_id": 4306070496,
                   "country": "Germany",
                   "city": "Berlin",
                   "countrycode": "DE",
                   "postcode": "10117",
                   "type": "house",
                   "osm_type": "N",
                   "osm_key": "office",
                   "housenumber": "68",
                   "street": "Friedrichstraße",
                   "district": "Mitte",
                   "osm_value": "company",
                   "name": "mindspace",
                   "state": "Brandenburg"
               }
           }
       ],
       "type": "FeatureCollection"
   }
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
