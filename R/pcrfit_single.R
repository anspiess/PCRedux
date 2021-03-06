#' @title pcrfit_single - A function to extract features from an amplification curve
#' @description The pcrfit_single is responsible for the 
#' extraction of features from amplification curve data. The function can be used
#' for custom functions for a paralleled analysis of amplification curve data. 
#' An example is given in the vignette.
#' @param x is the data set containing the fluorescence amplitudes.
#' @author Stefan Roediger, Michal Burdukiewcz
#' @references M. Febrero-Bande, M.O. de la Fuente, others, \emph{Statistical 
#' computing in functional data analysis: The R package fda.usc}, Journal of 
#' Statistical Software. 51 (2012) 1--28. http://www.jstatsoft.org/v51/i04/
#' 
#' A.-N. Spiess, C. Deutschmann, M. Burdukiewicz, R. Himmelreich, K. Klat, P. 
#' Schierack, S. Roediger, Impact of Smoothing on Parameter Estimation in 
#' Quantitative DNA Amplification Experiments, Clinical Chemistry. 61 (2015) 
#' 379--388. doi:10.1373/clinchem.2014.230656.
#' 
#' S. Roediger, A. Boehm, I. Schimke, Surface Melting Curve Analysis with R, 
#' \emph{The R Journal}. 5 (2013) 37--53. 
#' http://journal.r-project.org/archive/2013-2/roediger-bohm-schimke.pdf.
#' 
#' S. Roediger, M. Burdukiewicz, K.A. Blagodatskikh, P. Schierack, R as an 
#' Environment for the Reproducible Analysis of DNA Amplification Experiments, 
#' \emph{The R Journal}. 7 (2015) 127--150. 
#' http://journal.r-project.org/archive/2015-1/RJ-2015-1.pdf.
#' 
#' S. Pabinger, S. Roediger, A. Kriegner, K. Vierlinger, A. Weinhauusel, A 
#' survey of tools for the analysis of quantitative PCR (qPCR) data, \emph{Biomolecular 
#' Detection and Quantification}. 1 (2014) 23--33. doi:10.1016/j.bdq.2014.08.002.
#' 
#' S. Roediger, M. Burdukiewicz, P. Schierack, \emph{chipPCR: an R package to 
#' pre-process raw data of amplification curves}, \emph{Bioinformatics}. 31 (2015) 
#' 2900--2902. doi:10.1093/bioinformatics/btv205.
#'
#' @return Output Description
#' \tabular{llr}{
#'   "eff" \tab qPCR amplification efficiency \tab numeric \cr
#'   "cpD1" \tab maximum of the first derivative curve \tab numeric \cr
#'   "cpD2" \tab maximum of the second derivative curve \tab numeric \cr
#'   "fluo" \tab raw fluorescence value at the point defined by cpD2 \tab  numeric \cr
#'   "init1" \tab initial template fluorescence from the sigmoidal model \tab numeric \cr
#'   "init2" \tab initial template fluorescence from an exponential model \tab numeric \cr
#'   "top" \tab takeoff point \tab numeric \cr
#'   "f.top" \tab fluorescence at takeoff point \tab  numeric \cr
#'   "resLRE" \tab PCR efficiency by the 'linear regression of efficiency' method \tab numeric \cr
#'   "ressliwin" \tab PCR efficiency by the 'window-of-linearity' method \tab numeric \cr
#'   "cpDdiff" \tab difference between cpD1 and cpD2 \tab numeric \cr
#'   "slope_background" \tab slope of the first cycles \tab numeric \cr
#'   "intercept_background" \tab intercept of the first cycles \tab numeric \cr
#'   "polyarea" \tab area of a polygon given by the vertices in the vectors cycles and fluorescence \tab numeric \cr
#'   "changepoint.e.agglo" \tab agglomerative hierarchical estimate for multiple change points \tab numeric \cr
#'   "changepoint.bcp" \tab change point by Bayesian analysis methods \tab numeric \cr
#'   "qPCRmodel" \tab non-linear model determined for the analysis \tab factor \cr
#'   "amptester_shap.noisy" \tab tests based on the Shapiro-Wilk normality test if the amplification curve is just noise \tab binary \cr
#'   "amptester_lrt.test" \tab performs a cycle dependent linear regression and determines if the coefficients of determination deviates from a threshold \tab binary \cr
#'   "amptester_rgt.dec" \tab Resids growth test (RGt) tests if fluorescence values in a linear phase are stable \tab binary \cr
#'   "amptester_tht.dec" \tab  Threshold test (THt) takes the first 20 percent and the last 15 percent of any input data set and performs a Wilcoxon rank sum tests. \tab binary \cr
#'   "amptester_slt.dec" \tab Signal level test compares 1. the signals by a robust "sigma" rule by median + 2 * mad and 2. by comparison of the signal/noise ratio \tab binary \cr
#'   "amptester_polygon" \tab pco test (pco) determines if the points in an amplification curve (like a polygon, in particular non-convex polygons) are in a "clockwise" order. \tab binary \cr
#'   "amptester_slope.ratio" \tab SlR uses the inder function to find the approximated first derivative maximum, second derivative minimum and the second derivative maximum. These are used for a regression analysis with the corresponding fluorescence amplitude data. \tab numeric \cr
#'   "minRFU" \tab minimum of fluorescence amplitude (percentile 0.01) \tab numeric \cr
#'   "maxRFU" \tab maximum of fluorescence amplitude (percentile 0.99) \tab numeric \cr
#'   "bg.start_normalized" \tab takes the start (cycle) the amplification curve background based on the bg.max function and normalizes it to the total cycle number \tab numeric \cr
#'   "bg.stop_normalized" \tab estimates the end (cycle) the amplification curve background based on the bg.max function and normalizes it to the total cycle number \tab numeric \cr
#'   "amp.stop_normalized" \tab estimates the end (cycle) of the amplification curve based in the bg.max function and normalizes it to the total cycle number \tab numeric \cr
#'   "head_to_tail_ratio" \tab \tab numeric \cr
#'   "autocorellation" \tab  \tab numeric \cr
#'   "mblrr_intercept_less" \tab  \tab numeric \cr
#'   "mblrr_slope_less" \tab \tab numeric \cr
#'   "mblrr_cor_less" \tab \tab numeric \cr
#'   "mblrr_intercept_more" \tab \tab numeric \cr
#'   "mblrr_slope_more" \tab \tab numeric \cr
#'   "mblrr_cor_more" \tab \tab numeric \cr
#'   "hookreg_hook" \tab estimate of hook effect like curvature \tab binary \cr
#'   "mcaPeaks_minima_maxima_ratio" \tab Takes the estimate approximate local minimums and maximums \tab \cr
#'   "diffQ2_slope" \tab slope determined by a linear model of the data points from the minimum and maximum of the second derivative \tab numeric \cr
#'   "diffQ2_Cq_range" \tab cycle difference between the maximum and the minimum of the second derivative curve \tab numeric \cr
#' }
#' @details Details can be found in the vignette.
#' @importFrom qpcR pcrfit
#' @examples 
#' # Load the chipPCR package and analyze from the C126EG685 the first qPCR run
#' # "A01" (column 2).
#' library(chipPCR)
#' res <- pcrfit_single(C126EG685[, 2])
#' @seealso 
#'  \code{\link[bcp]{bcp}}
#'  \code{\link[chipPCR]{bg.max}},\code{\link[chipPCR]{amptester}},\code{\link[chipPCR]{smoother}}
#'  \code{\link[ecp]{e.agglo}}
#'  \code{\link[MBmca]{diffQ}},\code{\link[MBmca]{mcaPeaks}},\code{\link[MBmca]{diffQ2}}
#'  \code{\link{head2tailratio}},\code{\link{earlyreg}},\code{\link{hookreg}},\code{\link{hookregNL}},\code{\link{mblrr}},\code{\link{autocorrelation_test}}
#'  \code{\link[pracma]{polyarea}}
#'  \code{\link[qpcR]{pcrfit}},\code{\link[qpcR]{takeoff}},\code{\link[qpcR]{LRE}},\code{\link[qpcR]{sliwin}},\code{\link[qpcR]{efficiency}}
#'  \code{\link[base]{diff}}
#'  \code{\link[stats]{quantile}}
#'
#' @rdname pcrfit_single
#' @export pcrfit_single

