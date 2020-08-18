#' Get detailed info on R package datasets
#'
#' @description
#' finds all datasets in a specified package and returns a tibble with information on the dimensions of the datasets as well as data types. It is an alternative to `data()` which simply lists the datasets with short descriptions.
#'
#' @param packagenames a character vector providing the package(s) to look in for data sets, or `NULL`. If `NULL`, all loaded packages will be searched.
#'
#' @param link a logical. If `TRUE` `name` column links to dataset documentation on rdrr.io. Helpful for `.html` output. Defaults to `FALSE`.
#'
#' @section Output columns:
#'
#' * `package` name of package
#' * `name` name of dataset
#' * `nr_or_len` `nrow()` or `length()` (whichever is not `NULL`)
#' * `nc` `ncol()`
#' * `add_dim` additional dimensions (>= 3, such as for tables)
#' * `classes` dataset classes
#' * `n_cols` number of numeric columns
#' * `i_cols` number of integer columns
#' * `f_cols` number of factor columns
#' * `c_cols` number of character columns
#' * `d_cols` number of date columns
#' * `other_cols` number of other columns
#'
#' @examples
#'
#' x <- data_xray("ggplot2")
#' View(x)
#'
#' x <- data_xray()
#' View(x)
#'
#' x <- data_xray(c("fivethirtyeight", "pgmm"))
#' View(x)

#' @export
data_xray <- function(packagenames = NULL,
                             include_package = TRUE,
                             allclasses = FALSE,
                             link = FALSE) {
  datasetnames <- data(package = packagenames)$results[,3]
  datasetpackages <- data(package = packagenames)$results[,1]

  if (!is.null(packagenames)) lapply(packagenames, library, character.only = TRUE)

  # load data from packages since some might not be lazy load

  lapply(packagenames, loaddata)

  # get rid of everything after space in dataset name
  datasetnames <- unlist(purrr::map(strsplit(datasetnames, " "), ~.x[[1]]))

  nr <- purrr::map_chr(datasetnames,
                      ~ifelse(is.null(nrow(get(.x))), NA, nrow(get(.x))))

  l <- unlist(purrr::map(datasetnames, ~ifelse(is.null(dim(get(.x))), length(get(.x)), NA)))

  nr_or_len <- purrr::map2_chr(nr, l, ~na.omit(c(.x, .y)))

  nc <- purrr::map_chr(datasetnames, ~ifelse(is.null(ncol(get(.x))), NA, ncol(get(.x))))

  add_dim <- purrr::map_chr(datasetnames,
                            ~ifelse(length(dim(get(.x))) > 2,
                                    paste(dim(get(.x))[3:length(dim(get(.x)))],
                                          collapse = "  "), NA))
  classes <- unlist(purrr::map(datasetnames, ~paste(class(get(.x)),
                                                    collapse = ", ")))

  ncol <- unlist(purrr::map(datasetnames,
                            ~ifelse(length(dim(get(.x))) == 2,
                                    dim(get(.x))[[2]],
                                    NA)))

  n_cols <- unlist(purrr::map2(datasetnames, "numeric", get_type_count))
  i_cols <- unlist(purrr::map2(datasetnames, "integer", get_type_count))
  f_cols <- unlist(purrr::map2(datasetnames, "factor", get_type_count))
  c_cols <- unlist(purrr::map2(datasetnames, "character", get_type_count))
  d_cols <- unlist(purrr::map2(datasetnames, "Date", get_type_count))

  other_cols <- ncol - (n_cols + i_cols + f_cols + c_cols + d_cols)

  output_df <- dplyr::bind_cols(tibble::tibble(package = datasetpackages, name = datasetnames,
                                               nr_or_len, nc, add_dim, classes, n_cols, i_cols, f_cols,
                                               c_cols, d_cols, other_cols))


# from https://rpubs.com/erblast/369527

link_exists <- function(link) {
    !is.na(tryCatch(xml2::read_html(link),
                   error = function(e) {NA}))
  }


  if (link) {
    output_df <- output_df %>%
      dplyr::mutate(link = paste0("https://rdrr.io/cran/",
                                package, "/man/", name, ".html")) %>%
      dplyr::mutate(name = purrr::map2_chr(link, name, ~ifelse(link_exists(.x),
                                paste0("<a target=_blank href=", .x, ">", .y, "</a>"), .y))) %>%
      dplyr::select(-link)
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