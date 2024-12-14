install.packages(c("httr", "jsonlite", "janitor","tidyverse"))
library (tidyverse)
library (janitor)
library(httr)
library(jsonlite)

#### Função para capturar hiperlinks ####

get_links <- function(page_name) {
  # URL base da API
  base_url <- "https://en.wikipedia.org/w/api.php"
  
  # Parâmetros da consulta
  params <- list(
    action = "query",
    prop = "links",
    titles = page_name,
    format = "json",
    pllimit = "max" 
  )
  
  # Requisição para a API
  response <- GET(url = base_url, query = params)
  
  # Processar a resposta
  content <- content(response, as = "parsed", type = "application/json")
  
  # Obter ID da página
  page_id <- names(content$query$pages)
  
  # Obter links da página
  links <- content$query$pages[[page_id]]$links
  
  # Retornar os links como um tibble
  if (!is.null(links)) {
    tibble(
      page = page_name,
      linked_pages = map_chr(links, ~ .x$title)
    )
  } else {
    tibble(
      page = page_name,
      linked_pages = character(0)
    )
  }
}

#### Input do usuário ####
page_entry <- readline(prompt = "Type a word: ")
page_exit <- readline(prompt = "Type one more word: ")

#### Conexão ####

#Aplicar a função
links_A <- get_links(page_entry)
links_B <- get_links(page_exit)

#Conexões sem páginas intermediárias

if (page_exit %in% links_A$linked_pages) {
  cat("Direct connection found!\n")
  cat(page_exit, "is an internal link in", page_entry, "'s Wikipedia page.\n")
} else {
  cat("No direct connection found.\n")
}
#Conexões
