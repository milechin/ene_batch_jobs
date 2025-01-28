# Load necessary libraries

library(foreach)
library(doParallel)

# Set up parallel backend to use multiple cores

numCores <- as.integer(Sys.getenv("NSLOTS"))
cl <- makeCluster(numCores)
registerDoParallel(cl)

# Define the task to run in parallel
task <- function() {
    start_time <- Sys.time()
    while (difftime(Sys.time(), start_time, units = "mins") < 10) {
        # Perform some computation or task
        # Create a 2 GB array
        array_size <- 2 * 1024^3 / 8  # 2 GB in number of doubles (8 bytes each)
        large_array <- runif(array_size)
        sqrt(large_array)
    }
    return("Task completed")
}

# Run the task in parallel using foreach
results <- foreach(i = 1:numCores, .combine = c) %dopar% {
    task()
}

# Stop the cluster
stopCluster(cl)
