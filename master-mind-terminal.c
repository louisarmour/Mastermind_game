/*
 * MasterMind: a cut down version with just the master-mind game logic (purely C) and no external devices

Sample run:
Contents of the sequence (of length 3):  2 1 1
Input seq (len 3): 1 2 3
0 2
Input seq (len 3): 3 2 1
1 1
Input seq (len 3): 2 1 1
3 0
SUCCESS after 3 iterations; secret sequence is  2 1 1

 * Compile:    gcc -o cw3  master-mind-terminal.c
 * Run:        ./cw3

 */

/* --------------------------------------------------------------------------- */

/* Library headers from libc functions */
#include <stdio.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <math.h>
#include <time.h>

/* Constants */
#define  COL  3
#define  LEN  3

/* Global variables */

static const int colors = COL;
static const int seqlen = LEN;

static char* color_names[] = { "red", "green", "blue" };

static int sequence[3]; //holds secret sequence as array

static int guess[3]; //holds user guess as array

static int* userGuess = NULL; // holds user guess as integer

static int* theSeq = NULL; //holds secret sequence as integer

/* Aux functions */

/* initialise the secret sequence; by default it should be a random sequence, with -s use that sequence */
void initSeq() {

    theSeq = (int*)malloc(sizeof(int));
    srand(time(NULL)); //seed generator for psuedo-random numbers
    int i;

    for (i = 0; i < LEN; i++) {
        sequence[i] = rand() % LEN + 1; //loop for size of sequence (3) and add random numbers between 1-3: eg: 1 1 3
    }


    int j = 0;
    //concatenate sequence array and store in theSeq integer variable
    for (j = 0; j < LEN; j++) {
        theSeq = (uintptr_t)theSeq * 10 + sequence[j];
    }
}


/* display the sequence on the terminal window, using the format from the sample run above */
void showSeq(int* seq) {
    
    int i = 0;
    fprintf(stdout, "Contents of sequence (of length 3): ");
    //print each element of randomised sequence
    for (i = 0; i < LEN; i++) {
        printf(" %d ", sequence[i]);
    }
    fprintf(stdout, "\n");
}

/* counts how many entries in seq2 match entries in seq1 */
/* returns exact and approximate matches  */
int countMatches(int *seq1, int *seq2) {

    int i, j;
    int exact = 0, approx = 0;

    //temp array to store values
    int temp[3];

    for (i = 0; i < 3; i++) {
        temp[i] = sequence[i];
    }

    for (i = 0; i < 3; i++) {
        if (temp[i] == guess[i]) {
            //increment exact if number is in correct position of sequence
            exact++;
            //change these values to avoid clashing
            temp[i] = 5;
            guess[i] = 15;
        }
    }

    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            if (guess[i] == temp[j]) {
                //change these values to avoid clashing
                temp[j] = 4;
                guess[i] = 8;
                //increment approx if the number exists in answer but in a different place
                approx++;
            }
        }
    }
    //display exact and approx
    fprintf(stdout, "%d %d", exact, approx);
    fprintf(stdout, "\n");

    return exact;

    

}

/* show the results from calling countMatches on seq1 and seq1 */
void showMatches(int code, /* only for debugging */ int * seq1, int *seq2) {
    countMatches(seq1, seq2);
}

/* read a guess sequence fron stdin and store the values in arr */
void readString(int *arr) {
 
    int i = 0;
    //temp array to store values
    int temp[3];
    int j = 0;
    //count set to length of sequence
    int count = 3;
    //store each individual character from user input into temp array, this will store in reverse
    for(i = 0; i < 3; i++){
        int mod = (uintptr_t)arr % 10;
        arr = (uintptr_t) arr / 10;
        temp[i] = mod;
    }
    //reverse temp array to get original user input stored in array
    for (j = -1; j < 3; j++) {
        guess[count] = temp[j];
        count--;
    }
}

/* Creates array from user input of secret sequence*/
void createArray(int* ptr) {

    int i = 0;
    //temp array to store values
    int temp[3];
    int j = 0;
    //count set to size of sequence
    int count = 3;

    //store each int index in array, this will be stored in reverse
    for (i = 0; i < 3; i++) {
        int mod = (uintptr_t)ptr % 10;
        ptr = (uintptr_t)ptr / 10;
        temp[i] = mod;
    }
    //reverse this array and add to sequence array
    for (j = -1; j < 3; j++) {
        sequence[count] = temp[j];
        count--;
    }
}



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

