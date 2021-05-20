UFO Sighting Explorer
========================================================
author: Scott Duda
date: April 02, 2019

Application 
========================================================

* This Shiny application allows the user to filter and explore over 60,000 UFO sightings reported in the U.S. between 1949 and 2013. 
* It displays a heat map across the U.S. that indicates the number of sightings occurring within each individual state given the user-selected criteria. The user may also browse through sighting descriptions. 
* The user can select a range of dates and can filter sightings included in the analysis by selecting which states and/or reported UFO shapes to include.
* You can view the application source code here:  [Github repo](https://github.com/dontmindifiduda/ufo-sighting-explorer)
* A functioning version of the application can be viewed here:  [Application](https://scottmduda.shinyapps.io/ufo-sightings/)

Application Operation
========================================================

* The application was developed using Shiny, a web application framework written for R
* The source code for the application includes two files:  server.R and ui.R
* The server.R file includes the code used to construct the app and give it functionality
* The ui.R file includes code for controlling the appearance of the application that users intearct with
* The application uses the plotly library for displaying UFO sighting data across the U.S.
* The application also filters the sightings included on the U.S. map based on user selected inputs, including the range of dates during which the sighting occurred, the sighting state, and the shape of the UFO reported


Data Source
========================================================

* This application uses data that was scraped from the National UFO Reporting Center. The dataset was downloaded from [Kaggle] (https://www.kaggle.com/NUFORC/ufo-sightings) 
* Two datasets were available (complete and scrubbed). The scrubbed dataset excludes entries where the sighting location was not found or was blank as well as sightings with erroneous or blank times. The scrubbed dataset was selected for this application
* The original dataset included over 80,000 sighting reports. Additional data processing and cleaning was performed on the dataset, including removal of all sightings that were not identified as occurring within the U.S. and removal of sightings that do not include a state label
* The processed dataset includes over 60,000 sighting reports


A Brief Look at the Data
========================================================

* The structure of the unprocessed dataset is shown below:


```r
ufo <- read.csv('scrubbed.csv')
str(ufo)
```

```
'data.frame':	80332 obs. of  11 variables:
 $ datetime            : Factor w/ 69586 levels "1/1/1910 24:00",..: 5486 5487 5488 5489 5490 5491 5492 5493 5494 5495 ...
 $ city                : Factor w/ 19900 levels "?","??","&ccedil;anakkale (turkey)",..: 15598 9174 3213 5082 8584 2128 13622 12678 13606 9923 ...
 $ state               : Factor w/ 68 levels "","ab","ak","al",..: 59 59 1 59 15 58 1 10 4 13 ...
 $ country             : Factor w/ 6 levels "","au","ca","de",..: 6 1 5 6 6 6 5 6 6 6 ...
 $ shape               : Factor w/ 30 levels "","changed","changing",..: 10 21 6 6 21 27 6 13 13 13 ...
 $ duration..seconds.  : Factor w/ 537 levels "0.001","0.01",..: 266 471 216 216 518 285 189 83 189 79 ...
 $ duration..hours.min.: Factor w/ 8349 levels " 20 minutes (ongoing)",..: 4991 1156 3257 1418 2178 5293 6525 3215 3700 8158 ...
 $ comments            : Factor w/ 79998 levels "","  Circle",..: 65595 1771 29611 45526 11826 45137 51840 7505 63052 55591 ...
 $ date.posted         : Factor w/ 317 levels "1/10/2003","1/10/2009",..: 175 80 11 8 13 176 100 35 138 185 ...
 $ latitude            : Factor w/ 18445 levels "-0.023559","-0.180653",..: 1683 1531 17812 1456 797 6010 17433 10996 3449 1865 ...
 $ longitude           : num  -97.94 -98.58 -2.92 -96.65 -157.8 ...
```





