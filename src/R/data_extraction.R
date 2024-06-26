library(purrr)
library(readxl)
library(dplyr)
library(tidyverse)
library(jsonlite)
library(uuid)
library(data.table)
library(xml2)


df <- read_excel("../../../../antibiotics/WHO-MHP-HPS-EML-2023.04-eng.xlsx", sheet = 4, skip = 3)
df <- df |> rename(ATC_code = 'ATC code', EML = 'Listed on EML/EMLc 2023')
df <- df |> select(Antibiotic, Class, Category, ATC_code, EML)


patterns_to_replace <- c("generation" = "gen", "First" = "1st", "Second" = "2nd", "Third" = "3rd", "Fourth" = "4th", "Fifth" = "5th", "combinations" = "combos", "Beta-lactam/beta-lactamase-inhibitor_anti-pseudomonal" = "Beta-lactam/beta-lactamase-inhibitor" )

df$Class <- str_replace_all(df$Class, patterns_to_replace)

beta_lactam_classes <- c("Penicillins", "Beta-lactam/beta-lactamase-inhibitor", 
                         "Monobactams", "Carbapenems", 
                         "1st-gen-cephalosporins", "2nd-gen-cephalosporins", 
                         "3rd-gen-cephalosporins", "4th-gen-cephalosporins", 
                         "Other-cephalosporins", "5th-gen cephalosporins", 
                         "Penems", "Beta-lactamase-inhibitors")

df <- df %>%
  mutate(Category_Beta_Lactam = ifelse(Class %in% beta_lactam_classes, "Beta-Lactams", "Other"),
         value = ifelse(!duplicated(Class) & !duplicated(Class, fromLast = TRUE), 2, 1))
df


# Read the XML file
xml_data <- read_xml("../../../../antibiotics/full_database.xml")
ns <- xml_ns(xml_data)
atc_code_vector <- df$ATC_code

xpath_query <- paste0(".//d1:atc-codes/d1:atc-code[@code='", paste(atc_code_vector, collapse="' or @code='"), "']")

atc_codes <- xml_find_all(xml_data, xpath_query, ns)


drug_info_dt <- data.table(ATC_code = character(), description = character(), generic_description = character())

# Iterate over the filtered ATC codes
for (atc_code in atc_codes) {
    drug <- xml_find_first(atc_code, "ancestor::d1:drug")

    description <- xml_find_first(drug, ".//d1:description", ns) %>% xml_text()

      generic_description = xml_find_first(atc_code, ".//d1:level", ns) %>% xml_text()

    drug_info_dt <- rbindlist(list(drug_info_dt, data.table(ATC_code = xml_attr(atc_code, "code"), description, generic_description)), fill = TRUE)

}

unique_drug_info_dt <- drug_info_dt[, .SD[.N == 1], by = ATC_code]

unique_drug_info_dt$description <- if_else(unique_drug_info_dt$description == "", unique_drug_info_dt$generic_description, unique_drug_info_dt$description)

unique_drug_info_dt <- unique_drug_info_dt |> select(-generic_description)

unique_drug_info_dt$description <- gsub("\\[[A-Z0-9]+(,\\s*[A-Z0-9]+)*\\]", "", unique_drug_info_dt$description)

unique_drug_info_dt$description <- gsub("<i>|</i>|\\[|\\]|\\_", "", unique_drug_info_dt$description)

merged_df <- left_join(df, unique_drug_info_dt, by = "ATC_code")

print <- merged_df |> filter(is.na(merged_df$description))

extra_description = read_excel("../../../../antibiotics/extra_descriptions.xlsx")

extra_description <- extra_description |> select(Antibiotic, description)

merged_df_all <- left_join(merged_df, extra_description, by = "Antibiotic")

merged_df_all$description <- if_else(is.na(merged_df_all$description.x), merged_df_all$description.y, merged_df_all$description.x)

merged_df_all <- merged_df_all |> select(-description.y, description.x)

# Group by Category_Beta_Lactam and nest
nested <- merged_df_all %>%
  group_by(Category_Beta_Lactam) %>%
  nest(.key = "children")

# Check the structure of 'nested'
print(str(nested))

# Define a function for further nesting
nest_more <- function(df) {
  df %>%
    group_by(Class) %>%
    nest() %>%
    mutate(children = map(data, ~ group_by(.x, Category) %>% nest(.key = "children")))
}

# Apply the function to each nested data frame
nested <- nested %>%
  mutate(children = map(children, nest_more))

json <- toJSON(nested)

updated_json_string <- gsub("\"Antibiotic\"", "\"name\"", json)

updated_json_string <- gsub("\"Class\"", "\"name\"", updated_json_string)

updated_json_string <- gsub("\"Category\"", "\"name\"", updated_json_string)

updated_json_string <- gsub("\"Category_Beta_Lactam\"", "\"name\"", updated_json_string)


existing_data <- fromJSON(updated_json_string)

new_parent <- new_parent <- list(name = "Antibiotics", children = existing_data)

new_json <- toJSON(new_parent, auto_unbox = TRUE)
