#!/bin/sh

cd "`dirname $0`"

java -jar ../target/snb-interactive-sql-1.0-SNAPSHOT-jar-with-dependencies.jar -db ca.uwaterloo.cs.ldbc.interactive.sql.PostgresDb -P ldbc_snb_interactive_SF-0001.properties -P ldbc_driver_default.properties -P updateStream.properties -P pgsql.properties -p "ldbc.snb.interactive.parameters_dir|substitution_parameters/" -wu 10 -oc 10