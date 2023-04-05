# Encoding Categorical Predictors

Agazzi Ruben <br />
Davide Dell’Orto <br />
Hellem Carrasco <br />

## Abstract

This is a comprehensive analysis of how categorical, and more general non numerical data can be encoded into a numerical form, in order to be used by all types of models.
In particular will be addressed how to manage unordered and ordered categorical data, and also how to extract features from textual data.

## Summary

## Chapter 1

Handling categorial data is a very important step during the implementation of a statistical or machine learning model. Most of the models does not accept categorical data, but only numerical data. The only models that accepts this type of data are tree-based model which can handle this type of data by default.

### Dummy Variables

The most basic approach used for handling unordered categorical data, consists in creating dummy or indicator variables. The most common form is creating binary dummy variables for categorical predictors: if the categorical predictor can assume 3 values we can create 2 binary dummy variables where value 1 will be, for example, d1=1 and d2=0, value 2 will be d1=0 and d2=1 and where value 3 will be d1=0 and d2=0. We could also represent this type of categorical data with 3 dummy variables, but this approach could lead, sometimes, to problems: some models, in order to estimate their parameters, needs to invert the matrix $(X'X)$, if the model has an intercept an additional column of one for all columns is added to the $X$ matrix; if we add the new 3 dummy variables this will add to the previous intercept row, and this linear combination would prevent the $(X'X)$ matrix to be invertible. This is the reason why we encode $C$ different categories into $C-1$ dummy variables

### Code

This piece of code shows a way of encoding the seven days of weeks into 6 dummy variables

``` r
library(tidymodels)
#;-) ── Attaching packages ────────────────────────────────────── tidymodels 1.0.0 ──
#;-) ✔ broom        1.0.4     ✔ recipes      1.0.5
#;-) ✔ dials        1.2.0     ✔ rsample      1.1.1
#;-) ✔ dplyr        1.1.1     ✔ tibble       3.2.1
#;-) ✔ ggplot2      3.4.2     ✔ tidyr        1.3.0
#;-) ✔ infer        1.0.4     ✔ tune         1.1.0
#;-) ✔ modeldata    1.1.0     ✔ workflows    1.1.3
#;-) ✔ parsnip      1.0.4     ✔ workflowsets 1.0.0
#;-) ✔ purrr        1.0.1     ✔ yardstick    1.1.0
#;-) ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
#;-) ✖ purrr::discard() masks scales::discard()
#;-) ✖ dplyr::filter()  masks stats::filter()
#;-) ✖ dplyr::lag()     masks stats::lag()
#;-) ✖ recipes::step()  masks stats::step()
#;-) • Search for functions across packages at https://www.tidymodels.org/find/
library(FeatureHashing)
library(stringr)
#;-) 
#;-) Attaching package: 'stringr'
#;-) The following object is masked from 'package:recipes':
#;-) 
#;-)     fixed
library('fastDummies')
days_of_week <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday")
test_df <- data.frame(days_of_week)
test_df <- dummy_cols(test_df, select_columns = c('days_of_week'))
test_df = test_df[-c(5)]
```

![Table of encoded days of week using 6 dummy variables](./images/dummy_days_of_week_2.png)

## Encoding predictors mith many categories

