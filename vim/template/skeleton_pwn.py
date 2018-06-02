# not yet completed

from pwn import *

context.arch = "i386"
context.os = "linux"
context.endian = "little"
# ["CRITICAL", "DEBUG", "ERROR", "INFO", "NOTSET", "WARN", "WARNING"]
context.log_level = "DEBUG"

is_local = True

host = ""
port = 0
if is_local:
    host = "127.0.0.1"
    port = 8888
r = remote(host, port)

input("Attach in gdb and press Enter")

#payload = flat([])
#log.info("payload: " + str(payload))

#r.recvuntil(":")
#r.sendline(payload)
r.interactive("Pwned # ")
