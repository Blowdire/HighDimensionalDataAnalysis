This template demonstrates many of the bells and whistles of the `reprex::reprex_document()` output format. The YAML sets many options to non-default values, such as using `#;-)` as the comment in front of output.

## Code style

Since `style` is `TRUE`, this difficult-to-read code (look at the `.Rmd` source file) will be restyled according to the Tidyverse style guide when it’s rendered. Whitespace rationing is not in effect!

``` r
x=1;y=2;z=x+y;z
#;-) [1] 3
```

## Quiet tidyverse

The tidyverse meta-package is quite chatty at startup, which can be very useful in exploratory, interactive work. It is often less useful in a reprex, so by default, we suppress this.

However, when `tidyverse_quiet` is `FALSE`, the rendered result will include a tidyverse startup message about package versions and function masking.

``` r
library(tidyverse)
#;-) ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#;-) ✔ dplyr     1.1.1     ✔ readr     2.1.4
#;-) ✔ forcats   1.0.0     ✔ stringr   1.5.0
#;-) ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
#;-) ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#;-) ✔ purrr     1.0.1     
#;-) ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#;-) ✖ dplyr::filter() masks stats::filter()
#;-) ✖ dplyr::lag()    masks stats::lag()
#;-) ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## Chunks in languages other than R

Remember: knitr supports many other languages than R, so you can reprex bits of code in Python, Ruby, Julia, C++, SQL, and more. Note that, in many cases, this still requires that you have the relevant external interpreter installed.

Let’s try Python!

``` python
x = 'hello, python world!'
print(x.split(' '))
```

And bash!

``` bash
echo "Hello Bash!";
pwd;
ls | head;
#;-) Hello Bash!
#;-) /Users/rubenagazzi/Documents/universita/HighDimensionalDataAnalysis
#;-) HighDimensionalDataAnalysis.Rproj
#;-) Progetto.Rmd
#;-) Progetto1.Rmd
#;-) Progetto1_reprex.Rmd
#;-) Progetto1_reprex_std_out_err.txt
#;-) Report
#;-) _cache
#;-) templates
```

Write a function in C++, use Rcpp to wrap it and …

``` cpp
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}
```

then immediately call your C++ function from R!

``` r
timesTwo(1:4)
#;-) [1] 2 4 6 8
```

## Standard output and error

Some output that you see in an interactive session is not actually captured by rmarkdown, when that same code is executed in the context of an `.Rmd` document. When `std_out_err` is `TRUE`, `reprex::reprex_render()` uses a feature of `callr:r()` to capture such output and then injects it into the rendered result.

Look for this output in a special section of the rendered document (and notice that it does not appear right here).

``` r
system2("echo", args = "Output that would normally be lost")
```

## Session info

Because `session_info` is `TRUE`, the rendered result includes session info, even though no such code is included here in the source document.

<details style="margin-bottom:10px;">
<summary>
Standard output and standard error
</summary>

``` sh
✖ Install the styler package in order to use `style = TRUE`.
running: bash  -c 'echo "Hello Bash!";
pwd;
ls | head;'
Building shared library for Rcpp code chunk...
ld: warning: -undefined dynamic_lookup may not work with chained fixups
Output that would normally be lost
```

</details>
<details style="margin-bottom:10px;">
<summary>
Session info
</summary>

``` r
sessionInfo()
#;-) R version 4.2.2 (2022-10-31)
#;-) Platform: aarch64-apple-darwin20 (64-bit)
#;-) Running under: macOS Ventura 13.2.1
#;-) 
#;-) Matrix products: default
#;-) BLAS:   /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRblas.0.dylib
#;-) LAPACK: /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/lib/libRlapack.dylib
#;-) 
#;-) locale:
#;-) [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
#;-) 
#;-) attached base packages:
#;-) [1] stats     graphics  grDevices utils     datasets  methods   base     
#;-) 
#;-) other attached packages:
#;-)  [1] lubridate_1.9.2 forcats_1.0.0   stringr_1.5.0   dplyr_1.1.1    
#;-)  [5] purrr_1.0.1     readr_2.1.4     tidyr_1.3.0     tibble_3.2.1   
#;-)  [9] ggplot2_3.4.2   tidyverse_2.0.0
#;-) 
#;-) loaded via a namespace (and not attached):
#;-)  [1] Rcpp_1.0.10      pillar_1.9.0     compiler_4.2.2   tools_4.2.2     
#;-)  [5] digest_0.6.31    timechange_0.2.0 evaluate_0.20    lifecycle_1.0.3 
#;-)  [9] gtable_0.3.3     pkgconfig_2.0.3  rlang_1.1.0      reprex_2.0.2    
#;-) [13] cli_3.6.1        rstudioapi_0.14  yaml_2.3.7       xfun_0.38       
#;-) [17] fastmap_1.1.1    withr_2.5.0      knitr_1.42       generics_0.1.3  
#;-) [21] fs_1.6.1         vctrs_0.6.1      hms_1.1.3        grid_4.2.2      
#;-) [25] tidyselect_1.2.0 glue_1.6.2       R6_2.5.1         fansi_1.0.4     
#;-) [29] rmarkdown_2.21   tzdb_0.3.0       magrittr_2.0.3   scales_1.2.1    
#;-) [33] htmltools_0.5.5  colorspace_2.1-0 utf8_1.2.3       stringi_1.7.12  
#;-) [37] munsell_0.5.0
```

</details>
