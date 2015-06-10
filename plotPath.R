

## plot our original dose escalation regime:
plotPath <- function(path, equiv, schedules, start=1, end=6) {
  viz <- "graph LR \n"
  .plotEquiv <- function(name, eq, path) { # {{{
    j <- eq[1]
    k <- eq[2]
    paste(#paste("  subgraph", name),
          paste0("    ", names(schedules)[j],"-.-",names(schedules)[k]),
          # "  end",
          "\n", sep="\n")
  } # }}}
  .plotDoses <- function(steps) { # {{{
    viz <- ""
    for (st in steps) {
      if (any(is.na(st))) next
      viz <- paste(viz,
                   paste0("  ", names(schedules)[st[1]],"===|escalate|",
                          names(schedules)[st[2]]), sep="\n")
    }
    return(viz)
  } # }}}
  .plotNondosed <- function(path) { # {{{
    viz <- ""
    for (i in start:end) {
      if (i == end) next
      if (!all(c(i, i + 1) %in% path)) {
        viz <- paste(viz,
                     paste0(" ", 
                            names(schedules)[i],"-.-",
                            names(schedules)[i + 1]), "\n")
      }
    }
    return(viz)
  } # }}}
  
  for (eq in names(equiv)) {
    viz <- paste(viz, .plotEquiv(eq, equiv[[eq]]), sep="\n")
  }
  
  for (i in start:end) {
    viz <- paste(viz, sep="\n", 
                 paste0("  ", names(schedules)[i],"[",schedules[i],"]"))
  }
  steps <- lapply(seq_along(path), function(x) path[c(x, x + 1)])
  viz <- paste(viz, .plotNondosed(path), sep="\n")
  viz <- paste(viz, .plotDoses(steps), sep="\n")

  mermaid(viz) ## will save each because I'm a cave man and can't knit
  invisible(viz) 
}

