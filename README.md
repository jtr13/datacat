# datacat
Function to Help Explore and Categorize Datasets

Install with:
```
install.packages("remotes")
remotes::install_github("jtr13/datacat")
```

This package has one function, `data_xray()`, which provides an overview of all datasets in a package or packages. It is an alternative to `data()` which only provides the names of the datasets and short descriptions. This function works at the package level. If you are interested in detail about one dataset at a time, there are better options such as `skimr::skim()`. 

To get info on all **loaded** datasets, use `data_xray()`.

To get info on any specific packages, include the package names, such as:
`data_xray(c("ggplot2", "pgmm"))`

It is helpful to view the results with `View()`. If viewing the output in the Console, it's helpful to increase the printing width with `options(width = 100)`.

### Output

Output columns are as follows:

* `package` name of package (optional)
* `name` name of dataset
* `nr_or_len` number of rows or `length()` (whichever is not NULL)
* `nc` number of columns
* `add_dim` additional dimensions (>= 3, such as for tables)
* `first_class` first class listed
* `n_cols` number of numeric columns
* `i_cols` number of integer columns
* `f_cols` number of factor columns
* `c_cols` number of character columns
* `d_cols` number of date columns
* `other_cols` number of other columns
* `allclasses` full list of classes (optional)

### Examples

```
> library(datacat)
> data_xray()
# A tibble: 104 x 12
   package  name           nr_or_len nc    add_dim first_class    n_cols i_cols f_cols c_cols d_cols other_cols
   <chr>    <chr>          <chr>     <chr> <chr>   <chr>           <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
 1 datasets AirPassengers  144       NA    NA      ts                 NA     NA     NA     NA     NA         NA
 2 datasets BJsales        150       NA    NA      ts                 NA     NA     NA     NA     NA         NA
 3 datasets BJsales.lead   150       NA    NA      ts                 NA     NA     NA     NA     NA         NA
 4 datasets BOD            6         2     NA      data.frame          2      0      0      0      0          0
 5 datasets CO2            84        5     NA      nfnGroupedData      2      0      3      0      0          0
 6 datasets ChickWeight    578       4     NA      nfnGroupedData      2      0      2      0      0          0
 7 datasets DNase          176       3     NA      nfnGroupedData      2      0      1      0      0          0
 8 datasets EuStockMarkets 1860      4     NA      mts                 4      0      0      0      0          0
 9 datasets Formaldehyde   6         2     NA      data.frame          2      0      0      0      0          0
10 datasets HairEyeColor   4         4     2       table              NA     NA     NA     NA     NA         NA
# … with 94 more rows
```


```
> data_xray(c("pgmm", "ggplot2"))
# A tibble: 14 x 12
   package name    nr_or_len nc    add_dim first_class n_cols i_cols f_cols c_cols d_cols other_cols
   <chr>   <chr>   <chr>     <chr> <chr>   <chr>        <dbl>  <dbl>  <dbl>  <dbl>  <dbl>      <dbl>
 1 pgmm    coffee  43        14    NA      data.frame      13      0      1      0      0          0
 2 pgmm    olive   572       10    NA      data.frame      10      0      0      0      0          0
 3 pgmm    wine    178       28    NA      data.frame      28      0      0      0      0          0
 4 ggplot2 diamon… 53940     10    NA      tbl_df           6      1      3      0      0          0
 5 ggplot2 econom… 574       6     NA      spec_tbl_df      5      0      0      0      1          0
 6 ggplot2 econom… 2870      4     NA      tbl_df           2      0      0      1      1          0
 7 ggplot2 faithf… 5625      3     NA      tbl_df           3      0      0      0      0          0
 8 ggplot2 luv_co… 657       4     NA      data.frame       3      0      0      1      0          0
 9 ggplot2 midwest 437       28    NA      tbl_df          15     10      0      3      0          0
10 ggplot2 mpg     234       11    NA      tbl_df           1      4      0      6      0          0
11 ggplot2 msleep  83        11    NA      tbl_df           6      0      0      5      0          0
12 ggplot2 presid… 11        4     NA      tbl_df           0      0      0      2      2          0
13 ggplot2 seals   1155      4     NA      tbl_df           4      0      0      0      0          0
14 ggplot2 txhous… 8602      9     NA      tbl_df           6      2      0      1      0          0
```


