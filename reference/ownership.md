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
#> 1  mrgsims-ds-1aaa78c565a6.parquet 0x5644e762c520
#> 2  mrgsims-ds-1aaa6c1cb585.parquet 0x5644e762c520
#> 3  mrgsims-ds-1aaa1f8dddd5.parquet 0x5644eeea5360
#> 4  mrgsims-ds-1aaa6e73999a.parquet 0x5644ee657b60
#> 5  mrgsims-ds-1aaa10141577.parquet 0x5644e762c520
#> 6                  example.parquet 0x5644ec0a7f38
#> 7  mrgsims-ds-1aaa4dfe41dd.parquet 0x5644ec9912a0
#> 8  mrgsims-ds-1aaa2705545e.parquet 0x5644e762c520
#> 9  mrgsims-ds-1aaa4a56b164.parquet 0x5644eb9f57c8
#> 10 mrgsims-ds-1aaa7e99c604.parquet 0x5644e303c470
#> 11 mrgsims-ds-1aaa35c53035.parquet 0x5644e762c520
#> 12 mrgsims-ds-1aaa564f9876.parquet 0x5644e762c520
#> 13 mrgsims-ds-1aaa2ae134f7.parquet 0x5644e762c520
#> 14 mrgsims-ds-1aaa38eec8f4.parquet 0x5644f1855128
#> 15  mrgsims-ds-1aaab052f62.parquet 0x5644ef1e6b08
#> 16  mrgsims-ds-1aaa1dc49a2.parquet 0x5644f07b4d90
#> 17  mrgsims-ds-1aaaa6e6f71.parquet 0x5644e762c520
#> 18 mrgsims-ds-1aaa2a46e766.parquet 0x5644f02c5100
#> 19 mrgsims-ds-1aaa6ce10b0c.parquet 0x5644e762c520
#> 20 mrgsims-ds-1aaa1eed8777.parquet 0x5644eee4e550
#> 21 mrgsims-ds-1aaa47011c44.parquet 0x5644e762c520

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
