# EnviroPackets
exploration of using phenopackets to describe environments

Refer to www.phenopackets.org and https://github.com/phenopackets

Phenopacket Schema Definition: https://github.com/phenopackets/phenopacket-format/tree/master/schema

Phenopacket Examples: https://github.com/phenopackets/phenopacket-format/tree/master/examples/level-1

SPARQL-endpoint: http://semantics.senckenberg.de/sparql
GRAPH: 		 http://enviropackets.org/epo

SELECT ?s ?p ?o 
FROM <http://enviropackets.org/epo>
{ ?s ?p ?o .
# filter crap
FILTER (!isBlank(?s) && !regex(str(?p),"imports") ) 
}


# Phenoscape UX Mockup

Concept for how environmental conditions might augment kb.phenoscape.org's UX and UI:
https://xd.adobe.com/view/f563c738-9987-40ec-b593-780a0bf4854f?fullscreen
