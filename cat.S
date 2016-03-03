  .text
  .globl _start
_start:
  pop %rcx
  pop %rdi
  incl %edx
  jmp loopend
loop:
  xorl %esi, %esi # zero out rsi, rdx
  pop %rdi # Get the filename
  push %rcx # save rcx across syscalls
  push $2 # rax = 2 (SYS_OPEN)
  pop %rax
  syscall # syscall OPEN (rsi, rdx are 0)
  push %rax # garbage to be overwritten by read in val
	push %rsp # set rsi to previously pushed garbage
	pop %rsi
  push %rax # store fd
writeloop:
  pop %rdi # read fd from stack & restore it
  push %rdi
  xorl %eax, %eax # rax = 0 (SYS_READ)
  syscall
  cmp %edx, %eax # Check if we read 1
  jne afterwriteloop
  xorl %edi, %edi # rdi = 0 (STDOUT)
  #incl %eax # eax = edx = 1 = SYS_WRITE
  syscall
  jmp writeloop
afterwriteloop:
  pop %rax # get rid of the garbage value
  pop %rax # get rid of the file descriptor (don't close because meh)
  pop %rcx # Get rcx back
loopend:
  loop loop
  push $60
  pop %rax
  xor %edi, %edi # exit code 0
  syscall
