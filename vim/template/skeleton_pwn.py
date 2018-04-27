# not yet completed

from pwn import *

context.update(arch="i386", os="linux")
context.log_level = "debug"

host = "127.0.0.1"
port = 8888
#host = ""
#port = 
r = remote(host, port)

input("Attach in gdb and press Enter")

#payload = flat([])
#print(payload)

#r.recvuntil(":")
#r.sendline(payload)
r.interactive()
