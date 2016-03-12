  .text
  .globl _start
_start:
  push $60
  pop %rax
  push $1
  pop %rdi
  syscall
