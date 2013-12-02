# opendatacamp-rennes-genre

## De quoi s'agit-il ?

Ce dépot contient mes travaux concernant l'étude genrée du filaire de la ville de Rennes lors de l'OpenDataCamp du 28 novembre 2013, Espace Numa, Paris.

## Présentation

Le code de ce dépot est composé principalement:

 * d'un script ruby
 * d'un répertoire contenant les fichiers d'entrée (`in/`)
 * d'un répertoire pour les fichiers de sortie (`out/`)
 
Le sous-répertoire `in/` contient les fichiers suivants

 * `rennes.geojson`: un export OSM du filaire de la ville de Rennes en GeoJSON ; nous verrons par la suite comment l'obtenir
 * `toponymes.csv`: Fichier "de travail" du groupe de l'OpenDataCamp, dans lequel le genre de chaque élément du filaire s'est vu attribué un genre ('M' pour mâle, 'F' pour femelle, 'MF' si les deux sexes sont représentés - eg. "rue Pierre et Marie Curie" - ou rien si la détermination n'est pas possible)
 
Le sous-répertoire `out/` vise à contenir le resultat de l'exécution du script, ainsi qu'une interface web / géo basée sur la bibliothèque `leaflet`, afin de présenter les données géographiques sur deux cartes distinctes: bleu à gauche pour les éléments "masculins", rose à droite pour les éléments féminins.

En résumé, le script `ruby` se charge de faire la fusion entre les données retravaillées par le groupe de l'OpenDataCamp (le fichier `CSV`) avec les données présentes dans OpenStreetMap (le fichier `GeoJSON`). La "clé" utilisée comme pivot est le nom de l'élément géographique.

## Utilisation

Lancez la commande:

    ruby extract.rb

Ceci aura pour effet de générer deux fichiers `GeoJSON` dans le sous-répertoire `out/`:

 * `female.geojson`: Ensemble des éléments géographiques ayant été détectée comme étant "féminin" ou "les deux"
 * `male.geojson`: ... "masculin" ou "les deux"

Le contenu de ces deux fichiers est ensuite copié en tant que variable `Javascript` dans le code `Javascript` `out/js/rennes-genre.js` (`var female` et `var male` respectivement).

La page HTML `out/leaflet.html` se charge de présenter côte à côte les deux cartes, surchargées des données produites. Un fond OpenStreetMap en niveau de gris est utilisé, et un greffon pour `Leaflet` assure que les deux cartes restent synchronisées quand on zoome ou bouge l'une ou l'autre (c.f. `out/js/L.Map.Sync.js`).

## Récupération du `GeoJSON` depuis `OpenStreetMap`

Le fichier GeoJSON a été réalisé en deux temps. Premièrement, il faut récupérer les données brutes en `XML`, via une requête à l'OverPass API:

    wget -O rennes.osm 'http://overpass-api.de/api/interpreter?data=[out:xml];way(area:3600054517)[name][highway];out meta;>>;out meta;'
    
Cela devrait produire un fichier `rennes.osm` dans le répertoire courant, qu'il suffit d'ouvrir dans `JOSM`, puis de sauvegarder au format `GeoJSON` ("enregistrer sous ..."). Une copie du fichier obtenu est déjà présent dans le sous-répertoire `out/`.



