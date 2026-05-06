#' Manage simulated outputs in the per-session temporary directory
#'
#' @description
#' Functions for inspecting and cleaning up package-managed parquet files in
#' `tempdir()`. `list_temp()` shows what is present; `purge_temp()`
#' removes all package-managed files unconditionally.
#'
#' Note: `purge_temp()` should not be needed in routine usage when simulation
#' output objects are subject to the garbage collector. Calling it while active
#' objects still point to those files will cause errors on next data access.
#'
#' @param quietly if `TRUE`, messages will be suppressed.
#'
#' @return
#' `list_temp()` returns a character vector of file paths invisibly, and prints
#' a summary to the console unless `quietly = TRUE`.
#'
#' `purge_temp()` returns `NULL` invisibly.
#'
#' @examples
#' mod <- house_ds()
#'
#' out <- lapply(1:10, \(x) mrgsim_ds(mod))
#'
#' list_temp()
#'
#' purge_temp()
#'
#' list_temp()
#'
#' @export
list_temp <- function(quietly = FALSE) {
  temp <- list.files(tempdir(), pattern = .global$file.re, full.names = TRUE)
  if(isTRUE(quietly)) {
    return(invisible(temp))
  }
  if(!length(temp)) {
    message("No files in tempdir.")
    return(invisible(temp))
  }
  size <- total_size(temp)
  if(length(temp) < 6) {
    show <- paste0("- ", basename(temp))
  } else {
    show <- c(
      paste0("- ", basename(head(temp, n = 2))),
      "   ...",
      paste0("- ", basename(tail(temp, n = 2)))
    )
  }
  header <- paste0(length(temp), " files [", size, "]")
  cat(c(header, show), sep = "\n")
  return(invisible(temp))
}

#' @rdname list_temp
#' @export
purge_temp <- function(quietly = FALSE) {
  temp <- list.files(tempdir(), pattern = .global$file.re, full.names = TRUE)
  unlink(x = temp, recursive = TRUE)
  if(!isTRUE(quietly)) {
    message("Discarding ", length(temp), " files.")
  }
  return(invisible(NULL))
}
