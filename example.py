import ctypes

lib = ctypes.CDLL('./zig-out/libstarter.so')  

lib.add.argtypes = [ctypes.c_int, ctypes.c_int]
lib.add.restype = ctypes.c_int

result = lib.add(5, 3)
print(f"5 + 3 = {result}")