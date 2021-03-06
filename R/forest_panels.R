#' Generate panels for forest plots
#'
#' @param ... panels to variables in data
#' @param margin margin to leave at left and right edges
#'
#' @return a panels list ready for \code{\link{forest_model}} or \code{\link{forest_rma}}
#' @export
forest_panels <- function(..., margin = 0.03) {
  mapping <- list(...)
  panels <- lapply(seq(mapping), function(i) {
    panel <- list()
    item_char <- paste(deparse(mapping[[i]]), collapse = " ")
    if (grepl("~ *forest", item_char)) {
      panel$item <- "forest"
      line_mat <-
        regmatches(item_char, regexec("line_x *= *([0-9.]+)", item_char))[[1]]
      if (length(line_mat)) {
        panel$line_x <- as.numeric(line_mat[2])
        panel$linetype <- "dashed"
        panel$width <- 0.5
      }
    } else if (grepl("~ *vline", item_char)) {
      panel$item <- "vline"
      panel$hjust <- 0.5
      panel$width <- 0.03
    } else if (grepl("~ *spacer", item_char)) {
      space_mat <-
        regmatches(item_char, regexec("space *= *([0-9.]+)", item_char))[[1]]
      if (length(space_mat)) {
        panel$width <- as.numeric(space_mat[[2]])
      } else {
        panel$width <- margin
      }
    } else {
      panel$display <- mapping[[i]]
      panel$display_na <- ""
    }
    panel$heading <- names(mapping)[i]
    panel
  })
  c(list(list(width = margin)), panels, list(list(width = margin)))
}
