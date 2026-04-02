#' dplyr verbs for mrgsimsds objects
#'
#' Standard dplyr verbs dispatched on an mrgsimsds object. Each verb extracts
#' the underlying Arrow Dataset and forwards all arguments to the corresponding
#' dplyr generic, returning a lazy Arrow query that can be materialized with
#' [dplyr::collect()].
#'
#' @param .data an mrgsimsds object.
#' @param ... passed to the corresponding dplyr generic.
#' @param .add,.drop passed to [dplyr::group_by()].
#' @param .by,.groups passed to [dplyr::summarise()].
#' @param .preserve passed to [dplyr::filter()].
#' @param .by_group passed to [dplyr::arrange()].
#'
#' @return
#' A lazy Arrow query object. Use [dplyr::collect()] to materialize the result
#' into a tibble.
#'
#' @examples
#' mod <- house_ds(end = 24)
#'
#' data <- ev_expand(amt = c(100, 300), ID = 1:10)
#'
#' out <- mrgsim_ds(mod, data)
#'
#' out |> filter(TIME > 0) |> select(ID, TIME, CP) |> collect()
#'
#' out |> group_by(ID) |> summarise(auc = sum(CP)) |> collect()
#'
#' out |> mutate(CP2 = CP^2) |> collect()
#'
#' @name mrgsimsds-verbs
#' @export
group_by.mrgsimsds <- function(.data, ..., .add = FALSE, .drop = TRUE) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::group_by(as_arrow_ds(.data), ..., .add = .add, .drop = .drop)
}

#' @rdname mrgsimsds-verbs
#' @export
select.mrgsimsds <- function(.data, ...) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::select(as_arrow_ds(.data), ...)
}

#' @rdname mrgsimsds-verbs
#' @export
mutate.mrgsimsds <- function(.data, ...) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::mutate(as_arrow_ds(.data), ...)
}

#' @rdname mrgsimsds-verbs
#' @export
filter.mrgsimsds <- function(.data, ..., .by = NULL, .preserve = FALSE) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::filter(as_arrow_ds(.data), ..., .by = {{.by}}, .preserve = .preserve)
}

#' @rdname mrgsimsds-verbs
#' @export
arrange.mrgsimsds <- function(.data, ..., .by_group = FALSE)  {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::arrange(as_arrow_ds(.data), ..., .by_group = FALSE)
}

#' @rdname mrgsimsds-verbs
#' @export
rename.mrgsimsds <- function(.data, ...) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::rename(as_arrow_ds(.data), ...)
}

#' @rdname mrgsimsds-verbs
#' @export
summarise.mrgsimsds <- function(.data, ..., .by = NULL, .groups = NULL) {
  .data <- safe_ds(.data)
  check_files_fatal(.data)
  dplyr::summarise(as_arrow_ds(.data), ..., .by = {{.by}}, .groups = .groups)
}

#' @export
summarize.mrgsimsds <- summarise.mrgsimsds # nocov
