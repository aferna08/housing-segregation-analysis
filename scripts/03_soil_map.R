pacman::p_load(tidyverse, terra, tidyterra, patchwork, here)

clay <- rast(here("data", "clay.tif")) # % by volume 0-25cm
mean_ksat <- rast(here("data", "mean_ksat.tif")) # micrometers / second, high means drains well

gg_clay <- ggplot() + 
  geom_spatraster(data = clay) + 
  scale_fill_viridis_c(
    name = "",
    na.value = "white",
    limits = c(10, 80),
    oob = scales::squish,
    labels = scales::percent_format(scale = 1)
  ) + 
  theme_void() + 
  labs(
    title = "Clay"
  )

gg_ksat <- ggplot() + 
  geom_spatraster(data = mean_ksat) + 
  scale_fill_viridis_c(
    name = "µm/s",
    na.value = "white",
    limits = c(0.01, 100),
    oob = scales::squish
  ) + 
  theme_void() + 
  labs(
    title = "Hydraulic Conductivity"
  )

combined_soil_map <- gg_clay + gg_ksat

ggsave(
  here("output", "combined_soil_map.png"),
  plot = combined_soil_map,
  width = 10,
  height = 4,
  dpi = 300
)