int main(int argc, char **argv){
  /* DEFINE your variables here */
  int found = 0, attempts = 0;
  /* for getopts() command line processing */
  int verbose = 0, help = 0, unittest = 0, debug = 0;
  char *sseq = NULL;
  char *gseq = NULL;


  // see: man 3 getopt for docu and an example of command line parsing
  // Use this template to process command line options and to store the input
  {
    int opt;
    while ((opt = getopt(argc, argv, "vuds:")) != -1) {
      switch (opt) {
      case 'v':
	verbose = 1;
	break;
      case 'u':
	unittest = 1;
	break;
      case 'd':
	debug = 1;
	break;
      case 's':
	sseq = (char *)malloc(LEN*sizeof(char));
	strcpy(sseq,optarg);
	break;
      default: /* '?' */
	fprintf(stderr, "Usage: %s [-v] [-d] [-s] <secret sequence> [-u] <secret sequence> <guess sequence> \n", argv[0]);
	exit(EXIT_FAILURE);
      }
    }
    if (unittest && optind >= argc) {
      fprintf(stderr, "Expected argument after options\n");
      exit(EXIT_FAILURE);
    }

    if (verbose && unittest) {
      printf("1st argument = %s\n", argv[optind]);
      printf("2nd argument = %s\n", argv[optind+1]);
    }
  }

  if (verbose) {
    fprintf(stdout, "Settings for running the program\n");
    fprintf(stdout, "Verbose is %s\n", (verbose ? "ON" : "OFF"));
    fprintf(stdout, "Debug is %s\n", (debug ? "ON" : "OFF"));
    fprintf(stdout, "Unittest is %s\n", (unittest ? "ON" : "OFF"));
    if (sseq)  fprintf(stdout, "Secret sequence set to %s\n", sseq);
  }

  if (sseq) { // explicitly setting secret sequence
    /* SET the secret sequence here */
      //get set secret sequence from user input
      sseq = argv[2];
      //convert sseq string to an integer to store in theSeq
      theSeq = (uintptr_t)atoi(sseq);
      //add each index of int into array
      createArray(theSeq);


  }    
  if (unittest) {
    /* SET secret and guess sequence here */
      gseq = (char*)malloc(LEN * sizeof(char));

      sseq = argv[2];
      gseq = argv[3];
      //set both user inputs to integer variables
      theSeq = (uintptr_t)atoi(sseq);
      userGuess = (uintptr_t)atoi(gseq);

      //create secret sequence array
      createArray(theSeq);
      //create guess array
      readString(userGuess);


    /* then run the countMatches function and show the result */
      int cm = countMatches(userGuess, theSeq);

      //exit program after exact and approximate matches are printed
      exit(0);
  }

  // -----------------------------------------------------------------------------

  if (!(unittest || sseq)) {
      //generate random sequence if none of these modes are present
      //make sure sequence is null to start
      theSeq = NULL;
      initSeq();
  }

  //if user selects debug
  if (debug) {
      showSeq(theSeq);
  }
  // +++++ main loop
  while (!found) {

    attempts++;
    /* IMPLEMENT the main game logic here */

    fprintf(stdout, "Input seq (len 3) (NO SPACES): ");

    //add each element from stdin into arr
    scanf("%d", &userGuess);
    //pass user input into readString, which will split integer into an array
    readString(userGuess);
    //count matches of the secret sequence and the user's guess
    int match = countMatches(userGuess, theSeq);

    //make sure user only has 3 guesses maximum
    if (attempts > 3) {
        fprintf(stdout, "You Lose! You have had too many attempts!\n");
        exit(0);
    }

    //count matches returns the exact matches, so if all 3 numbers match, the user wins
    if (match == 3) {
        found = 1;
    }


  }

  if (found) {
    /* print SUCCESS and the number of iterations */
      if (attempts == 1) {
          fprintf(stdout, "Success! It took you %d attempt!\n", attempts);
      }
      else{
          fprintf(stdout, "Success! It took you %d attempts!\n", attempts);
      }
  } else {
    /* print something else */
      fprintf(stdout, "You Lose! Too many attempts!\n\n");
  }
  return EXIT_SUCCESS;
}
  
