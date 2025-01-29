

file_list <- c("FileA.tif", "FileB.tif", "FileC.tif")


## Next we need the $SGE_TASK_ID argument from the command line.
## Get the argument that was passed via command line.
argv <- commandArgs(TRUE)
if (length(argv) > 0){
  
  # In this example $SGE_TASK_ID is the first argument
  # located at index of 1 (e.g. argv[1])
  # Save the $SGE_TASK_ID value to 'task_ID' variable
  task_ID <- as.numeric( argv[1] )
}


print(paste("Processing file:", file_list[task_ID]))