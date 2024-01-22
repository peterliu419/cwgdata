bq_unnest <- function(qry, from_col, to_col){
  unnest_qry <- paste0("select * from (",
                       as.character(dbplyr::sql_render(qry)),"),
                       unnest (",from_col,") ",to_col)

  vars <- DBI::dbFetch(DBI::dbSendQuery(qry$src$con, paste0("select * from (",unnest_qry,") limit 0")), 0)
  vars <- names(vars)

  subclass <- class(qry$src$con)[[1]]
  make_tbl(purrr::compact(c(subclass, "sql", "lazy")),
           ops = dbplyr:::op_base_remote(sql(unnest_qry), vars),
           src = qry$src)
}# end func
