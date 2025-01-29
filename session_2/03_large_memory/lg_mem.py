import numpy as np
import time

# Calculate the number of elements needed to create an array of 2 GB
# Assuming each element is a float32 (4 bytes)
num_elements = (2 * 1024**3) // 4

# Create the random array in smaller chunks to avoid MemoryError
random_array = np.random.rand(num_elements).astype(np.float32)

def compute_heavy_task():
    # Simulate a heavy computation task
    start_time = time.time()
    while time.time() - start_time < 510:
        pass  # Busy-wait for 5 seconds

compute_heavy_task()

# Print the size of the array in GB
print(f"The size of the array is {random_array.nbytes / 1024**3} GB")
