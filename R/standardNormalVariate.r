#' @title Standard normal variate transformation
#'
#' @description
#' \code{standardNormalVariate} normalizes each row of an input \code{data.frame} or \code{matrix} by substracting
#' each row by its mean and dividing by its standard deviation
#' @usage
#' standardNormalVariate(X)
#' @param X numeric \code{data.frame} or \code{matrix} to transform
#' @author Antoine Stevens
#' @examples
#' data(NIRsoil)
#' spc <- 1/10^NIRsoil$spc # conversion to reflectance
#' snv <- standardNormalVariate(X = spc)
#' # 10 first snv spectra
#' matplot(as.numeric(colnames(snv)),t(snv[1:10,]),type='l',xlab='wavelength /nm',ylab='snv') 
#' \dontrun{
#' apply(snv,1,sd) # check 
#' }
#' @return a \code{matrix} of the transformed data
#' @details 
#' SNV is simple way for normalizing spectral data that intends to correct for light scatter. 
#' It operates row-wise:
#' \deqn{SNV_i = \frac{x_i - \bar{x_i}}{s_i}}
#' where \eqn{x_i} is the signal of a sample \eqn{i}, \eqn{\bar{x_i}} is its mean and
#' \eqn{s_i} its standard deviation
#' @seealso \code{\link{detrend}}, \code{\link{blockScale}}, \code{\link{blockNorm}}, \code{\link[pls]{msc}}
#' @references Barnes RJ, Dhanoa MS, Lister SJ. 1989. Standard normal variate transformation and de-trending of near-infrared diffuse reflectance spectra. Applied spectroscopy, 43(5): 772-777.
#' @export
#'
standardNormalVariate <- function(X) {
    if (!class(X) %in% c("matrix", "data.frame")) 
        stop("X should be a matrix or data.frame")
    X <- sweep(X, 1, rowMeans(X, na.rm = T), "-")
    X <- sweep(X, 1, apply(X, 1, sd, na.rm = T), "/")
    return(X)
}
 
