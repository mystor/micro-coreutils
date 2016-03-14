.PHONY: all
all: yes echo cat true false

yes: micro yes.S
	as -o yes.o yes.S
	ld -o dbg-yes yes.o
	./micro dbg-yes yes
	chmod +x yes

echo: micro echo.S
	as -o echo.o echo.S
	ld -o dbg-echo echo.o
	./micro dbg-echo echo
	chmod +x echo

cat: micro cat.S
	as -o cat.o cat.S
	ld -o dbg-cat cat.o
	./micro dbg-cat cat
	chmod +x cat

true: micro true.S
	as -o true.o true.S
	ld -o dbg-true true.o
	./micro dbg-true true
	chmod +x true

false: micro false.S
	as -o false.o false.S
	ld -o dbg-false false.o
	./micro dbg-false false
	chmod +x false

micro: micro.c
	gcc -o micro micro.c

.PHONY: clean
clean:
	rm micro
	rm *.o
	rm dbg-*
	rm echo
	rm yes
	rm cat
	rm true
	rm false
