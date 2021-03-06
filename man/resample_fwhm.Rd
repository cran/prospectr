% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{resample_fwhm}
\alias{resample_fwhm}
\title{Resample to given band position and fwhm}
\usage{
resample_fwhm(X, wav, new_wav, fwhm)
}
\arguments{
\item{X}{matrix to resample}

\item{wav}{a numeric \code{vector} giving the original band positions}

\item{new_wav}{a numeric \code{vector} giving the new band positions}

\item{fwhm}{numeric \code{vector} giving the full width half maximums of the new band positions.}
}
\description{
Resample, written in C++
}
\keyword{internal}
