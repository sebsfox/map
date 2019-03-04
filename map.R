library(ggplot2)
library(dplyr)
library(gapminder)

WorldData <- map_data('world')
WorldData %>% filter(region != "Antarctica") -> WorldData

class(WorldData)
head(WorldData)
# plot(WorldData)
ggplot(WorldData, aes(x=long, y=lat, group = group)) + 
        geom_polygon(colour = "white", fill = "black") +
        coord_sf(datum = NA) +
        theme_void()# +
        # labs(title = "Title", x="", y="") +
        # scale_y_continuous(breaks=c()) + 
        # scale_x_continuous(breaks=c()) + 
        # theme(panel.border =  element_blank())


library(wbstats)
vars <- wbsearch(pattern = "carbon")
View(vars)
pop_data <- wb(indicator = "EN.ATM.CO2E.PP.GD.KD") %>%
        group_by(country) %>%
        filter(date == max(date))

# wd <- WorldData %>%
#         left_join(pop_data,
#                    by = c("region" = "country"))
# ggplot(wd, aes(x=long, y=lat, group = group)) + 
#         geom_polygon(colour = "white", aes(fill = value)) +
#         scale_fill_viridis_c(option = "plasma") +
#         coord_sf(datum = NA) +
#         theme_void()
# 
# test <- wbcountries()

library(rgdal)
countries <- readOGR(dsn=".", layer="world-data", stringsAsFactors=F)


# Reproject the polygons to an cartographically-valid Robinson projection

robinson <- CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
countries <- spTransform(countries, robinson) %>%
        sf::st_as_sf()
# plot(countries)
# head(countries@data)
# head(pop_data)
# setdiff(countries@data$WB2016,pop_data$country)
wd <- countries %>%
        left_join(pop_data,
                  by = c("WB2016" = "country"))
ggplot(wd) +
        geom_sf(colour = "white", aes(fill = value)) +
        # ggplot(wd, aes(x=long, y=lat, group = group)) + 
        # geom_polygon(colour = "white", aes(fill = value)) +
        scale_fill_viridis_c(option = "viridis") +
        coord_sf(datum = NA) +
        theme_void()