``` r
library(tidymodels)
library(FeatureHashing)
library(stringr)

options(width = 150)


load("./Datasets/okc.RData")

towns_to_sample <- c(
  'alameda', 'belmont', 'benicia', 'berkeley', 'castro_valley', 'daly_city', 
  'emeryville', 'fairfax', 'martinez', 'menlo_park', 'mountain_view', 'oakland', 
  'other', 'palo_alto', 'san_francisco', 'san_leandro', 'san_mateo', 
  'san_rafael', 'south_san_francisco', 'walnut_creek'
)

# Sampled locations from "where_town" column
locations_sampled <- okc_train %>% dplyr::select(where_town) %>% distinct(where_town) %>% arrange(where_town)

hashes <- hashed.model.matrix(
  ~ where_town,
  data = locations_sampled,
  hash.size = 2^4,
  signed.hash=FALSE,
  create.mapping=TRUE
)

hash_mapping = hash.mapping(hashes)
names(hash_mapping) = str_remove(names(hash_mapping), 'where_town')

# Takes hash mapping, converts to dataframe, set new columns names, calculate hash over name to have original integer value, filter for selected cities 
binary_calcs = hash_mapping %>% enframe() %>% set_names(c('town', 'column_num_16')) %>% mutate(integer_16 = hashed.value(names(hash_mapping))) %>% dplyr::filter(town %in% towns_to_sample) %>% arrange(town)

hashes_df = hashes %>% 
  as.matrix() %>%
  as_tibble() %>%
  bind_cols(locations_sampled) %>%
  dplyr::rename(town = where_town) %>% 
  dplyr::filter(town %in% towns_to_sample) %>% 
  arrange(town)


# Making a signed hasing version in order to prevent aliasing

hashes_signed <- hashed.model.matrix(
  ~ where_town,
  data = locations_sampled,
  hash.size = 2^4,
  signed.hash=TRUE,
  create.mapping=TRUE
)
hashes_df_signed = hashes_signed %>% 
  as.matrix() %>%
  as_tibble() %>%
  bind_cols(locations_sampled) %>%
  dplyr::rename(town = where_town) %>% 
  dplyr::filter(town %in% towns_to_sample) %>% 
  arrange(town)
```

<details style="margin-bottom:10px;">
<summary>
Standard output and standard error
</summary>

``` sh
✖ Install the styler package in order to use `style = TRUE`.
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
#;-)  [1] fastDummies_1.6.3      stringr_1.5.0          FeatureHashing_0.9.1.5 yardstick_1.1.0        workflowsets_1.0.0     workflows_1.1.3       
#;-)  [7] tune_1.1.0             tidyr_1.3.0            tibble_3.2.1           rsample_1.1.1          recipes_1.0.5          purrr_1.0.1           
#;-) [13] parsnip_1.0.4          modeldata_1.1.0        infer_1.0.4            ggplot2_3.4.2          dplyr_1.1.1            dials_1.2.0           
#;-) [19] scales_1.2.1           broom_1.0.4            tidymodels_1.0.0      
#;-) 
#;-) loaded via a namespace (and not attached):
#;-)  [1] splines_4.2.2       foreach_1.5.2       prodlim_2023.03.31  GPfit_1.0-8         yaml_2.3.7          globals_0.16.2      ipred_0.9-14       
#;-)  [8] pillar_1.9.0        backports_1.4.1     lattice_0.20-45     glue_1.6.2          digest_0.6.31       hardhat_1.3.0       colorspace_2.1-0   
#;-) [15] htmltools_0.5.5     Matrix_1.5-1        timeDate_4022.108   pkgconfig_2.0.3     lhs_1.1.6           DiceDesign_1.9      listenv_0.9.0      
#;-) [22] gower_1.0.1         lava_1.7.2.1        timechange_0.2.0    generics_0.1.3      withr_2.5.0         furrr_0.3.1         nnet_7.3-18        
#;-) [29] cli_3.6.1           survival_3.4-0      magrittr_2.0.3      evaluate_0.20       fs_1.6.1            future_1.32.0       fansi_1.0.4        
#;-) [36] parallelly_1.35.0   MASS_7.3-58.1       class_7.3-20        tools_4.2.2         data.table_1.14.8   lifecycle_1.0.3     munsell_0.5.0      
#;-) [43] reprex_2.0.2        compiler_4.2.2      rlang_1.1.0         grid_4.2.2          iterators_1.0.14    rstudioapi_0.14     rmarkdown_2.21     
#;-) [50] gtable_0.3.3        codetools_0.2-18    R6_2.5.1            lubridate_1.9.2     knitr_1.42          fastmap_1.1.1       future.apply_1.10.0
#;-) [57] utf8_1.2.3          stringi_1.7.12      parallel_4.2.2      Rcpp_1.0.10         vctrs_0.6.1         rpart_4.1.19        tidyselect_1.2.0   
#;-) [64] xfun_0.38
```

</details>
