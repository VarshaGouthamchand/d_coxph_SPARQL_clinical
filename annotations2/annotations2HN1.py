import requests

endpoint = "http://localhost:7200/repositories/userRepo/statements"

query1 = """
PREFIX db: <http://hn_one.local/rdf/ontology/>
PREFIX dbo: <http://um-cds/ontologies/databaseontology/>
PREFIX roo: <http://www.cancerdata.org/roo/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

INSERT  
    {
    
    GRAPH <http://annotation2.local/>
    {
   
     db:hn1_clinical_data_updated_july_2020.dataset rdf:type owl:Class.
    
     db:hn1_clinical_data_updated_july_2020.dataset dbo:table db:hn1_clinical_data_updated_july_2020.
    
     db:hn1_clinical_data_updated_july_2020.dataset rdfs:label "Dataset".
     
     db:hn1_clinical_data_updated_july_2020.dataset owl:equivalentClass ncit:C25474.
    
     ?tablerow dbo:has_column ?dataset.

     ?dataset dbo:has_cell ?datavalue.

     ?datavalue dbo:has_value "HN1".
    
     ?dataset rdf:type db:hn1_clinical_data_updated_july_2020.dataset.  
        
     ?datavalue rdf:type dbo:Cell.
}
}

where 
{
    BIND(IRI(CONCAT(str(?tablerow), "/dataset")) as ?dataset).

    BIND(IRI(CONCAT(str(?dataset), "/value")) as ?datavalue).
    
    ?tablerow rdf:type db:hn1_clinical_data_updated_july_2020.
   
}
        """

def runQuery(endpoint, query):
    annotationResponse = requests.post(endpoint,
                                       data="update=" + query,
                                       headers={
                                           "Content-Type": "application/x-www-form-urlencoded",
                                           # "Accept": "application/json"
                                       })
    output = annotationResponse.text
    print(output)

runQuery(endpoint, query1)

def addMapping(localTerm, targetClass, superClass):
    query = """
            PREFIX owl: <http://www.w3.org/2002/07/owl#>
            PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
            PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX db: <http://hn_one.local/rdf/ontology/>
            PREFIX dbo: <http://um-cds/ontologies/databaseontology/>
            INSERT {
                GRAPH <http://annotation2.local/> {
                    ?term rdf:type owl:Class ;
          			 owl:equivalentClass [ owl:intersectionOf 
                									( [ rdf:type owl:Restriction ;
                                                        owl:onProperty dbo:cell_of ;
                                                        owl:someValuesFrom ?superClass;
                                                      ]
                                                      [ rdf:type owl:Restriction ;
                                                        owl:onProperty dbo:has_value ;
                                                        owl:hasValue ?localValue;
                                                      ]
                                                    ) ;
                                 rdf:type owl:Class
                               ] ;
          			 rdfs:subClassOf ?superClass .
                }
            } WHERE { 
                BIND(<%s> AS ?term).
                BIND(<%s> AS ?superClass).
                BIND("%s"^^xsd:string AS ?localValue).

            }
            """ % (targetClass, superClass, localTerm)

    annotationResponse = requests.post(endpoint,
                                       data="update=" + query,
                                       headers={
                                           "Content-Type": "application/x-www-form-urlencoded"
                                       })
    print(annotationResponse.status_code)

# N stage
addMapping("0", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48705",
           "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")
addMapping("1", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48706",
           "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")
addMapping("2", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48786",
           "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")
#addMapping("N2b", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48786", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")
#addMapping("N2c", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48786", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")
addMapping("3", "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48786",
           "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C48884")

