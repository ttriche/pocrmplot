library(pocrm)
library(DiagrammeR)

## for POCRM 
doses <- list(crizotinib=paste0(c(200, 250), "mg Xalkori"),
              sunitinib=paste0("2x", c(25, 37.5, 50), "mg Sutent"))

## assume toxicity is linear in dose (ridiculous, of course, but still)
## this is essentially a WAG, which is WHY POCRM makes sense (updating)
doseTox <- list(crizotinib=c(0.24, 0.3),
                sunitinib=c(0.15, 0.2, 0.3))

## model expected toxicity as 1 - ((1-toxForDrug1)*(1-toxForDrug2))
toxGuess <- apply(expand.grid(doseTox), 1,
                  function(x) 1 - (1 - x[1]) * (1 - x[2]))
schedules <- apply(expand.grid(doses), 1, function(x) paste(x, collapse=" + "))
names(schedules) <- paste0("dose", 1:6)
names(toxGuess) <- names(schedules)

## exhaustive, for plotting graphs 
paths <- list(arm1=c(1,2,4,6),
              arm2=c(1,3,5,6),
              arm3=c(1,2,5,6),
              arm4=c(1,3,4,6))

## which levels are equivalent (allegedly)?
equiv <- list(L2=c(2,3), L3=c(4,5))

plots <- with(paths, 
              list(arm1=plotPath(arm1, schedules, name="arm1"), 
                   arm2=plotPath(arm2, schedules, name="arm2"), 
                   arm3=plotPath(arm3, schedules, name="arm3"), 
                   arm4=plotPath(arm4, schedules, name="arm4")))
source("plotPath.R")
viz <- "
  digraph paths {

    # graph attributes
    graph [overlap = true]

    # node attributes
    node [shape = box, fontname = Helvetica, color = blue]

    # edge attributes
    edge [color = gray]"
viz <- paste(viz, paste(do.call(c, plots), collapse="\n"), sep="\n")
viz <- paste(viz, "  }\n")
grViz(viz)
