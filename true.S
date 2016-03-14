  .text
  .globl _start
_start:
  push $60
  pop %rax
  syscall
