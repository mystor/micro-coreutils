.PHONY: all
all: yes echo cat

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

