# Move, rename, or write out data set files

Use `move_ds()` to change the enclosing directory. `write_ds()` can also
move the files, but it always condenses the simulation output into a
single parquet file if multiple files are backing the mrgsimsds object.
All operations are made on the object in place.

There is an important distinction between `write_ds()` and `move_ds()`
or `rename_ds()` for multi-file objects. The backing files can be moved
or renamed with little computational effort. For multi-file simulation
outputs, `write_ds()` will need to read each file and write the data out
to a single file. Apache Arrow can do this very efficiently, but there
will still be an additional, potentially noticeable computational
effort.

### Automatic gc adjustment

Both `move_ds()` and `write_ds()` automatically update the gc flag based
on where the files end up: files that remain under
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) keep `gc = TRUE`;
files moved outside [`tempdir()`](https://rdrr.io/r/base/tempfile.html)
get `gc = FALSE`, protecting them from automatic deletion. `rename_ds()`
never changes the gc flag because it does not change the file location.

This automatic adjustment is skipped if the gc setting has been locked
by a prior call to
[`gc_ds()`](https://kylebaron.github.io/mrgsim.ds/reference/gc_ds.md). A
warning is issued if gc is locked to `TRUE` but files land outside
[`tempdir()`](https://rdrr.io/r/base/tempfile.html).

The object (`x`) is required to own the underlying files in order to
move or rename them; ownership is not required for `write_ds()`.

All three functions modify `x` in place and file ownership stays with
`x`.

## Usage

``` r
move_ds(x, path)

rename_ds(x, id)

write_ds(x, sink, ...)
```

## Arguments

- x:

  an mrgsimsds object.

- path:

  the new directory location for backing files.

- id:

  a short name used to create data set files for the simulated output.

- sink:

  the complete path (including file name) for a single parquet file
  containing all simulated data; passed to
  [`arrow::write_parquet()`](https://arrow.apache.org/docs/r/reference/write_parquet.html).

- ...:

  passed to
  [`arrow::write_parquet()`](https://arrow.apache.org/docs/r/reference/write_parquet.html);
  files are always written in parquet format.

## Value

All three functions return `x` invisibly. The updated file list is
accessible via `x$files`.

## Examples

``` r
mod <- house_ds()

out <- lapply(1:3, \(x) { mrgsim_ds(mod, events = ev(amt = 100)) })

out <- reduce_ds(out)

rename_ds(out, id = "example-sims")

basename(out$files)
#> [1] "mrgsims-ds-example-sims-0001.parquet"
#> [2] "mrgsims-ds-example-sims-0002.parquet"
#> [3] "mrgsims-ds-example-sims-0003.parquet"

write_ds(out, sink = file.path(tempdir(), "example.parquet"))

basename(out$files)
#> [1] "example.parquet"

if (FALSE) { # \dontrun{
  move_ds(out, path = "data/simulated") 
} # }
```
