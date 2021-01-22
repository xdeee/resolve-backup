#!/bin/bash
dbname="video"
dbuser="postgres"
dbhost="127.0.0.1"
dbpass="DaVinci"

while getopts d:u:h:p:f:c: flag
do
	case "${flag}" in
		u) dbuser=${OPTARG};;
		d) dbname=${OPTARG};;
		h) dbhost=${OPTARG};;
		p) dbpass=${OPTARG};;
		f) bfolder=${OPTARG};;
		c) bcopy=${OPTARG};;
	esac
done

if [[ -z "${bfolder}" ]]; then
	echo "Backup folder must be specified with -f flag."
	exit 1
fi

mkdir -p "${bfolder}"
echo "Backing up '${dbname}' to ${bfolder}."
current_date=$(date "+%Y_%m")
current_time=$(date "+%Y_%m_%d_%H_%M")
mkdir -p $bfolder/$current_date
pg_dump $dbname -h ${dbhost} --username ${dbuser} --file ${bfolder}/${current_date}/${dbname}_${current_time}.backup --blobs --format=custom

if [[ $bcopy ]]; then
	echo "Also backing up copy to $bcopy/$current_date."
	mkdir -p ${bcopy}/${current_date}
	cp ${bfolder}/${current_date}/${dbname}_${current_time}.backup ${bcopy}/${current_date}/
fi
