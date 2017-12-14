#! /usr/bin/bash

#pipeline script
#requires: Apache Jena, Phenopacket python tools

#adapt jena classpath 
export PATH=$PATH:~/classes/apache-jena-3.4.0/bin

enpa_in_json="$1"
enpa_out_ttl="${enpa_in_json%.json}.ttl"

#validate file with phenopacket python tools
# TODO
# example:
#python phenopacket_validator.py ../resources/schemas/phenopacket-level-1-sc#hema.json ~/programming/phenoscape2017/examples_hdo/hdo01.json 
#running validator
#Valid phenopacket

#add jsonld schema to file
# TODO

#transform jsonld to rdf/ttl
riot --syntax="JSON-LD" --output="TTL" $enpa_in_json > $enpa_out_ttl

#upload to endpoint or query data with arq
arq --results JSON --data https://raw.githubusercontent.com/phenoscape/EnviroPackets/master/ENVO_trial_version_2.ttl --data $enpa_out_ttl '
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>  
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX envo: <http://purl.obolibrary.org/obo/envo#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX : <.>
 
SELECT * 
{ ?s ?p ?o .
# filter crap
FILTER (!isBlank(?s) && !regex(str(?p),"imports") ) }
'
