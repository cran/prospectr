#' @title Multiplicative Scatter Correction (msc)
#'
#' @description
#' \loadmathjax
#' \ifelse{html}{\out{<a href='https://www.tidyverse.org/lifecycle/#maturing'><img src='figures/lifecycle-maturing.svg' alt='Maturing lifecycle'></a>}}{\strong{Maturing}}
#'
#' This function implements the multiplicative scatter correction method
#' which attempts to remove physical light scatter by accounting for additive
#' and multiplicative effects (Geladi et al., 1985).
#'
#' @usage
#' msc(X, reference_spc = colMeans(X))
#'
#' @param X a numeric matrix of spectral data.
#' @param reference_spc a numeric vector corresponding to an "ideal" reference
#' spectrum (e.g. free of scattering effects). By default the function uses the
#' mean spectrum of the input \code{X}. See details.
#'
#' @details
#' The Multiplicative Scatter Correction (MSC) is a normalization method that
#' attempts to account for additive and multiplicative effects by aligning each
#' spectrum (\mjeqn{x_i}{x_i}) with an ideal reference one (\mjeqn{x_r}{x_r}) as
#' follows:
#'
#' \mjdeqn{x_i = m_i x_r + a_i}{x_i = m_i x_r + a_i}
#' \mjdeqn{MSC(x_i) = \frac{a_i - x_i}{m_i}}{MSC(x_i) = {a_i - x_i}/{m_i}}
#'
#' where \mjeqn{a_i}{a_i} and \mjeqn{m_i}{m_i} are the additive and
#' multiplicative terms respectively.
#' @return
#' a matrix of normalized spectral data with an attribute which indicates the
#' reference spectrum used.
#' @author
#' \href{https://orcid.org/0000-0002-5369-5120}{Leonardo Ramirez-Lopez} and Guillaume Hans
#'
#' @references
#' Geladi, P., MacDougall, D., and Martens, H. 1985. Linearization and
#' Scatter-Correction for Near-Infrared Reflectance Spectra of Meat.
#' Applied Spectroscopy, 39(3):491-500.
#'
#' @seealso \code{\link{standardNormalVariate}}, \code{\link{detrend}},
#' \code{\link{blockScale}}, \code{\link{blockNorm}}
#'
#' @examples
#' data(NIRsoil)
#' NIRsoil$msc_spc <- msc(X = NIRsoil$spc)
#' # 10 first snv spectra
#' matplot(
#'   x = as.numeric(colnames(NIRsoil$msc_spc)),
#'   y = t(NIRsoil$msc_spc[1:10, ]),
#'   type = "l",
#'   xlab = "wavelength, nm",
#'   ylab = "msc"
#' )
#' 
#' @export
msc <- function(X, reference_spc = colMeans(X)) {
  X <- as.matrix(X)

  if (!is.vector(reference_spc)) {
    stop("'reference_spc' must be a vector")
  }

  if (ncol(X) != length(reference_spc)) {
    stop("The number of column in X must be equal to the length of 'reference_spc'")
  }
  offsets_slopes <- get_msc_coeff(X, reference_spc)
  Xz <- sweep(X, MARGIN = 1, STATS = offsets_slopes[1, ], FUN = "-", check.margin = FALSE)
  Xz <- sweep(Xz, MARGIN = 1, STATS = offsets_slopes[2, ], FUN = "/", check.margin = FALSE)
  attr(Xz, "Reference spectrum:") <- reference_spc
  Xz
}
