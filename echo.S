  .text
  .globl _start
_start:
  pop %rcx
  pop %rsi                      # Discard the first arg
  jmp loopend
loop:
  pop %rsi
lenloop:
  incl %edx
  cmpb %al, -1(%rsi,%rdx,1)     # al is 0
  jne lenloop
  incl %eax                     # eax is 1 (SYS_WRITE)
  jecxz exit
  movb $32, -1(%rsi,%rdx,1)     # Replace the null with a space
  push %rcx                     # Syscall clobbers rcx, so push it
  syscall
  pop %rcx
  xorl %eax, %eax               # return al to 0
  xorl %edx, %edx
loopend:
  loop loop
  movw $10, (%rsi)              # Write out a newline
  jmp lenloop
exit:
  syscall
  push $60
  pop %rax
  syscall
