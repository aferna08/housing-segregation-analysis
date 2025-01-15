pacman::p_load(ggiraph, tidyverse, patchwork, here)

cbsa_wide <- read_csv(here("data", "cbsa_wide.csv"))

cbsa_shp <- tigris::core_based_statistical_areas(year = 2013, cb = TRUE, progress_bar = FALSE) %>% 
  tigris::shift_geometry() %>% 
  janitor::clean_names() %>% 
  mutate(cbsa_code = as.integer(cbsafp)) %>% 
  inner_join(cbsa_wide, by = "cbsa_code")

states_shp <- tigris::states(cb = TRUE, progress_bar = FALSE) %>% 
  janitor::clean_names() %>% 
  filter(as.integer(statefp) < 60 & !stusps %in% c("AK", "HI")) %>% 
  sf::st_transform(sf::st_crs(cbsa_shp))

map_interactive <- ggplot(data = cbsa_shp) + 
  geom_sf(data = states_shp, fill = "white") +
  geom_sf_interactive(
    aes(
      fill = h_change * 100,
      data_id = cbsa_code,
      tooltip = paste0(
        "<strong>", cbsa_title, "</strong><br>",
        "Units per 1,000 People: ", round(units_pcap * 1000, 2), "<br>",
        "Segregation Change: ", round(h_change * 100, 1)
        )
      )) +
  theme_void(base_size = 10) + 
  scale_fill_viridis_c() + 
  labs(
    fill = ""
  ) + 
  theme(
    legend.position = "bottom"
  )

scatter_interactive <- 
  ggplot(data = cbsa_wide, 
         aes(
           x = 100 * h_change, y = 1000 * units_pcap,
           data_id = cbsa_code,
           tooltip = paste0(
             "<strong>", cbsa_title, "</strong><br>",
             "Units per 1,000 People: ", round(units_pcap * 1000, 2), "<br>",
             "Segregation Change: ", round(h_change * 100, 1)
           )
         )) + 
  geom_point_interactive(color = "#33638DFF") + 
  theme_minimal() + 
  labs(
    x = "Segregation Change",
    y = "Units per 1,000 People"
  )

map_options <- list(
  opts_tooltip(opacity = .9,
               delay_mouseout = 850,
               delay_mouseover = 650,
               css = "background-color: #99cadb; color: black;
                      padding: 5px; border-radius: 5px; border-style: solid;
                      border-color: black; border-width: 1.5px;
                      font-size: 18px; font-family: Arial"),
  opts_hover(),
  opts_hover_inv(css = "opacity: .25;")
)

girafe(
  ggobj = map_interactive + scatter_interactive,
  options = map_options,
  opts_sizing(rescale = TRUE)
)
