import ctypes

lib = ctypes.CDLL('./zig-out/libstarter.so')  

lib.addNumbers.argtypes = [ctypes.c_int, ctypes.c_int]
lib.addNumbers.restype = ctypes.c_int

result = lib.add(5, 3)
print(f"5 + 3 = {result}")