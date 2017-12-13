#! /bin/bash

# adapt to local classpath
export PATH=$PATH:~/classes/apache-jena-3.4.0/bin

#query EnviroPackets ontology on github
arq --results JSON --data https://raw.githubusercontent.com/phenoscape/EnviroPackets/master/EnviroPackets.ttl '
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

