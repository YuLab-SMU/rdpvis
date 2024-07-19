#' Parse break point output from RDP5
#' 
#' This function read the exported csv files from RDP5 breakpoint plot
#' @title read_rdp_breakpoint
#' @rdname read-rdp-breakpoint
#' @param file break point file 
#' @return A 'RDP_breakPoint' object
#' @importFrom readr read_csv
#' @author Guangchuang Yu 
#' @export
read_rdp_breakpoint <- function(file) {
    orffile <- sprintf("%s%s", file, "ORFCoords.csv")
    posfile <- sprintf("%s%s", file, "BreakpointPositions.csv")

    res <- list()
    res$bp <- read_csv(file)
    files <- list(bpfile = file)
    if (file.exists(orffile)) {
        res$orf <- read_csv(orffile)
        files$orffile <- orffile
    }

    if (file.exists(posfile)) {
        res$pos <- read_csv(posfile)
        files$posfile <- posfile
    }

    res$files <- files
    structure(res, class = "RDP_breakPoint")
}

##' @method print RDP_breakPoint
##' @export
print.RDP_breakPoint <- function(x, ...) {
    msg <- "Recombination breakpoint data exported by RDP5"
    cat(msg, "\n")
}


##' @importFrom ggplot2 autoplot
##' @export
ggplot2::autoplot

##' @importFrom ggplot2 ggsave
##' @export
ggplot2::ggsave


##' @importFrom ggplot2 ggplot
##' @importFrom ggplot2 aes
##' @importFrom ggplot2 geom_ribbon
##' @importFrom ggplot2 geom_line
##' @importFrom ggplot2 theme_minimal
##' @importFrom ggplot2 geom_rug
##' @importFrom ggplot2 ylim
##' @importFrom ggplot2 coord_cartesian
##' @importFrom ggplot2 layer_data
##' @importFrom aplot plot_list
##' @importFrom plasmapR plot_plasmid
##' @importFrom ggsci scale_fill_simpsons
##' @importFrom rlang .data
##' @method autoplot RDP_breakPoint
##' @export
autoplot.RDP_breakPoint <- function(object, CI='99%', ...) {
    lower <- sprintf("Lower %s CI", CI)
    upper <- sprintf("Upper %s CI", CI)

    gbp <- ggplot(object$bp, aes(x = .data[["Position in alignment"]], 
                        y = .data[["Recombination breakpoint number (200nt win)"]])
            ) + 
        geom_ribbon(aes(ymin = .data[[lower]], 
                    ymax=.data[[upper]]), 
                fill = "#C2DBD5", alpha=.8) + 
        geom_line(color='white', size=1.3, alpha = .8) + 
        geom_line() +
        theme_minimal()
    
    if (!is.null(object$pos)) {
        gbp <- gbp + 
            geom_rug(aes(.data[["Breakpoint position"]]), 
                    data=object$pos, 
                    inherit.aes=FALSE)
    }

    res <- gbp

    if (!is.null(object$orf)) {
        orf <- object$orf
        names(orf) <- c("start", "end", "name")
        orf$index <- 1:nrow(orf)
        orf$type <- sub("\\d+$", "", sub("\\s.*", "", orf$name))
        orf$direction=1
        gorf <- plot_plasmid(orf, name = "")  + 
                    coord_cartesian() +
                    scale_fill_simpsons()
        r <-range(layer_data(gorf, 3)$y)
        gorf <- gorf + ylim(r[1], r[2] * 1.2)
        
        res <- plot_list(gorf, gbp, 
                    ncol = 1, heights = c(.3,1),
                    output = 'gglist')
    }

    return(res)
}

