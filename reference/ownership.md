# Ownership of simulation files

Functions to check ownership or disown simulation output files on disk.

One situation where you need to take over ownership is when you are
simulating in parallel, and the simulation happens in another R process.
`mrgsim.ds` ownership is established when the simulation returns and the
`mrgsimsds` object is created. When this happens in another R process
(e.g., on a worker node), there is no way to transfer that information
back to the parent process. In that case, a call to `take_ownership()`
once the results are returned to the parent process would be
appropriate. Typically, these results are returned as a list and a call
to
[`reduce_ds()`](https://kylebaron.github.io/mrgsim.ds/reference/reduce_ds.md)
will create a single object pointing to and owning multiple files.
Therefore, it should be rare to call `take_ownership()` directly; if
doing so, please make sure you understand what is going on.

## Usage

``` r
ownership()

list_ownership(full.names = FALSE)

check_ownership(x)

disown(x)

take_ownership(x)
```

## Arguments

- full.names:

  if `TRUE`, include the directory path when listing file ownership.

- x:

  an mrgsimsds object.

## Value

- `check_ownership`: `TRUE` if `x` owns the underlying files; `FALSE`
  otherwise.

- `list_ownership`: a data.frame of ownership information.

- `ownership`: nothing; used for side effects.

- `disown`: `x` is returned invisibly; it is not modified.

- `take_ownership`: `x` is returned invisibly after its hash and the
  package-level ownership maps are updated in place.

## See also

[`reduce_ds()`](https://kylebaron.github.io/mrgsim.ds/reference/reduce_ds.md),
[`copy_ds()`](https://kylebaron.github.io/mrgsim.ds/reference/copy_ds.md).

## Examples

``` r
mod <- house_ds()

out <- mrgsim_ds(mod, id = 1)

check_ownership(out)
#> [1] TRUE

ownership()
#> > Objects: 9 | Files: 9 | Size: 330 Kb

list_ownership()
#>                              file        address
#> 1  mrgsims-ds-1a5c1720728.parquet 0x55f4539e4ae0
#> 2  mrgsims-ds-1a5c91643d3.parquet 0x55f45c92a720
#> 3  mrgsims-ds-1a5c1db7ee4.parquet 0x55f45d3cce78
#> 4  mrgsims-ds-1a5c16ebc22.parquet 0x55f45d1a6d88
#> 5 mrgsims-ds-1a5c6e06970e.parquet 0x55f45d7781e8
#> 6 mrgsims-ds-1a5c7ce2ffc9.parquet 0x55f4595f91e8
#> 7 mrgsims-ds-1a5c5ef9743b.parquet 0x55f4626d0e80
#> 8 mrgsims-ds-1a5c3c9f2b5f.parquet 0x55f45c4dc758
#> 9 mrgsims-ds-1a5c2f05ab6d.parquet 0x55f45e947268

e1 <- ev(amt = 100)
e2 <- ev(amt = 200)

out <- list(mrgsim_ds(mod, e1), mrgsim_ds(mod, e2))

sims <- reduce_ds(out)

ownership()
#> > Objects: 10 | Files: 11 | Size: 383.3 Kb

check_ownership(sims)
#> [1] TRUE

check_ownership(out[[1]])
#> [1] FALSE

check_ownership(out[[2]])
#> [1] FALSE

```
