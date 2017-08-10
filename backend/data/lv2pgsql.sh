#!/bin/bash

bbox="62000,6606000,732911,7776460"
INFILEDIR=infiles
DOWNLOADDIR=download
DBNAME=meri
HOST=localhost
PORT=5432
USER=$1
PW=$2
FORCEDLTODB=0


for f in $INFILEDIR/*.in; do
	DLTODB=1
	read -r localfile url tablename < $f
	if [ -f $DOWNLOADDIR/$localfile ]; then
		echo Skipping download for $localfile
		if [ $FORCEDLTODB -gt 0 ]; then
			DLTODB=1
		else
			DLTODB=0
		fi
	else
		echo Downloading $localfile from "${url}&BBOX=${bbox}" ...
		curl -o $DOWNLOADDIR/$localfile "${url}&BBOX=${bbox}"
		if [ "$?" -ne "0" ]; then
			echo ERROR in $f / download
			break
		fi
	fi

	if [ $DLTODB -gt 0 ]; then
		echo Exporting to database: $tablename
		ogr2ogr -f PostgreSQL -overwrite -a_srs EPSG:3067 -s_srs EPSG:3067 PG:"dbname='$DBNAME' host='$HOST' port='$PORT' user='$USER' password='$PW'" $DOWNLOADDIR/$localfile -lco "GEOM_TYPE=geometry" -lco "OVERWRITE=YES" -gt 65536 -nln $tablename 
		if [ "$?" -ne "0" ]; then
			echo ERROR in $f / DB
			break
		fi
	fi
done

