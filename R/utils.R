# Define the mapping of overture types to their themes

all_type_theme_map <- function(){
    type_theme_map = list(
    "address" = "addresses",
    "bathymetry" = "base",
    "building" = "buildings",
    "building_part" = "buildings",
    "division" = "divisions",
    "division_area" = "divisions",
    "division_boundary" = "divisions",
    "place" = "places",
    "segment" = "transportation",
    "connector" = "transportation",
    "infrastructure" = "base",
    "land" = "base",
    "land_cover" = "base",
    "land_use" = "base",
    "water" = "base"
  )
    return(type_theme_map)
}
