  .text
noarg:
  movw $0x79, (%rsp)            # clobber first prog arg with 'y\0'
  push %rsp                     # push then pop is 2 bytes, while movq is 3
  pop %rsi
  jmp lenloop                   # Proceed to length calcs

  .globl _start
_start:
  pop %rcx                      # argc
  cmpq $2, %rcx
  jb noarg                      # If we have less than 2 args, get 'y' string
  pop %rsi                      # Discard Program Name
  pop %rsi                      # Get First Argument
lenloop:
  incl %edx                     # Starts at 0 at prog start
  cmpb %al, -1(%rsi,%rdx,1)     # Check for end of string (al is 0)
  jne lenloop
  movb $10, -1(%rsi,%rdx,1)     # Set the 0 to a newline (ASCII 10)
printloop:
  incl %eax                     # Set eax to 1 = SYS_WRITE (started at 0)
  # Perform the system call. At this point %rsi contains the string pointer
  # %rdx contains the string length, %rdi contains 0 (STDOUT), as it was
  # never set, and %rax contains 1 (SYS_WRITE)
  syscall                       # Registers except %rax persist across call
  subl %edx, %eax               # Reset eax to 0, and check for failure
  je printloop                  # on failure continue, else loop

  movl $60, %eax                # Exit the program with status 130
  movl $130, %edi
  syscall
