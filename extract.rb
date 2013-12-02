require 'rubygems'
require 'json'

# Chargement des données GeoJSON de la ville de Rennes: Ce fichier a été obtenu
# suite à une requête Overpass-API sauvegardé en format OSM, ouvert dans JOSM,
# puis converti / enregistré au format GeoJSON

f = File.read('./in/rennes.geojson')
obj = JSON.parse(f)

# Chargement des données calculées par le groupe de travail
# de l'OpenDataCamp
db_gender = {}

File.open("./in/toponymes.csv").each do |l|
  arr = l.split(";")
  # - colone 6: nom de la voie
  # - colone 13: "genre" de la voie
  db_gender[arr[5]] = arr[12]
end


# GeoJSON en sortie pour les données "masculines"
out_json_m = { "type" => "FeatureCollection", "features" => [] }

# GeoJSON pour les données "féminines"
out_json_f = { "type" => "FeatureCollection", "features" => [] }


# Itération sur les objets géographiques en provenance des données
# d'OpenStreetMap
obj["features"].each do |b|
  geom = b["geometry"]
  name = b["properties"]["name"]
  next if geom["type"] == "Point" || geom.nil? || name.nil? || db_gender[name].nil?

  b["properties"]["gender"] = db_gender[name]

  out_json_f["features"] << b if db_gender[name] == "F" || db_gender[name] == "FM"
  out_json_m["features"] << b if db_gender[name] == "M" || db_gender[name] == "FM"

  # TODO: On pourrait encore améliorer le script en "discriminant" sur le type
  # de nom de voie ("allée", "rue", "place", ...) et créer ainsi plusieurs
  # GeoJSON en sortie, ajouter dans l'interface html des selectboxes pour
  # chaque fichier de sortie ...

end

# Sauvegarde des GeoJSON en sortie

File.open("./out/male.geojson","w") do |f|
  f.write(JSON.pretty_generate(out_json_m))
end

File.open("./out/female.geojson","w") do |f|
  f.write(JSON.pretty_generate(out_json_f))
end
