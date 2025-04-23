import numpy as np
import torch
from math import *

def convert2(x,sig):
    if x<128 and x>=-128:
        return x
    else:
        s = bin(x)
        l = len(s)
        sc = int(s[:sig+2]+'0'*(l-sig-2),2)
        return sc

def round_it_np(x,sig):
    r,c = x.shape
    y = np.zeros((r,c))
    for i in range(r):
        for j in range(c):
            y[i,j] = convert2(int(x[i,j]),sig)
    return y

# params
np.random.seed(1023)
sparsity = 0.35
shape = (1024, 512)
N = 8
array = np.random.randint(-2**N, 2**N-1, size=shape).astype(np.int64)
array[np.random.rand(*shape) < sparsity] = 0
a1 = array[0:512,:]
a2 = array[512:1024,:]

for sig_bit_len in [8,9,10]:

    a1_longint = torch.from_numpy(a1).to(torch.int64)
    a2_longint = torch.from_numpy(a2).to(torch.int64)

    correct_result = torch.matmul(a1_longint, a2_longint)
    # print(correct_result)
    # print(torch.max(correct_result))

    # 计算转换为BF的结果，保留sig_bit_len位有效数字(二进制)
    result_array = round_it_np(correct_result,sig_bit_len)

    loss = torch.sum(torch.square(correct_result-result_array)) 
    relative_loss = loss/torch.sum(torch.square(correct_result)) 
    print(f">>sig_bit_len={sig_bit_len}, loss is {loss}, relative_loss is {relative_loss}")

