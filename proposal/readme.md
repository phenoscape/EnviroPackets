# Phenotypes, Meet Environmental Conditions

This project started with a desire to query Phenoscape with this question:
_"What traits are associated with low light conditions"_

Translated into more generalized terms, this could be reframed as:
_"What phenotypes are associated with a range of measured environmental conditions?"_

[Explore a simple example of what this capability might mean for a Phenoscape Knowledgebase user >>](https://xd.adobe.com/view/f563c738-9987-40ec-b593-780a0bf4854f?fullscreen)

In order to achieve this, we explored a number of potential workflows and technologies. As a guiding principal, we are not interested in proposing any new ontologies or standards, and are interested in framing a system that might ultimately support the Phenoscape project.

### A generalized sequence of events might look like this:

1. Query that includes an environmental condition ([PATO]() reference) and range of values associated with a specific unit ([UO]() reference). 
2. Correlation between each environmental condition value range and an array of habitats ([ENVO]() references), so that the query initially identifies matching habitats.
3. Correlation between each habitat and an array of organisms (could be generalized taxonomic entities or specific specimens/observations) that live in that habitat, so that the query identifies matching organisms.
4. Correlation between each organism and the array of phenotypes([UBERON]()) associated with that organism, so that the query identifies matching traits (A).
5. As an option, steps 3 and 4 might also be conducted with the array of organisms _not_ found in the matching habitats. The resulting traits (B) would be subtracted from the set of traits returned above (A) to result in a list of traits that are unique to the queried environmental condition value range.

For example, a query's environmental condition component might be translated into _temperature(PATO:0000146)_ + _273-280(range in Kelvin)_. This condition would be matched with an array of habitats, including _temperate mixed broadleaf forest(ENVO:01000389)_. Those habitats would me matched with an array of organisms, including _european ground squirrel_. Those organisms would be matched with an array of phenotypes, including _tail hair(UBERON:0015148)_.

We need to identify which ENVO classes are the best options to use as georeference entities. Our proposal is to use a collection of classes found within ENVO's entity>continuant>independent continuant>material entity>environmental feature class. One advantage of this class is that its children are already utilized to identify organisms' "habitat" in EOL's Traitbank. Other viable options might include biome classes found within the entity>continuant>independent continuant>material entity>system>environmental system>ecosystem>biome class.

There's an assumption that someone will tie these ENVO classes to existing environmental conditions data. There are a variety of publicly available data stores that combine coordinates or other georef data with a variety of recorded measurements of various environmental conditions. We have a dependency on a maintained dataset that correlates each ENVO class with a specific geographic area, and each of these class/area units with a set of value ranges somehow defined by the aggregate of these measurements. One of the JSON files we created (inspired by the phenopacket schema) demonstrates how this data might be structured.

Assuming all this exists, THEN someone needs to connect biological specimen and taxon records with these ENVO terms in a consistent and queryable way. This will allow for environmental conditions to be inferred per specimen or taxon.

### Phenopackets as a communication format
We were intrigued by how this system might standardize its inputs and outputs via [PhenoPackets](http://phenopackets.org/), "an open standard for representing and sharing detailed descriptions of phenotypic abnormalities and characteristics of individual patients, organisms, diseases, and publications." The [PhenoPacket schema](https://github.com/phenopackets/phenopacket-format/blob/master/schema/phenopacket-schema.json) includes an `environment_profile` object (described on line 533 of the linked file) that enables relevant environmental conditions to be listed and described. In our use case, we might be interested in a "PhenoPacket" that incorporates some combination of organisms, phenotypes, and/or environmental conditions. 

The existing schema for `environment_profile` is reprinted here for reference:

```
 "environment_profile" : {
      "type" : "array",
      "items" : {
        "type" : "object",
        "id" : "urn:jsonschema:org:phenopackets:api:model:association:EnvironmentAssociation",
        "properties" : {
          "environment" : {
            "type" : "object",
            "$ref" : "urn:jsonschema:org:phenopackets:api:model:environment:Environment",
            "description" : "The environment which this association is about"
          },
          "entity" : {
            "type" : "string"
          },
          "evidence" : {
            "type" : "array",
            "description" : "Any Association can have any number of pieces of evidence attached",
            "items" : {
              "type" : "object",
              "$ref" : "urn:jsonschema:org:phenopackets:api:model:meta:Evidence"
            }
          }
        }
      }
    }
```

[The only example of this we could find](https://github.com/phenopackets/phenopacket-reference-implementation/blob/cc590e3ef12852ced5e80af9996647bc2a00da25/src/test/resources/context/phenopacket-without-context.yaml) describes the behavior of a human patient. Based on this schema alone, another organism-focused PhenoPacket with habitat-oriented context is presented below:

```
{
  "id": "#1",
  "title": "organism/environment example #1",
  "organisms": [
    {
      "id": "organism#1",
      "label": "example organism",
      "taxon": NCBITaxon:XXXXX
    }
  ],
  "environment_profile": [
    {
      "entity": "organism#1",
      "environment": {
        "description": "Habitat",
        "types": [
          {
            "id": "ENVO:00000214",
            "label": "hadalpelagic zone"
          }
        ]
      },
      "evidence": [
        {
          "types": [
            {
              "id": "ECO:XXXXXX",
              "label": "TAS"
            }
          ],
          "source": [
            {
              "id": "PMID:XXXXXXXX"
            }
          ]
        }
      ]
    }
  ]
}
```
Of course, this example assumes that the referenced ENVO class (ENVO:00000214) would be associated with specific environmental conditions that could be easily retrieved. This is not currently the case, but even if it were, there may be cases in which it makes sense to communicate more specific environmental conditions than would be appropriate to create individual ontology classes for. 

For example, a query or response might be defined by the temperature range (2-4°C == 275.15-277.15°K) found in the hadalpelagic zone (deep-sea areas around thermal vents). In order to define this, several values must be considered, including the PATO class for the environmental condition, the UO class for the relevant unit of measurement, and the min and max numeric values associated with the measured range. In this case, we're focused on `PATO:0000146`(temperature), using unit `UO:0000012`(kelvin), with min float value `275.15` and max float value `277.15`. 

In order to represent this, we'd need to augment the `types` object with definitions of the unit and min/max values. Here's how this might be displayed in a slightly altered PhenoPacket schema:

```
{
  "id": "#2",
  "title": "organism/environment example #2",
  "organisms": [
    {
      "id": "organism#1",
      "label": "example organism",
      "taxon": NCBITaxon:XXXXX
    }
  ],
  "environment_profile": [
    {
      "entity": "organism#1",
      "environment": {
        "description": "Habitat",
        "types": [
          {
            "id" : "PATO: 0000146",
            "label" : "temperature",
            "unit" : {
              "id" : "UO: 0000012",
              "label" : "kelvin"
            },
            "min" : "275.15",
            "max" : "277.15"
          }
        ]
      },
      "evidence": [
        {
          "types": [
            {
              "id": "ECO:XXXXXX",
              "label": "TAS"
            }
          ],
          "source": [
            {
              "id": "PMID:XXXXXXXX"
            }
          ]
        }
      ]
    }
  ]
}
```
As the `type` object isn't explicitly defined in the current PhenoPackets schema, this format (or something similar) could either be adopted as a best practice or be officially adopted via the schema and documentation.
