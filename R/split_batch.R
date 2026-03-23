#' split_batch
#'
#' @param data Data
#' @param batch_size Size of batches
#'
#' @returns batches
#' @export
#'
split_batch <- function(data, batch_size) {
  batches <- split(data, ceiling(seq_along(data) / batch_size))

  return(batches)
}
