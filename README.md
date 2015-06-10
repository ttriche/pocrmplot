# pocrmplot
fussing with PO-CRM and plotting the actual dose escalation path (AACR workshop)

setup for PO-CRM with our selected dose escalation plan (probably not the optimal one):

```R 
library(pocrm)
library(DiagrammeR)

## for POCRM 
doses <- list(crizotinib=paste0("2x", c(25, 37.5, 50), "mg Xalkori"),
              sunitinib=paste0(c(200, 250), "mg Sutent"))

## this is essentially a WAG, which is WHY POCRM makes sense (updating)
doseTox <- list(crizotinib=c(0.1, 0.2, 0.3),
                sunitinib=c(0.1, 0.3))
toxGuess <- apply(expand.grid(doseTox), 1,
                  function(x) 1 - (1 - x[1]) * (1 - x[2]))
schedules <- apply(expand.grid(doses), 1, function(x) paste(x, collapse=" + "))
names(schedules) <- paste0("dose", 1:6)
names(toxGuess) <- schedules
```

Why PO-CRM?  As it turns out, when we simply go through the exercise of generating guesses for toxicity, it turns out our hypothetical partial ordering for 3+3 dose escalations by toxicity wasn't exactly correct:

```R
## initial working model 
alpha <- do.call(rbind, lapply(paths, function(x) toxGuess[x]))
colnames(alpha) <- paste0("toxAtDose", 1:4)
## note that the partial ordering here is different than we thought, in `paths`!

## get priors for pocrm assignment:
prior.o <- rep(1, length(paths)) / length(paths)

## plot the alpha matrix:
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
```
![Toxicity working model](toxPlot.png)


