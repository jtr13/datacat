# datacat
Functions to Help Explore and Categorize Datasets

Install with:
```
install.packages("remotes")
remotes::install_github("jtr13/datacat")
```

This package has one function, `get_dataset_info()`, which provides an overview of all datasets in a package or packages. It is an alternative to `data()` which only provides

Usage:

```
> options(width = 100)
> library(datacat)
> get_dataset_info()
# A tibble: 104 x 11
   package  name          dim     length first_class   n_cols i_cols f_cols c_cols d_cols other_cols
   <chr>    <chr>         <chr>    <int> <chr>          <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
 1 datasets AirPassengers NA         144 ts                NA     NA     NA     NA     NA         NA
 2 datasets BJsales       NA         150 ts                NA     NA     NA     NA     NA         NA
 3 datasets BJsales.lead  NA         150 ts                NA     NA     NA     NA     NA         NA
 4 datasets BOD           6  2        NA data.frame         2      0      0      0      0          0
 5 datasets CO2           84  5       NA nfnGroupedDa…      2      0      3      0      0          0
 6 datasets ChickWeight   578  4      NA nfnGroupedDa…      2      0      2      0      0          0
 7 datasets DNase         176  3      NA nfnGroupedDa…      2      0      1      0      0          0
 8 datasets EuStockMarke… 1860  4     NA mts               NA     NA     NA     NA     NA         NA
 9 datasets Formaldehyde  6  2        NA data.frame         2      0      0      0      0          0
10 datasets HairEyeColor  4  4  2     NA table             NA     NA     NA     NA     NA         NA
# … with 94 more rows

