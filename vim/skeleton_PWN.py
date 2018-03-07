#!/usr/bin/env python
#   WildfootW 2018
#   https://github.com/Wildfoot
#
# open program at local 
# ncat -ve ./a.out -kl 8888

from pwn import *

context.update(arch="i386", os="linux")

host = "127.0.0.1"
port = 8888
#host = ""
#port = 
r = remote(host, port)

input("attach in gdb and press Enter")

payload = flat([])

print(payload)

#r.recvuntil(":")
#r.sendline(payload)
#r.interactive()
