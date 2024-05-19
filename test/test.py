import numpy as np
import time

x = np.matrix(np.random.randint(1, 15, size=(1, 3)), dtype=np.uint8)
w = np.matrix(np.random.randint(1, 15, size=(3, 2)), dtype=np.uint8)

times = np.zeros(1000)
for i in range(1000):
    startTime = time.time()
    y = x * w
    times[i] = time.time()-startTime

print(f"Time taken for matrix multiplication: \n{times.mean()} sec")
