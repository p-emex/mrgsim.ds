# Manage simulated outputs in the per-session temporary directory

Functions for inspecting and cleaning up package-managed parquet files
in [`tempdir()`](https://rdrr.io/r/base/tempfile.html). `list_temp()`
shows what is present; `purge_temp()` removes all package-managed files
unconditionally.

Note: `purge_temp()` should not be needed in routine usage when
simulation output objects are subject to the garbage collector. Calling
it while active objects still point to those files will cause errors on
next data access.

## Usage

``` r
list_temp(quietly = FALSE)

purge_temp(quietly = FALSE)
```

## Arguments

- quietly:

  if `TRUE`, messages will be suppressed.

## Value

`list_temp()` returns a character vector of file paths invisibly, and
prints a summary to the console unless `quietly = TRUE`.

`purge_temp()` returns `NULL` invisibly.

## Examples

``` r
mod <- house_ds()

out <- lapply(1:10, \(x) mrgsim_ds(mod))

list_temp()
#> 15 files [143.7 Kb]
#> - mrgsims-ds-19b711bc572a.parquet
#> - mrgsims-ds-19b71bbfc4f9.parquet
#>    ...
#> - mrgsims-ds-19b75f59211c.parquet
#> - mrgsims-ds-19b764944b2c.parquet

purge_temp()
#> Discarding 15 files.

list_temp()
#> No files in tempdir.
```
