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
#> > Objects: 12 | Files: 21 | Size: 418.7 Kb

list_ownership()
#>                               file        address
#> 1  mrgsims-ds-1b815f547097.parquet 0x558f7bb8a5f0
#> 2   mrgsims-ds-1b815a91d2d.parquet 0x558f72df4e58
#> 3  mrgsims-ds-1b8145cefe47.parquet 0x558f7f390488
#> 4  mrgsims-ds-1b817630a82b.parquet 0x558f7782e0a0
#> 5                  example.parquet 0x558f7c287348
#> 6  mrgsims-ds-1b81631f92ce.parquet 0x558f7782e0a0
#> 7   mrgsims-ds-1b815817b8e.parquet 0x558f7782e0a0
#> 8  mrgsims-ds-1b817ea30903.parquet 0x558f7e3f2b70
#> 9   mrgsims-ds-1b816c63880.parquet 0x558f819fce58
#> 10 mrgsims-ds-1b81152732b3.parquet 0x558f7782e0a0
#> 11 mrgsims-ds-1b8132cd6010.parquet 0x558f7f042b10
#> 12 mrgsims-ds-1b81635212c1.parquet 0x558f80473558
#> 13 mrgsims-ds-1b8119b230e7.parquet 0x558f7efee518
#> 14 mrgsims-ds-1b813c0a3691.parquet 0x558f8095c540
#> 15 mrgsims-ds-1b8116cba86d.parquet 0x558f7782e0a0
#> 16 mrgsims-ds-1b8168f5bf5d.parquet 0x558f7782e0a0
#> 17 mrgsims-ds-1b81346b95e8.parquet 0x558f7dc7f1d8
#> 18 mrgsims-ds-1b8147cc35a0.parquet 0x558f7782e0a0
#> 19 mrgsims-ds-1b812096918f.parquet 0x558f7782e0a0
#> 20 mrgsims-ds-1b81188a47a0.parquet 0x558f7782e0a0
#> 21 mrgsims-ds-1b8134bd6f2e.parquet 0x558f7782e0a0

e1 <- ev(amt = 100)
e2 <- ev(amt = 200)

out <- list(mrgsim_ds(mod, e1), mrgsim_ds(mod, e2))

sims <- reduce_ds(out)

ownership()
#> > Objects: 13 | Files: 23 | Size: 472 Kb

check_ownership(sims)
#> [1] TRUE

check_ownership(out[[1]])
#> [1] FALSE

check_ownership(out[[2]])
#> [1] FALSE

```
