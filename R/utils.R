#' Title
#'
#' @param overture_type
#'
#' @return
#' @export
#'
#' @examples
dataset_path <- function(overture_type) {
  type_theme_map = list(
    "locality" = "admins",
    "locality_area" = "admins",
    "administrative_boundary" = "admins",
    "building" = "buildings",
    "building_part" = "buildings",
    "division" = "divisions",
    "division_area" = "divisions",
    "place" = "places",
    "segment" = "transportation",
    "connector" = "transportation",
    "infrastructure" = "base",
    "land" = "base",
    "land_cover" = "base",
    "land_use" = "base",
    "water" = "base"
  )

  theme = type_theme_map[[overture_type]]
  return(paste0("s3://overturemaps-us-west-2/release/2024-05-16-beta.0/theme=",theme, "?region=us-west-2"))
}



#' get_all_overture_types
#'
#' @return
#' @export
#'
#' @examples
get_all_overture_types <- function() {
  type_theme_map = list(
    "locality" = "admins",
    "locality_area" = "admins",
    "administrative_boundary" = "admins",
    "building" = "buildings",
    "building_part" = "buildings",
    "division" = "divisions",
    "division_area" = "divisions",
    "place" = "places",
    "segment" = "transportation",
    "connector" = "transportation",
    "infrastructure" = "base",
    "land" = "base",
    "land_cover" = "base",
    "land_use" = "base",
    "water" = "base"
  )

  return(names(type_theme_map))
}


record_batch_reader <- function(overture_type, bbox = NULL) {
  path <- dataset_path(overture_type)

  filter_ex
}

