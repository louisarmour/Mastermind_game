# Build and run the MasterMind program (implemented just in C, no Assembler component)

# default goal
all: cw3

# clean up by deleting binaries
clean:
	rm cw3

# how to run the program, in debugging setup, showing the secret sequence as well
run: cw3
	./cw3 -d

# do unit testing on the matching function
unit: cw3
	sh ./test.sh

# build the app
cw3: master-mind-terminal.c
	gcc -o cw3  master-mind-terminal.c
