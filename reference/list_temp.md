# Manage simulated outputs in the per-session temporary directory

Functions for inspecting and cleaning up package-managed parquet files
in [`tempdir()`](https://rdrr.io/r/base/tempfile.html). `list_temp()`
shows what is present; `purge_except_temp()` removes everything except
the files belonging to specified objects; `purge_temp()` removes all
package-managed files unconditionally.

Note: `purge_temp()` and `purge_except_temp()` should not be needed in
routine usage when simulation output objects are subject to the garbage
collector. Calling them while active objects still point to those files
will cause errors on next data access.

## Usage

``` r
list_temp(quietly = FALSE)

purge_except_temp(..., quietly = FALSE)

purge_temp(quietly = FALSE)
```

## Arguments

- quietly:

  if `TRUE`, messages will be suppressed.

- ...:

  mrgsimsds objects whose files will be retained by
  `purge_except_temp()`; non-mrgsimsds objects are ignored with a
  warning.

## Value

`list_temp()` returns a character vector of file paths invisibly, and
prints a summary to the console unless `quietly = TRUE`.

`purge_except_temp()` and `purge_temp()` return `NULL` invisibly.

## Examples

``` r
mod <- house_ds()

out <- lapply(1:10, \(x) mrgsim_ds(mod))

list_temp()
#> 15 files [143.7 Kb]
#> - mrgsims-ds-19fa171945f.parquet
#> - mrgsims-ds-19fa1afaccd.parquet
#>    ...
#> - mrgsims-ds-19fa76d6ad8b.parquet
#> - mrgsims-ds-19faf47c671.parquet

sims <- reduce_ds(out)

list_temp()
#> 15 files [143.7 Kb]
#> - mrgsims-ds-19fa171945f.parquet
#> - mrgsims-ds-19fa1afaccd.parquet
#>    ...
#> - mrgsims-ds-19fa76d6ad8b.parquet
#> - mrgsims-ds-19faf47c671.parquet

purge_except_temp(sims)
#> Discarding 5 files.

list_temp()
#> 10 files [51.3 Kb]
#> - mrgsims-ds-19fa1afaccd.parquet
#> - mrgsims-ds-19fa218584cf.parquet
#>    ...
#> - mrgsims-ds-19fa76d6ad8b.parquet
#> - mrgsims-ds-19faf47c671.parquet

purge_temp()
#> Discarding 10 files.

list_temp()
#> No files in tempdir.
```
