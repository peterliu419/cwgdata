bq_add_comment <- function(qry, comment){

  msg <- try({
    commented_query <- paste0("#query_cost_tracing::",comment,"\n",as.character(dbplyr::sql_render(qry)))

    vars <- DBI::dbFetch(DBI::dbSendQuery(qry$src$con, paste0("select * from (",commented_query,") limit 0")), 0)
    vars <- names(vars)

    subclass <- class(qry$src$con)[[1]]
    output <- make_tbl(purrr::compact(c(subclass, "sql", "lazy")),
                       ops = dbplyr:::op_base_remote(sql(commented_query), vars),
                       src = qry$src)
  },silent = TRUE)

  if(class(msg) == "try-error"){
    message("error occurred when adding cost tracking comment, thus no comment added")
    return(qry)
  }else{
    return(output)
  }# end if

}# end function
