library(pocrm)
library(DiagrammeR)

## for POCRM 
doses <- list(crizotinib=paste0("2x", c(25, 37.5, 50), "mg Xalkori"),
              sunitinib=paste0(c(200, 250), "mg Sutent"))

## this is essentially a WAG, which is WHY POCRM makes sense (updating)
doseTox <- list(crizotinib=c(0.1, 0.2, 0.3), 
                  sunitinib=c(0.1, 0.3))
schedules <- apply(expand.grid(doses), 1, function(x) paste(x, collapse=" + "))
names(schedules) <- paste0("dose", 1:6)

## exhaustive, for plotting graphs 
paths <- list(arm1=c(1,2,4,6),
              arm2=c(1,3,5,6),
              arm3=c(1,2,5,6),
              arm4=c(1,3,4,6))
orders <- do.call(rbind, paths)

## model expected toxicity as 1 - ((1-toxForDrug1)*(1-toxForDrug2))
toxGuess <- apply(expand.grid(doseTox), 1, 
                  function(x) 1 - (1 - x[1]) * (1 - x[2]))
names(toxGuess) <- names(schedules)

## initial working model 
alpha <- do.call(rbind, lapply(paths, function(x) toxGuess[x]))
colnames(alpha) <- paste0("toxAtDose", 1:4)
## note that the partial ordering here is different than we thought, in `paths`!

## get priors
prior.o <- rep(1, length(paths)) / length(paths)

## get skeleton of updates to model
#pocrm.imp(wm, ...) after each patient completes a cycle / is accrued 
#
# so instead of fixed random escalation/assignment, rely on PO-CRM to guide dose
# why? because our original idea wasn't so great, if my model is reasonable:
#
image(x=1:4, y=1:4, z=t(alpha), 
      main="Our initial proposed 3+3 ordering, plotted as E[toxicity]", 
      xlab="Dose", ylab="Arm", 
      col=c("darkgreen","green","yellow","orange","red"))

## which levels are equivalent (allegedly)?
equiv <- list(L2=c(2,3), L3=c(4,5))

source("plotPath.R")
mermaid(plotPath(paths$arm1, equiv, schedules))
mermaid(plotPath(paths$arm2, equiv, schedules))
mermaid(plotPath(paths$arm3, equiv, schedules))
mermaid(plotPath(paths$arm4, equiv, schedules))
mermaid(plotPath(1:6, equiv, schedules))