pcrfit_single <- function(x) {
  
  # Normalize RFU values to the alpha percentile (0.999)
  x <- x/quantile(x, 0.999, na.rm=TRUE)
  length_cycle <- length(x)
  cycles <- 1L:length_cycle
  # Determine highest and lowest amplification curve values
  fluo_range <- stats::quantile(x, c(0.01, 0.99), na.rm=TRUE)

  # for qpcR
  dat <- cbind(cyc=cycles, fluo=x)
  # inefficient kludge to find l4 model
  data("sysdata", package = "qpcR", envir = parent.frame())
  
  res_bg.max_tmp <- chipPCR::bg.max(cycles, x)
  res_bg.max <- c(bg.start=res_bg.max_tmp@bg.start/length_cycle,
                  bg.stop=res_bg.max_tmp@bg.stop/length_cycle,
                  amp.stop=res_bg.max_tmp@amp.stop/length_cycle)

  # Determine the head to tail ratio
  res_head_tail_ratio <- PCRedux::head2tailratio(x)

  # Determine the slope from the cycles 2 to 11
  res_lm_fit <- PCRedux::earlyreg(x=cycles, x)

  # Try to estimate the slope and the intercept of the tail region,
  # which might be indicative of a hook effect (strong negative slope)
  res_hookreg_simple <- PCRedux::hookreg(x=cycles, x)
  res_hookregNL <- suppressMessages(PCRedux::hookregNL(x=cycles, x))
  
  res_hookreg <- ifelse(res_hookreg_simple["hook"] == 1 || res_hookregNL["hook"] == 1, 1, 0)

  # Calculates the area of the amplification curve
  res_polyarea <- try(pracma::polyarea(cycles, x), silent=TRUE)
  if(class(res_polyarea) == "try-error") {res_polyarea <- NA}
  
  # Calculate change points
  # Agglomerative hierarchical estimation algorithm for multiple change point analysis
  res_changepoint_e.agglo <- try(length(ecp::e.agglo(as.matrix(x))$estimates), silent=TRUE)
  if(class(res_changepoint_e.agglo) == "try-error") {res_changepoint_e.agglo <- NA}

  # Bayesian analysis of change points
  res_bcp_tmp <- bcp::bcp(x)
  res_bcp_tmp <- res_bcp_tmp$posterior.prob > 0.45
  res_bcp <- try((which(as.factor(res_bcp_tmp) == TRUE) %>% length))
  if(class(res_bcp) == "try-error") {res_bcp <- NA}

  # Median based local robust regression (mblrr)
  res_mblrr <- PCRedux::mblrr(cycles, x)

  # Calculate amptester results
  res_amptester <- suppressMessages(try(chipPCR::amptester(x)))
  
  # Estimate the spread of the approximate local minima and maxima of the curve data
  dat_smoothed <- chipPCR::smoother(cycles, x)

  res_diffQ <- suppressMessages(MBmca::diffQ(cbind(cycles, dat_smoothed), verbose = TRUE)$xy)
  res_mcaPeaks <- MBmca::mcaPeaks(res_diffQ[, 1], res_diffQ[, 2])
  mcaPeaks_minima_maxima_ratio <- base::diff(range(res_mcaPeaks$p.max[, 2])) / base::diff(range(res_mcaPeaks$p.min[, 2]))
  if(is.infinite(mcaPeaks_minima_maxima_ratio)) {mcaPeaks_minima_maxima_ratio <- NA}

  # Estimate the slope between the minimum and the maximum of the second derivative
  res_diffQ2 <- suppressMessages(MBmca::diffQ2(cbind(cycles, dat_smoothed), verbose=FALSE, fct=min))
  range_Cq <- diff(res_diffQ2[[3]])
  if(res_diffQ2[[3]][1] < res_diffQ2[1] && res_diffQ2[1] < res_diffQ2[[3]][2]) {range_Cq} else {range_Cq <- 0}
  if(res_diffQ2[[3]][1] < res_diffQ2[1] && res_diffQ2[1] < res_diffQ2[[3]][2] && range_Cq > 1 && range_Cq < 9) {
    res_diffQ2_slope <- coefficients(lm(unlist(c(res_diffQ2[[4]])) ~ unlist(c(res_diffQ2[[3]]))))[2]
  } else {res_diffQ2_slope <- 0}

  # Perform an autocorrelation analysis
  res_autocorrelation <- PCRedux::autocorrelation_test(y=x)

  # Fit sigmoidal models to curve data
  
   pcrfit_startmodel <- try(qpcR::pcrfit(dat, 1, 2), silent=TRUE)
  
   res_fit <- try(qpcR::mselect(pcrfit_startmodel, 
                          verbose = FALSE, do.all = TRUE), silent = TRUE)

  # Determine the model suggested by the mselect function based on the AICc
  res_fit_model <- try(names(which(res_fit[["retMat"]][, "AICc"] == min(res_fit[["retMat"]][, "AICc"]))), silent=TRUE)
  if(class(res_fit_model) == "try-error") {res_fit_model <- NA}

  if(class(res_fit)[1] != "try-error") {
    # TakeOff Point
    # Calculates the first significant cycle of the exponential region 
    # (takeoff point) using externally studentized residuals as described 
    # in Tichopad et al. (2003).
    res_takeoff <- try(qpcR::takeoff(res_fit), silent=TRUE)
    if(class(res_takeoff) == "try-error") {res_takeoff <- list(NA, NA)}

    # LRE qPCR efficiency
    # Calculation of qPCR efficiency by the 'linear regression of 
    # efficiency' method

    res_LRE <- try(qpcR::LRE(res_fit, plot=FALSE, verbose=FALSE)$eff, silent=TRUE)
    if(class(res_LRE) == "try-error") {res_LRE <- NA}

    # sliwin qPCR efficiency
    # Calculation of the qPCR efficiency by the 'window-of-linearity' method
    res_sliwin <- try(qpcR::sliwin(res_fit, plot=FALSE, verbose=FALSE)$eff, 
                      silent=TRUE)
    if(class(res_sliwin) == "try-error") {res_sliwin <- NA}

    # Cq of the amplification curve
    # Determine the Cq and other parameters
    res_efficiency_tmp <- try(
      qpcR::efficiency(res_fit, plot=FALSE)[c("eff",
                                        "cpD1", "cpD2",
                                        "fluo",
                                        "init1", "init2")],
      silent=TRUE)
    if(class(res_efficiency_tmp) != "try-error") {
      res_cpDdiff <- try(res_efficiency_tmp[["cpD1"]] - res_efficiency_tmp[["cpD2"]])
    } else {
      res_efficiency_tmp <- list(eff = NA,
                                 cpD1 = NA,
                                 cpD2 = NA,
                                 fluo = NA,
                                 init1 = NA,
                                 init2 = NA)
      res_cpDdiff <- NA
    }
  } else {
    res_efficiency_tmp <- list(eff = NA,
                               cpD1 = NA,
                               cpD2 = NA,
                               fluo = NA,
                               init1 = NA,
                               init2 = NA)
    res_takeoff <- list(NA, NA)
    res_LRE <- NA
    res_sliwin <- NA
    res_cpDdiff <- NA
  }
  
  res_efficiency <- data.frame(
    eff=res_efficiency_tmp[["eff"]],
    cpD1=res_efficiency_tmp[["cpD1"]],
    cpD2=res_efficiency_tmp[["cpD2"]],
    fluo=res_efficiency_tmp[["fluo"]],
    init1=res_efficiency_tmp[["init1"]],
    init2=res_efficiency_tmp[["init2"]],
    top=res_takeoff[[1]], 
    f.top=res_takeoff[[2]],
    resLRE=res_LRE[1],
    ressliwin=res_sliwin[[1]],
    cpDdiff=res_cpDdiff,
    slope_background=res_lm_fit[["slope"]],
    intercept_background=res_lm_fit[["intercept"]],
    polyarea=res_polyarea,
    changepoint.e.agglo=res_changepoint_e.agglo,
    changepoint.bcp=res_bcp,
    qPCRmodel=res_fit_model[[1]],
    amptester_shap.noisy=res_amptester@decisions["shap.noisy"][[1]],
    amptester_lrt.test=res_amptester@decisions["lrt.test"][[1]],
    amptester_rgt.dec=res_amptester@decisions["rgt.dec"][[1]],
    amptester_tht.dec=res_amptester@decisions["tht.dec"][[1]],
    amptester_slt.dec=res_amptester@decisions["slt.dec"][[1]],
    amptester_polygon=res_amptester@"polygon",
    amptester_slope.ratio=res_amptester@"slope.ratio",
    minRFU=fluo_range[[1]], 
    maxRFU=fluo_range[[2]],
    bg.start_normalized=res_bg.max[1],
    bg.stop_normalized=res_bg.max[2],
    amp.stop_normalized=res_bg.max[3],
    head_to_tail_ratio=res_head_tail_ratio,
    autocorellation=res_autocorrelation,
    mblrr_intercept_less=res_mblrr[1],
    mblrr_slope_less=res_mblrr[2],
    mblrr_cor_less=res_mblrr[3],
    mblrr_intercept_more=res_mblrr[4],
    mblrr_slope_more=res_mblrr[5],
    mblrr_cor_more=res_mblrr[6],
    hookreg_hook=res_hookreg,
    mcaPeaks_minima_maxima_ratio=mcaPeaks_minima_maxima_ratio,
    diffQ2_slope=res_diffQ2_slope,
    diffQ2_Cq_range=range_Cq
  )
}
