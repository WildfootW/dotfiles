# not yet completed

from pwn import *
from my_pwn_tools import *

# my_pwn_tools
fmt = format_s()

def print_payload(payload, message = None):
    if message != None:
        log.info(message)
    payload = str(payload)
    log.info("payload: " + payload)
    log.info("payload length: " + str(len(payload)))

fmt = format_s()

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
#r.recvuntil(":")

#print_payload(payload)
#r.sendline(payload)
r.interactive("Pwned # ")
