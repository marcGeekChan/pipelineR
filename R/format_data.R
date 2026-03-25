#'
#' format_data
#'
#' @param data Data
#' @import dplyr
#' @import tidyr
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
