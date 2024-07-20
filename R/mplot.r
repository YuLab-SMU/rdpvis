#' visualize a matrix
#' 
#' 
#' @title mplot
#' @param matrix input matrix 
#' @return A ggplot object
#' @importFrom ggplot2 geom_raster
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 scale_fill_viridis_c
#' @importFrom ggplot2 scale_y_reverse
#' @importFrom ggplot2 scale_x_continuous
#' @importFrom ggplot2 labs
#' @importFrom grid unit
#' @importFrom yulab.utils mat2df
#' @author Guangchuang Yu 
#' @export
mplot <- function(matrix) {
    d <- mat2df(as.matrix(matrix))
    ggplot(d, aes(.data$row, .data$col)) + 
        geom_raster(aes(fill=.data$value)) + 
        # ggfun::theme_nothing() +
        theme(legend.key.height = unit(1, "cm"),
            legend.justification.top = "right",
            legend.title = element_blank()) +
        scale_fill_viridis_c() +
        scale_y_reverse(expand = c(0,0)) +
        scale_x_continuous(expand=c(0,0)) +
        labs(x=NULL, y=NULL)
}

