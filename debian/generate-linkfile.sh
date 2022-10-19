#!/bin/sh
#
# Generate dh_link data file
# Our base content is the bundled .po translation output
#
# This file creates the authoritative ISO aliases.
#

DIR="/usr/share/squid-langpack"
ALIASFILE="${1}"

if ! test -f ${ALIASFILE} ; then
	echo "FATAL: Alias file ${ALIASFILE} does not exist!" >&2
	exit 1
fi

# Parse the alias file
cat ${ALIASFILE} |
while read base aliases; do
	# file may be commented or have empty lines
	if test "${base}" = "#" || test "${base}" = "##" || test "${base}" = ""; then
		continue;
	fi
	# ignore destination languages that do not exist. (no dead links)
	if ! test -x ../${base} ; then
		echo "WARNING: ${base} translations do not exist. Nothing to do for: ${aliases}" >&2
		continue;
	fi

	# split aliases based on whitespace and create a symlink for each
	# Remove and replace any pre-existing content/link
	for alia in ${aliases}; do
		echo ${DIR}/${base} ${DIR}/${alia}
	done
done
