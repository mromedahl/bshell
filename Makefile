Bshell: Bshell.o
	ld Bshell.o -o Bshell -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` 

Bshell.o: Bshell.s
	as -o Bshell.o Bshell.s

