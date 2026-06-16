from lxml import etree
from rdflib import Graph, Namespace, URIRef
from rdflib.namespace import RDF, OWL

TEI_FILE = "hol_tei.xml"
OUTPUT_FILE = "dataset.ttl"

NS = {"tei": "http://www.tei-c.org/ns/1.0"}

BASE = Namespace("https://nixasc.github.io/hol_project/")

DCT = Namespace("http://purl.org/dc/terms/")
SCHEMA = Namespace("https://schema.org/")
SKOS = Namespace("http://www.w3.org/2004/02/skos/core#")
CRM = Namespace("http://www.cidoc-crm.org/cidoc-crm/")

g = Graph()

g.bind("", BASE)
g.bind("dct", DCT)
g.bind("schema", SCHEMA)
g.bind("skos", SKOS)
g.bind("crm", CRM)
g.bind("rdf", RDF)
g.bind("owl", OWL)

tree = etree.parse(TEI_FILE)
root = tree.getroot()

def uri_from_ref(ref):
    return BASE[ref.replace("#", "")]

def predicate_from_name(name):
    prefix, local = name.split(":", 1)

    if prefix == "dct":
        return DCT[local]
    if prefix == "schema":
        return SCHEMA[local]
    if prefix == "skos":
        return SKOS[local]
    if prefix == "crm":
        return CRM[local]

    raise ValueError(f"Unknown prefix: {prefix}")


for element in root.xpath("//*[@xml:id and @sameAs]", namespaces=NS):
    xml_id = element.get("{http://www.w3.org/XML/1998/namespace}id")
    same_as = element.get("sameAs")

    subject = BASE[xml_id]
    g.add((subject, OWL.sameAs, URIRef(same_as)))


for relation in root.xpath("//tei:listRelation/tei:relation", namespaces=NS):
    active = relation.get("active")
    passive = relation.get("passive")
    name = relation.get("name")

    subject = uri_from_ref(active)
    predicate = predicate_from_name(name)
    obj = uri_from_ref(passive)

    g.add((subject, predicate, obj))


g.serialize(destination=OUTPUT_FILE, format="turtle")

print(f"RDF file created: {OUTPUT_FILE}")
print(f"Total triples: {len(g)}")