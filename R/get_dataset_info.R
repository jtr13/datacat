#' Get detailed info on R package datasets
#'
#' @description
#' finds all datasets in a specified package and returns a tibble with information on the dimensions of the datasets as well as data types. It is an alternative to `data()` which simply lists the datasets with short descriptions.
#'
#' @param packagenames a character vector providing the package(s) to look in for data sets, or `NULL`. If `NULL`, all loaded packages will be searched.
#'
#' @param allclasses a logical. If `TRUE` a column with all classes (not only the first one listed) is included. Defaults to `FALSE`.
#'
#' @section Output columns:
#'
#' * `package` name of package
#' * `name` name of dataset
#' * `dim_or_len` `dim()` or `length()` (whichever is not `NULL`)
#' * `first_class` first class listed
#' * `n_cols` number of numeric columns
#' * `i_cols` number of integer columns
#' * `f_cols` number of factor columns
#' * `c_cols` number of character columns
#' * `d_cols` number of date columns
#' * `other_cols` number of other columns
#' * `allclasses` full list of classes [optional]
#'
#'
#' @examples
#'
#' x <- get_dataset_info("ggplot2")
#' View(x)
#'
#' x <- get_dataset_info()
#' View(x)
#'
#' x <- get_dataset_info(c("fivethirtyeight", "pgmm"))
#' View(x)

#' @export
get_dataset_info <- function(packagenames = NULL, allclasses = FALSE) {
  datasetnames <- data(package = packagenames)$results[,3]
  datasetpackages <- data(package = packagenames)$results[,1]

  if (!is.null(packagenames)) lapply(packagenames, library, character.only = TRUE)

  # load data from packages since some might not be lazy load

  lapply(packagenames, loaddata)

  # get rid of everything after space in dataset name
  datasetnames <- unlist(purrr::map(strsplit(datasetnames, " "), ~.x[[1]]))


  dim <- purrr::map_chr(datasetnames,
                        ~ifelse(length(dim(get(.x))) > 0,
                                paste(dim(get(.x)), collapse = "  "),
                                NA))

  length <- unlist(purrr::map(datasetnames, ~ifelse(is.null(dim(get(.x))), length(get(.x)), NA)))

  dim_or_len <- na.omit(c(dim, length))

  ncol <- unlist(purrr::map(datasetnames,
                            ~ifelse(length(dim(get(.x))) == 2,
                                    dim(get(.x))[[2]],
                                    NA)))



  first_class <- unlist(purrr::map(datasetnames, ~class(get(.x))[1]))

  n_cols <- unlist(purrr::map2(datasetnames, "numeric", get_type_count))
  i_cols <- unlist(purrr::map2(datasetnames, "integer", get_type_count))
  f_cols <- unlist(purrr::map2(datasetnames, "factor", get_type_count))
  c_cols <- unlist(purrr::map2(datasetnames, "character", get_type_count))
  d_cols <- unlist(purrr::map2(datasetnames, "Date", get_type_count))

  other_cols <- ncol - (n_cols + i_cols + f_cols + c_cols + d_cols)

  # this needs work
  #  cnames <- unlist(purrr::map(datasetnames, ~paste(colnames(data.frame(get(.x))), collapse = " ")))

  output_df <- dplyr::bind_cols(tibble::tibble(package = datasetpackages, name = datasetnames,
                                               dim_or_len, first_class, n_cols, i_cols, f_cols,
                                               c_cols, d_cols, other_cols))

  if (allclasses) {
    allclasses <- unlist(purrr::map(datasetnames, ~paste(class(get(.x)), collapse = ", ")))
    output_df <- output_df %>% mutate(allclasses = allclasses)
  }

  output_df
}

# Helpers --------------------------------------------------

get_type_count <- function(dataset, datatype) {
  dataset <- get(dataset)
  dsclass <- class(dataset)
  if ("matrix" %in% dsclass) dataset <- data.frame(dataset)
  if(("data.frame" %in% dsclass) | "matrix" %in% dsclass) {
    num_cols <- summary(as.factor(unlist(lapply(dataset, class))))[datatype]
    if (is.na(num_cols)) num_cols <- 0
  } else {
    num_cols <- NA
  }
  num_cols
}

# load data if not lazy load
loaddata <- function(package) {
  datasets <- data(package = package)$results[,3]
  if (!exists(datasets[1])) data(list = datasets, package = package)
}