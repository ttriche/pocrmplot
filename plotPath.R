## plot our original dose escalation regime:
plotPath <- function(path, schedules, start=1, end=6, name=NULL) {
  if (is.null(name)) name <- as.character(match.call()["path"])
  viz <- paste("  subgraph", name, "{\n")
  .plotDoses <- function(steps) { # {{{
    viz <- ""
    for (st in steps) {
      if (any(is.na(st))) next
      viz <- paste(viz,
                   paste0("    ", names(schedules)[st[1]],"->",
                          names(schedules)[st[2]], ";\n"), sep="\n")
    }
    return(viz)
  } # }}}
  
  for (i in start:end) {
    viz <- paste(viz, sep="\n", 
                 paste0("    ", names(schedules)[i],
                        "[ label=\"",schedules[i],"\"];\n"))
  }
  steps <- lapply(seq_along(path), function(x) path[c(x, x + 1)])
  viz <- paste(viz, .plotDoses(steps), sep="\n")
  viz <- paste(viz, " }\n")

  grViz(viz) ## will save each because I'm a cave man and can't knit
  invisible(viz) 
}

