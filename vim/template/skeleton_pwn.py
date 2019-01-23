# not yet completed

from pwn import *
from my_pwn_tools import *

# my_pwn_tools
fmt = format_s()

def print_payload(payload, message = None):
    if message != None:
        log.info(message)
    log.info("payload: " + str(payload))
    log.info("payload length: " + str(len(payload)))

context.arch = "amd64"
context.os = "linux"
context.endian = "little"
# ["CRITICAL", "DEBUG", "ERROR", "INFO", "NOTSET", "WARN", "WARNING"]
context.log_level = "DEBUG"
#context.terminal = ['gnome-terminal', '-x', 'sh', '-c']
#gdb.attach(r, execute='b main\n')

is_local = False
#is_local = True
host = ""
port = 0
if is_local:
    host = "127.0.0.1"
    port = 8888
#r = remote(host, port)
#r.close()
#r = process("./a.out")  #r = process("./a.out", env={"LD_PRELOAD" : "./libc.so.6"})

input("Attach in gdb and press Enter")

#u64(r.recvuntil("\n")[:-1].ljust(8, b"\x00"))
#r.recvuntil(":")
#payload = flat([])
#print_payload(payload)
#r.sendline(payload)

r.interactive("Pwned # ")
