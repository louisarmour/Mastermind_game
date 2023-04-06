# f28hs-2020-21-cwk3-sys

Coursework 3 in F28HS "Hardware-Software Interface"  on Systems Programming in C and ARM Assembler

The [CW specification is here](https://www.macs.hw.ac.uk/~hwloidl/Courses/F28HS/F28HS_CW3_2021.pdf)

This folder contains the CW3 specification template files for the source code and for the report.

**Fork** and **Clone** this gitlab repo to get started on the coursework.

**Push** to the repo and ask questions in the comments box to get help.

You can build the C program, starting from the template in `master-mind-terminal.c`, by typing
> make

and run the Master Mind program in debug mode by typing
> make run

and do unit testing on the matching function
> make unit

For the Assembler part, you need to edit the `mm-matches.s` file, upload and execute them to the CPUlator.
See the test input data in the `secret` and `guess` structures at the end of the file, for testing.

Separate solutions for the C and the Assembler part should be submitted. They **don't** need to be integrated.

The final version of the code should be pushed to this repo, and also submitted through Vision, together with the report.

A test script is available to do unit-testing of the matching function. Run it like this from the command line
> sh ./test.sh

To test whether all tests have been successful you can do
> echo $?

which should print `0`.

If you picked up the `.gitlab-ci.yml` file in this repo, this test will be done automatically when uploading the file and you will get either a Pass or Fail in the CI section of the gitlab-student server.

Use [this link](https://docs.google.com/spreadsheets/d/1iUMkIK1-76qp3_G4s9Qvd1huxu94v4ikyB0Ya0PGypQ/edit?usp=sharing) to sign-up as a pair for this pair project.

Links:
- Use the [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc&d_audio=48000) for running the ARM Assembler code
- You can use any machine with an installation of the `gcc` C compiler for running the C code of the game logic
- Template for the C program: [master-mind-terminal.c](master-mind-terminal.c)
- Template for the ARM Assembler program: [mm-matches.s](mm-matches.s)
- Pick up your personal input data from this web-page, replacing `USERID` with your HWU user-id: [https://www.macs.hw.ac.uk/~hwloidl/Courses/F28HS/CW_Data/USERID.txt](https://www.macs.hw.ac.uk/~hwloidl/Courses/F28HS/CW_Data/USERID.txt)

This is an example of doing unit-testing on 2 sequences (C part only; the Assembler version, running on the CPUlator, should show the numbers on the two right-most HEX-displays):
```
> ./cw3 -u 121 313
0 exact matches
1 approximate matches
```

This is an example of doing a full run of the game, using debug mode to show the secret sequence (for testing):
```
> ./cw3 -d
Contents of the sequence (of length 3):  2 1 1
Input seq (len 3): 1 2 3
0 2
Input seq (len 3): 3 2 1
1 1
Input seq (len 3): 2 1 1
3 0
SUCCESS after 3 iterations; secret sequence is  2 1 1
```

The general format for the command line is as follows (see template code in master-mind-terminal.c for processing command line options):
```
./mmt [-v] [-d] [-s] <secret sequence> [-u] <sequence1> <sequence2>
```