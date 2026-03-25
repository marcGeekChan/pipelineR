#' split_batch
#'
#' @param data Data
#' @param batch_size Size of batches
#'
#' @returns batches
#' @export
#'
split_batch <- function(data, batch_size) {
  data <- as.data.frame(data)  # force safety
  split(data, ceiling(seq_len(nrow(data)) / batch_size))
}
