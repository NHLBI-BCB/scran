\name{Quick clustering}
\alias{quickCluster}
\alias{quickCluster,matrix-method}
\alias{quickCluster,SCESet-method}

\title{Quick clustering of cells}
\description{Cluster similar cells based on rank correlations in their gene expression profiles.}

\usage{
\S4method{quickCluster}{matrix}(x, min.size=200, subset.row=NULL, ...)
\S4method{quickCluster}{SCESet}(x, subset.row=NULL, ..., assay="counts", get.spikes=FALSE)
}

\arguments{
\item{x}{
    A numeric count matrix where rows are genes and columns are cells.
    Alternatively, a SCESet object containing such a matrix.
}
\item{min.size}{An integer scalar specifying the minimum size of each cluster.}
\item{subset.row}{A logical, integer or character scalar indicating the rows of \code{x} to use.}
\item{...}{
    For \code{quickCluster,matrix-method}, additional arguments to be passed to \code{\link{cutreeDynamic}}.
    For \code{quickCluster,SCESet-method}, additional arguments to pass to \code{quickCluster,matrix-method}.
}
\item{assay}{A string specifying which assay values to use, e.g., \code{counts} or \code{exprs}.}
\item{get.spikes}{A logical specifying whether spike-in transcripts should be used.}
}

\details{
This function provides a correlation-based approach to quickly define clusters of a minimum size \code{min.size}.
A distance matrix is constructed using Spearman's correlation on the counts between cells.
(Some manipulation is performed to convert the correlation into a proper distance metric.)
Hierarchical clustering is performed and a dynamic tree cut is used to define clusters of cells.
A correlation-based approach is preferred here as it is invariant to scaling normalization.
This avoids circularity between normalization and clustering.

Note that some cells may not be assigned to any cluster.
In most cases, this is because those cells belong in a separate cluster with fewer than \code{min.size} cells.
The function will not be able to call this as a cluster as the minimum threshold on the number of cells has not been passed.
Users are advised to check that the unassigned cells do indeed form their own cluster.
If so, it is generally safe to ignore this warning and to treat all unassigned cells as a single cluster.
Otherwise, it may be necessary to use a custom clustering algorithm.

In \code{quickCluster,SCESet-method}, spike-in transcripts are not used by default as they provide little information on the biological similarities between cells.
This may not be the case if subpopulations differ by total RNA content, in which case setting \code{get.spikes=TRUE} may provide more discriminative power.
Users can also set \code{subset.row} to specify which rows of \code{x} are to be used to calculate correlations.
This is equivalent to but more efficient than subsetting \code{x} directly, as it avoids constructing a (potentially large) temporary matrix.
Note that if \code{subset.row} is specified, it will overwrite any setting of \code{get.spikes}.

}

\value{
A vector of cluster identities for each cell in \code{counts}. 
Values of \code{"0"} are used to indicate cells that are not assigned to any cluster.
}

\author{
Aaron Lun and Karsten Bach
}

\seealso{
\code{\link{cutreeDynamic}},
\code{\link{computeSumFactors}}
}

\examples{
set.seed(100)
popsize <- 200
ngenes <- 10000
all.facs <- 2^rnorm(popsize, sd=0.5)
counts <- matrix(rnbinom(ngenes*popsize, mu=all.facs, size=1), ncol=popsize, byrow=TRUE)
clusters <- quickCluster(counts, min.size=20)
}

\keyword{normalization}

\references{
van Dongen S and Enright AJ (2012).
Metric distances derived from cosine similarity and Pearson and Spearman correlations.
\emph{arXiv} 1208.3145

Lun ATL, Bach K and Marioni JC (2016).
Pooling across cells to normalize single-cell RNA sequencing data with many zero counts.
\emph{Genome Biol.} 17:75
}
