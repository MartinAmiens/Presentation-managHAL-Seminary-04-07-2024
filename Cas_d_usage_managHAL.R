#### ---------------------------------------------------------------------------
## __ libraries __ ##

library(managHAL)

## __ global variables __ ##

date_min = "01/01/2010"
date_max = "01/01/2020"

#### ---------------------------------------------------------------------------
## __ Function Load_team_table __ ##

cleaned_table_url <- load_team_table(filter_id = TRUE,
                                     date_cols = c(7, 8),
                                     "https://seafile.agroparistech.fr/f/cb25bc4e071d43ffb5fb/?dl=1")

cleaned_table_local <- load_team_table(filter_id = FALSE,
                                       date_cols = c(6, 7),
                                       "C:/Users/marti/OneDrive/Bureau/Stage/ExampleData.csv")

#### ---------------------------------------------------------------------------
## __ Data formating __ ##

cleaned_table_url <- cleaned_table_url %>% 
  dplyr::mutate(debut_periode = managHAL:::borne_date(debut_contrat,
                                                      date_min,
                                                      "max"),
                fin_periode = managHAL:::borne_date(fin_contrat,
                                                    date_max,
                                                    "min"))

#### ---------------------------------------------------------------------------
## __ Function HAL_query __ ##

url_HAL <-  HAL_query(id = cleaned_table_url$idhal,
                      date_min = cleaned_table_url$debut_periode,
                      date_max = cleaned_table_url$fin_periode,
                      type_id = "person_id",
                      format = "bibtex")$urls
url_HAL


## __ Function HAL_query __ ##

url_HAL_all <-  HAL_query(id = cleaned_table_url$idhal,
                          date_min = 2010,
                          date_max = cleaned_table_url$fin_periode,
                          add_filters = list(
                            structAcronym_s = "MIA Paris-Saclay"
                          ),
                          type_id = "person_id",
                          grouped = TRUE)$urls
url_HAL_all

#### ---------------------------------------------------------------------------
## __ Function Production_table (in development) __ ##

mia_csv_prod <- production_table(dates_min = date_min,
                                 dates_max = date_max,
                                 table = cleaned_table_url,
                                 type_id = "person_id")


#### ---------------------------------------------------------------------------
## __ Function HAL_extract_csv __ ##

# Identifiant de la structure MIA - PS
# 135757 : ancien identifiant
# 1002311 : nouveau identifiant

publication_id_struc_mia = HAL_extract_csv(id = 135757,
                                       date_min,
                                       date_max,
                                       type_id = "struct_id",
                                       add_output = c("structAcronym_s","structId_i", "structHasAlphaAuthIdHalPersonid_fs"))

#### ---------------------------------------------------------------------------
## __ Function HAL_build_report __ ##

res <- HAL_build_report(table = cleaned_table_url[2,],
                        date_min = date_min,
                        date_max = date_max
)

#### ---------------------------------------------------------------------------
## __ Functions find_inconsistent_names_and_ids (in development) __ ##
# (Examples not to be executed)

inconsistent_ids <- find_inconsistent_ids(data_test_info_author_id_struc)
if (length (inconsistent_ids$Person_ID > 1)){
  message(paste0("Il y a ", length(inconsistent_ids$Person_ID), " auteurs ayant leurs identifiant(s) HAL mal associé(s) à leurs noms :"))
  print(inconsistent_ids$Person_ID)
}
# print inconsistent ids and names
inconsistent_names_ids <- find_inconsistent_names_ids(data_test_info_author_id_struc)
if ( length (inconsistent_names_ids$Full_Name > 1)){
  message(paste0("Il y a ", length(inconsistent_names_ids$Full_Name), " Auteur ayant plusieurs formes auteurs ayant leurs identifiant(s) HAL mal associé(s) :"))
  print(inconsistent_names_ids$Full_Name)
}

#### ---------------------------------------------------------------------------
## __ Building a network (in development) __ ##

# See Results from script...

## __ Analysing a network (in development) __ ##

# See Results from script...

