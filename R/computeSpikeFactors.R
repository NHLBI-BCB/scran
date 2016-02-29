setGeneric("computeSpikeFactors", function(x, ...) { standardGeneric("computeSpikeFactors") })

setMethod("computeSpikeFactors", "SCESet", function(x) 
# Uses the total of spike-in transcripts as the size factor.
#
# written by Aaron Lun
# created 17 February 2016
# last modified 29 February 2016
{
    out <- colSums(spikes(x))
    if (any(out < 1e-8)) { 
        warning("zero spike-in counts during spike-in normalization")
    } 
    out <- log(out)
    sizeFactors(x) <- exp(out - mean(out, na.rm=TRUE))
    x
})

setGeneric("spikes", function(x, ...) standardGeneric("spikes"))

setMethod("spikes", "SCESet", function(x, type=c("counts", "exprs")) {
    type <- match.arg(type)
    cur.assay <- assayDataElement(x, type)[is.spike(x),,drop=FALSE]
    return(cur.assay)
})

setGeneric("isSpike", function(x) standardGeneric("isSpike"))

is.spike <- function(x) { 
    keep <- fData(x)$is_feature_spike 
    if (is.null(keep)) { stop("set 'isSpike(x)' to identify spike-in rows") }
    return(keep)
}
setMethod("isSpike", "SCESet", is.spike)

setGeneric("isSpike<-", function(x, value) standardGeneric("isSpike<-"))
setReplaceMethod("isSpike", "SCESet", function(x, value) {
    fData(x)$is_feature_spike <- value
    return(x) 
})
