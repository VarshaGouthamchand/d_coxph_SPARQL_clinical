library(rjson)
library(dplyr)

wait_for_results <- function(client, task) {
  
  path = sprintf('/task/%s', task$id)
  
  #while(TRUE) {
    #r <- client$GET(path)
    
    #if (content(r)$complete) {
     # break
      
    #} else {
      # Wait 30 seconds
      #writeln("Sleeping ...")
     # Sys.sleep(5)
    #}
  #}
  
  #path = sprintf('/task/%s?include=results', task$id)
  #r <- client$GET(path)
  #print(content)
  
  #return(content(r))
}

postTask <- function(client, input) {
  # Create the json structure for the call to the server
  #input <- create_task_input(method, ...)
  #ids <- list("35")
  task = list(
    "name"="Cox_validation",
    "image"="varshagouthamchand/ppdli_cox_val_sparql",
    "collaboration_id"=client$get("collaboration_id"),
    "input"=input,
    "description"="",
    "organization_ids"=list(c(3)) #1-HN1 #2-MDA #3-Montreal #4-OPC 5#-HN3
  )
  
  # Create the task on the server; this retu-=s the task with its id
  r <- client$POST('/task', task)
  print(content(r))
  # Wait for the results to come in
  result_dict <- wait_for_results(client, content(r))
  #print(result_dict)
  
  # result_dict is a list with the keys _id, id, description, complete, image,
  # collaboration, results, etc. the entry "results" is itself a list with
  # one entry for each site. The site's actual result is contained in the
  # named list member 'result' and is encoded using saveRDS.
  #sites <- result_dict$results
  #print(sites)
  #results <- list()
  
  #for (k in 1:length(sites)) {
   # results[[k]] <- readRDS(textConnection(sites[[k]]$result))
  #}

  ## Hypothesis testing -read result_dict 
  
}