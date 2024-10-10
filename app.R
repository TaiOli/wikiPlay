library(shiny)
library(httr)
library(jsonlite)

get_wiki_artigo <- function(titulo) {
  return(paste0("https://pt.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&explaintext&titles=", URLencode(titulo)))
}
