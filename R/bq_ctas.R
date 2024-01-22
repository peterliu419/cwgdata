#' bq_ctas
#'
#' @param ctas_qry
#' @param projectId
#' @param datasetId
#' @param tableId
#' @param createDisposition
#' @param writeDisposition
#'
#' @return
#' @export
#'
#' @examples
#'   bq_ctas(
#'     projectId = "cw-bquery",
#'     datasetId = "l_cw_data_science",
#'     tableId = "cw_leadercampus_hr_platform_monthly_podcast",
#'     writeDisposition = "WRITE_TRUNCATE")
#'
#'   bq_ctas("cw-bquery",
#'    "p_visual",
#'    "ch_lda_article_dashboard_user_inspector_user_h1_model_uid_topics",
#'    writeDisposition = "WRITE_TRUNCATE")

bq_ctas <- function(ctas_qry, projectId, datasetId, tableId,
                    createDisposition = "CREATE_IF_NEEDED",
                    writeDisposition = "WRITE_EMPTY"){

  ## begin modification : detect environment for r_script variable, if exist, then add into SQL comment
  if(exists("r_script") & exists("bq_add_comment") & exists("ctas_qry")){
    ctas_qry <- bq_add_comment(ctas_qry, r_script)
  }# end if
  ## end modification

  body <- list(configuration = list(query = list(query = as.character(dbplyr::sql_render(ctas_qry)),
                                                 destinationTable = list(projectId = projectId,
                                                                         datasetId = datasetId,
                                                                         tableId = tableId),
                                                 createDisposition = createDisposition,
                                                 writeDisposition = writeDisposition,
                                                 useLegacySql = "false")))

  res <- bigrquery:::bq_post(url = bigrquery:::bq_path(project = ctas_qry$src$con@project, jobs = ""),
                             body = bigrquery:::bq_body(body),
                             query = list(fields = "jobReference"))
  job <- bigrquery:::as_bq_job(res$jobReference)
  bigrquery::bq_job_wait(job, quiet = NA)

}# end func
