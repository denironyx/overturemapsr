
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
#' types <- get_all_overture_schema_types()
#' print(types)
#'
get_all_overture_schema_types <- function() {
  return(names(all_type_theme_map()))
}


#' dataset_path
#'
#' This function returns the S3 path for the specified Overture dataset schema type.
#'
#' @param schema_type Character. Required. The type of feature to select.
#'                      Examples include 'building', 'place', etc. To learn more, run \code{get_all_overture_schema_types()}.
#' @param release_date Character. Optional. The dataset release date (format: 'YYYY-MM-DD').
#'                      Defaults to the latest available release.
#'
#' @return Character. The S3 path to the bucket where the data is stored.
#' @export
#'
#' @examples
#' # Example usage
#' path <- dataset_path('place', release_date = '2025-01-22')
#' print(path)
dataset_path <- function(schema_type, release_date = '2025-01-22') {

  # Get the theme based on the overture_type
  type_theme_map = all_type_theme_map()
  theme = type_theme_map[[schema_type]]

  if(is.null(theme)){
    stop("Invalid schema_type. Run get_all_overture_schema_types() to see available options.")
  }

  # Return the S3 path
  return(paste0("s3://overturemaps-us-west-2/release/", release_date, ".0/theme=",theme, "/type=", schema_type, "/"))
}


#' get_dataset_metadata
#'
#' This function retrieves metadata information for a given dataset type.
#'
#' @param schema_type Character. Required. The type of feature to select.
#' @param release_date Character. Optional. The dataset release date (format: 'YYYY-MM-DD').
#'
#' @return A list containing metadata such as column names and dataset size.
#' @export
#'
#' @examples
#' \donttest{
#' metadata <- get_dataset_metadata('place', release_date = '2025-01-22')
#' print(metadata)
#' }
get_dataset_metadata <- function(schema_type, release_date = '2025-01-22'){
  dataset <- open_dataset(dataset_path(schema_type, release_date))

  cat("Loading data... \n")
  pb <- txtProgressBar(min=0, max = 100, style = 3)

  metadata <- list(
    columns = names(dataset),
    row_count = nrow(dataset)
  )

  setTxtProgressBar(pb, 100)
  close(pb)
  cat("Loading data complete.\n")

  return(metadata)
}


#' record_batch_reader
#'
#' This function retrieves a filtered dataset from the specified Overture dataset type,
#' optionally within a bounding box, and converts it to an `sf` object.
#'
#' @param schema_type Character. Required. The type of feature to select. Examples include 'building', 'place', etc.
#'                      To learn more, run \code{get_all_overture_schema_types()}.
#' @param bbox Numeric vector. Optional. A bounding box specified as c(xmin, ymin, xmax, ymax).
#'             It is recommended to use a bounding box to limit the dataset size and processing time.
#'             Without a bounding box, processing the entire dataset (e.g., buildings over 2 billion) can be time-consuming.
#' @param release_date Character. Optional. The dataset release date (format: 'YYYY-MM-DD').
#'                      Defaults to the latest available release.
#'
#' @return An `sf` object containing the filtered dataset based on the bounding box.
#' @export
#'
#' @examples
#' \donttest{
#' # Example usage with a bounding box takes > 20 secs
#' sf_bbox <- c(-122.5, 37.7, -122.3, 37.8)
#' result <- record_batch_reader(schema_type = 'place', bbox = sf_bbox)
#' print(result)
#' }
#'
#' @importFrom arrow open_dataset
#' @importFrom sf st_as_sf st_make_valid
#' @importFrom dplyr %>% filter collect mutate
#' @importFrom utils setTxtProgressBar txtProgressBar
record_batch_reader <- function(schema_type, bbox = NULL, release_date = '2025-01-22'){

  start_time = Sys.time()
  # Open the dataset based on the overture_type

  dataset <- open_dataset(dataset_path(schema_type, release_date))

  cat("Processing data for ...", dataset_path(schema_type, release_date), "...\n")
  pb <- txtProgressBar(min=0, max = 100, style = 3)

  if(!is.null(bbox)){

    xmin <- bbox[1]
    ymin <- bbox[2]
    xmax <- bbox[3]
    ymax <- bbox[4]

    df <- dataset %>%
      filter(bbox$xmin > xmin,
             bbox$ymin > ymin,
             bbox$xmax < xmax,
             bbox$ymax < ymax) %>%
      collect()

  } else {
    # collect the entire dataset if bbox is not provided  (not recommended)
    warning("Loading huge data... This might take a while...")
    df <- dataset %>%
      collect()
  }

  if (schema_type != "place") {
    # Ensure the dataset has a geometry column
    if (!"geometry" %in% colnames(df)) {
      stop("No geometry column found in the dataset.")
    }

    # Convert to sf object (Handle unsupported geometries)
    df <- tryCatch(
      st_as_sf(df, crs = 4326),
      error = function(e) {
        warning("Unsupported geometry type detected. Attempting to fix...")
        return(st_as_sf(df, crs = 4326))
      }
    )
  }



  setTxtProgressBar(pb, 100)
  close(pb)

  end_time = Sys.time()
  process_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
  cat("Data processing complete. Time taken:", process_time, "seconds.\n")

  return(df)
}

# Example usage (uncomment to test)
# sf_bbox <- c(-122.5, 37.7, -122.3, 37.8)
# result <- record_batch_reader(overture_type = 'place', tbbox = sf_bbox)
# print(result)
