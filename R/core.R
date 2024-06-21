
#' get_all_overture_types
#'
#' This function returns all of the overturemaps theme types.
#'
#' @return Character vector. All overturemaps theme types.
#'
#' @note The theme types are important for fetching data from the S3 bucket,
#'       as they indicate if you are fetching places, buildings, admin, etc.
#' @export
#'
#' @examples
#' # Example usage
#' types <- get_all_overture_types()
#' print(types)
#'
get_all_overture_types <- function() {
  return(names(all_type_theme_map()))
}


#' dataset_path
#'
#' This function returns the S3 path for the specified Overture dataset type.
#'
#' @param overture_type Character. Required. The type of feature to select.
#'                      Examples include 'building', 'place', etc. To learn more, run \code{get_all_overture_types()}.
#'
#' @return Character. The S3 path to the bucket where the data is stored.
#' @export
#'
#' @examples
#' # Example usage
#' path <- dataset_path('place')
#' print(path)
dataset_path <- function(overture_type) {

  # Get the theme based on the overture_type
  type_theme_map = all_type_theme_map()
  theme = type_theme_map[[overture_type]]

  # Return the S3 path
  return(paste0("s3://overturemaps-us-west-2/release/2024-05-16-beta.0/theme=",theme, "/type=", overture_type, "/"))
}



#' record_batch_reader
#'
#' This function retrieves a filtered dataset from the specified Overture dataset type,
#' optionally within a bounding box, and converts it to an `sf` object.
#'
#' @param overture_type Character. Required. The type of feature to select. Examples include 'building', 'place', etc.
#'                      To learn more, run \code{get_all_overture_types()}.
#' @param bbox Numeric vector. Optional. A bounding box specified as c(xmin, ymin, xmax, ymax).
#'             It is recommended to use a bounding box to limit the dataset size and processing time.
#'             Without a bounding box, processing the entire dataset (e.g., buildings over 2 billion) can be time-consuming.
#'
#' @return An `sf` object containing the filtered dataset based on the bounding box.
#' @export
#'
#' @examples
#' \donttest{
#' # Example usage with a bounding box takes > 20 secs
#' sf_bbox <- c(-122.5, 37.7, -122.3, 37.8)
#' result <- record_batch_reader(overture_type = 'place', bbox = sf_bbox)
#' print(result)
#' }
#'
#' @importFrom arrow open_dataset
#' @importFrom sf st_as_sf
#' @importFrom dplyr %>% filter collect
record_batch_reader <- function(overture_type, bbox = NULL){

  # Open the dataset based on the overture_type
  dataset <- open_dataset(dataset_path(overture_type))

  # based on kyle walker code - https://walker-data.com/posts/overture-buildings/
  if(!is.null(bbox)){

    xmin <- bbox[1]
    ymin <- bbox[2]
    xmax <- bbox[3]
    ymax <- bbox[4]

    filtered_df <- dataset %>%
      filter(bbox$xmin > xmin,
             bbox$ymin > ymin,
             bbox$xmax < xmax,
             bbox$ymax < ymax) %>%
      collect() %>%
      st_as_sf(crs = 4326)
  } else {
    # collect the entire dataset if bbox is not provided  (not recommended)
    filtered_df <- dataset %>%
      collect()
  }

  return(filtered_df)
}

# Example usage (uncomment to test)
# sf_bbox <- c(-122.5, 37.7, -122.3, 37.8)
# result <- record_batch_reader(overture_type = 'place', tbbox = sf_bbox)
# print(result)
