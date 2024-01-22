post_msg <- function(webhook_url,msg){
  # send message to google chat
  POST(webhook_url,
       add_headers("Content-Type" = "application/json; charset=UTF-8"),
       body = list("text" = msg),
       encode = "json")
}# end func
