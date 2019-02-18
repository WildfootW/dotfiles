# not yet completed

from pwn import *
#from my_pwn_tools import *

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
context.terminal = ["tmux", "split-window"] # ["gnome-terminal", "-x", "sh", "-c"] # ["tmux", "neww"]

is_local = True
#is_local = False
r = process("./a.out")  #r = process("./a.out", env={"LD_PRELOAD" : "./libc.so.6"})
libc = ELF("/lib/x86_64-linux-gnu/libc-2.27.so") # ELF("/lib/i386-linux-gnu/libc-2.27.so")
host = "127.0.0.1"
port = 8888
#r.close()
#r = remote(host, port)
if not is_local:
    host = ""
    port = 0
    r = remote(host, port)
    libc = ELF("./libc-2.23.so")

if is_local:
    #input("Attach in gdb and press Enter")
    gdb.attach(r, execute='b main\n')

#u64(r.recvuntil("\n")[:-1].ljust(8, b"\x00"))
#r.recvuntil(":")
#payload  = flat([])
#print_payload(payload)
#r.sendline(payload)

r.interactive("Pwned # ")
