library(rgdal)
library(spdplyr)
library(geojsonio)
library(rmapshaper)
library(jsonlite)
library(raster)

# read data
shape <- shapefile("/Users/mitchelllisle/Sites/docs/rProgramming/geojson/files/aus_suburbs/suburb_shapefiles/SSC_2011_AUST.shp")
join_data <- read.csv("/Users/mitchelllisle/Sites/docs/rProgramming/geojson/files/aus_suburbs/sub_post_state.csv")

# merge on common variable, here called 'SSC_NAME'
merged_data <- merge(shape, join_data, by = 'SSC_NAME')

# Save as shapefile again
shapefile(merged_data, "/Users/mitchelllisle/Sites/docs/rProgramming/geojson/files/aus_suburbs/suburb_shapefiles/SSC_2011_AUST_1.shp", overwrite = TRUE)

# Read the extracted shapefiles into rgdal function
suburb <- readOGR(dsn = "/Users/mitchelllisle/Sites/docs/rProgramming/geojson/files/aus_suburbs/suburb_shapefiles",
                  layer = "SSC_2011_AUST_1", verbose = FALSE)

# Using the geojsonio package, convert shapefiles to geojson
suburb_json <- geojson_json(suburb)

#simplify to reduce file size (will also reduce polygon accuracy when plotted on map) - use keep = 0.1 to play with simplification
suburb_json_simplified <- ms_simplify(suburb_json)

# Write to geojson file
geojson_write(suburb_json_simplified, file = "/Users/mitchelllisle/Sites/docs/rProgramming/geojson/files//aus_suburbs/suburb_simple.geojson")
