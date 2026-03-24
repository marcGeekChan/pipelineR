library(dplyr)
library(tidyr)

#' format_data
#'
#' @param data Data
#'
#' @returns data_long
#' @export
#'
format_data <- function(data) {
  data_long <- data %>%
    pivot_longer(
      cols = c(open, high, low, close, adjusted, volume),
      names_to = "field",
      values_to = "value"
    )
  return(data_long)
}
