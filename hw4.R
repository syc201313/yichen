
## Load packages

```{r}
library(sf)
library(here)
library(janitor)
library(dplyr)
library(stringr)
library(tidyverse)
library(tmap)
library(tmaptools)
#library(countrycode)
```

## Read in data

```{r}
World <- st_read(here("homework_4", "World_Countries_(Generalized)","World_Countries__Generalized_.shp"))

GII<- read.csv(here::here("homework_4","HDR21-22_Composite_indices_complete_time_series.csv"), 
               header = TRUE, sep = ",",  
               encoding = "latin1")
```

## Clean GII data

```{r}
GIIclean<-GII %>% 
  dplyr::select(contains("iso3"),
                contains("country"),
                contains("hdicode"),
                contains("gii_2010"), 
                contains("gii_2019"))  
```

## Join the csv to world shape file

```{r}
World2 <- World %>% 
  clean_names() %>%
  left_join(., 
            GIIclean,
            by = c("country" = "country"))%>%
  mutate(diff= gii_2010 - gii_2019)
```

## Mapping

```{r}
tmap_mode("plot")

tm_shape(World2) + 
  tm_polygons("diff", 
              style="jenks",
              title="difference in inequality 2010-2019",
              palette="YlOrBr")+
  tm_layout(frame=FALSE, main.title = "Difference in gender inequality index\nSource: United Nations Development Programme (2022)",
            title.color = "grey",
            title.position = c("left", "top"), title.bg.color = "White", 
            title.bg.alpha = (0.6), legend.position = c("left", "bottom"))
```
