/*
Lab 5 take home assignment. Open MATLAB to compute
Page rank from Connectivity Matrix located in web.txt

Author:		Ammar Rehan
Student #s :	10649151
CS Accounts : f7v0b
Date :		25th November 2018

This lab was completed only by myself as there
was no other person available to partner up with
*/

#define _CRT_SECURE_NO_WARNINGS

/* Preprocessor directives */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "engine.h"
#include "matrix.h"

//mxSingle* mxGetSingles(mxArray* ConnectivityMatrix);

#define FILE_NAME           "web.txt"
#define BUFSIZE 256 

int get_dimension(FILE * file_pointer);
double** make_matrix(int dimension);
void get_matrix(FILE * file_pointer, double** matrix, int dimension);
double** transpose(double** matrix, int dimension);
void send_MATLAB(double** t_matrix, int d);


int main(void)
{
	int dimension = 0;
	int i = 0, j = 0;
	double ** matrix = NULL;
	double ** t_matrix = NULL;
	FILE * file_pointer = NULL;         /* A "pointer" to a file */
	char filename[] = FILE_NAME;


	/* Opens the text file for reading */
	fopen_s(&file_pointer, FILE_NAME, "r");

	/* Gets the dimension of the matrix in the text file */
	dimension = get_dimension(file_pointer);
	printf("Matrix dimension is %d \n", dimension);
	if (dimension == 0) { 
		printf("Matrix can not be made, No Page Rank\nProgram will now exit\n"); 
		system("pause");
		return 0;
	}

	/* Declares a 2D array (equal rows and columns) 'matrix' */
	matrix = make_matrix(dimension);

	/* Reads the text file to declared 2D array 'matrix' */
	get_matrix(file_pointer, matrix, dimension);

	/*	For displaying matrix
			for (i = 0; i < dimension; i++) {
			for (j = 0; j < dimension; j++) printf("%d ", matrix[i][j]);
			printf("\n");}
	*/

	/* Gets transpose of matrix and stores in 't_matrix' */
	t_matrix = transpose(matrix, dimension); //we do not really need the traspose as Matlab can work with the original matrix and generate correct results

	/* Sends t_matrix to MATLAB and creates connectivity_matrix in MATLAB */
	printf("Initalizing MATLAB\n");
	printf("Calculating Page Rank.......\n");
	send_MATLAB(t_matrix, dimension);

	/* Generates 1D array 'pager_rank' in C from 'connectivity_matrix' in MATLAB */
		//process_MATLAB();

	/* Display pager_rank */
		//display(pager_rank);

	/* Close the text file */
	if (file_pointer != NULL) fclose(file_pointer);

	system("pause");
	return 0;
}

/* This function calculates the number of dimensions in the text file */
int get_dimension(FILE * file_pointer) {
	int ch;
	int rows = 0, columns = 0;
	if (file_pointer == NULL) {
		printf("Error in opening file\n");
		return -1;
	}
	else {
		printf("File successfully opened\n");
		rows = 1;
		columns = 1;
		while (getc(file_pointer) != -1) { //checks for end of file
			ch = getc(file_pointer); //check for next character
				if (rows == 1) if (ch == ' ') columns++; 
				if (ch == '\n') rows++;
		}
		}
		if (rows != columns) { 
		printf("Error, matrix in web.txt is not a square matrix\n"); 
		return 0;
		}
		else {
			printf("Matrix dimensions agree\n");
			return rows;
		}
	}

double** make_matrix(int dimension) {
	int r = dimension;
	int c = dimension;
	int i;
	double **arr = (double **)malloc(r * sizeof(*arr)); //arr has r rows
	for (i = 0; i < r; i++) arr[i] = (double *)malloc(c * sizeof(double)); //each row r has c columns with it
	return arr;
}

void get_matrix(FILE * file_pointer, double** matrix, int dimension)
{
	//Variable list 
	int r, c;
	int i = 0;
	double j = 0.0;

	rewind(file_pointer); //this restores the file_pointer to start reading from beginning of file

	for (r = 0; r < dimension; r++) {	//loop runs once for each line of readings, line_buffer gets values in first line of text file
		for (c = 0; c < dimension; c++) {
			fscanf(file_pointer, "%d", &i);
			j = (double)i;
			matrix[r][c] = j;
		}
	}
	return;
}

double** transpose(double** matrix, int dimension) {

	//variable declaration
	double ** transpose = NULL;
	int i, r = 0, c = 0;

	transpose = make_matrix(dimension); //declares new matrix of similar dimension as the new transpose
	//algorithim for transposing matrix
	while (r < dimension) {
		for (i = 0; i < (dimension - r); i++) {
			transpose[r][c + i] = matrix[r + i][c];
			transpose[r + i][c] = matrix[r][c + i];
		}
		r++;
		c++;
	}
	return transpose;
}

void send_MATLAB(double** matrix, int d) {
	//mxSingle* mxGetSingles(mxArray* ConnectivityMatrix) = NULL;
	//variable declaration
	Engine *ep = NULL; //A pointer to a MATLAB engine project
	mxArray *ConnectivityMatrix = NULL, *result = NULL; //mxArray is the fundamental type underlying MATLAB data
	int elements = d * d;

	char buffer[BUFSIZE + 1];

	//Starts a Matlab Process
	if (!(ep = engOpen(NULL))) {
		fprintf(stderr, "\nCan't start MATLAB engine\n");
		system("pause");
		return 1;
	}
	//Create Matlab friendly variable Array initialized as a zero array
	ConnectivityMatrix = mxCreateDoubleMatrix(d, d, mxREAL);
	//mxGetSingles(ConnectivityMatrix)
	
	//Copies t_matrix to Matlab variable ConnectivityMatrix
	//memcpy((void*)mxGetPr(ConnectivityMatrix), (void*)(*(t_matrix)), (elements *(sizeof(double)))); //failed to implement
	size_t r,c, a = 0;
	for (r = 0; r < d; r++) {
		for (c = 0; c < d; c++) {
			*(mxGetPr(ConnectivityMatrix) + a) = (*(*(matrix + r) + c));
			a++;
		}
	}
	
	//we place ConnectivityMatrix into the MATLAB workspace
	if (engPutVariable(ep, "ConnectivityMatrix", ConnectivityMatrix)) {
		fprintf(stderr, "\nCannot write ConnectivityMatrix to MATLAB \n");
		system("pause");
		exit(1); //same as return 1
	}

	/* The following is to check if ConnectivityMatrix got the values of matrix
if ((result = engGetVariable(ep, "ConnectivityMatrix")) == NULL) {
	fprintf(stderr, "\nFailed to retrieve initial ConnectivityMatrix\n");
	system("pause");
	exit(1);
}
else {
	size_t i = 0;
	printf("\nThe initial ConnectivityMatrix is:\n");
	for (i = 0; i < elements; i=i+6) {
		printf("%f ", *(mxGetPr(result) + i));
		printf("%f ", *(mxGetPr(result) + i+1));
		printf("%f ", *(mxGetPr(result) + i+2));
		printf("%f ", *(mxGetPr(result) + i+3));
		printf("%f ", *(mxGetPr(result) + i+4));
		printf("%f \n", *(mxGetPr(result)+ i+ 5));
	}	
}
*/

	//use matlab engine to get dimension
	if (engEvalString(ep, "dimension = size(ConnectivityMatrix, 1)")) {
		fprintf(stderr, "\nError finding dimension\n");
		system("pause");
		exit(1);
	}
	/*Display dimension
	result = NULL;
	result = (engGetVariable(ep, "dimension"));
	printf("dimension in matlab is %f \n", *(mxGetPr(result)));
	*/
	if (engEvalString(ep, "columnsums = sum(ConnectivityMatrix, 1)")) {
		fprintf(stderr, "\nError finding columnsums\n");
		system("pause");
		exit(1);
	}
	/*Display columnsums
	result = NULL;
	result = (engGetVariable(ep, "columnsums"));
	printf("columnsums vector is %f %f %f %f %f %f\n", *(mxGetPr(result)), *(mxGetPr(result)+1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/
	if (engEvalString(ep, "p = 0.85")) {
		fprintf(stderr, "\nError setting p = 0.85\n");
		system("pause");
		exit(1);
	}
	/*Display p
	result = NULL;
	result = (engGetVariable(ep, "p"));
	printf("p is %f\n", *(mxGetPr(result)));
	*/
	if (engEvalString(ep, "zerocolumns = find(columnsums~=0)")) {
		fprintf(stderr, "\nError setting zerocolumns");
		system("pause");
		exit(1);
	}
	/*Dsiplay zerocolumns
	result = NULL;
	result = (engGetVariable(ep, "zerocolumns"));
	printf("zerocolumns vector is %f %f %f %f %f %f\n", *(mxGetPr(result)), *(mxGetPr(result) + 1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/
	if (engEvalString(ep, "D = sparse(zerocolumns, zerocolumns, 1./columnsums(zerocolumns), dimension, dimension)")) {
		fprintf(stderr, "\nError setting matrix D");
		system("pause");
		exit(1);
	}
	/*Display Diagnol Vector
	result = NULL;
	result = (engGetVariable(ep, "D"));
	printf("Diagnol vector is:\n%f \n%f \n%f \n%f \n%f \n%f\n", *(mxGetPr(result)), *(mxGetPr(result) + 1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/

	if (engEvalString(ep, "StochasticMatrix = ConnectivityMatrix * D")) {
		fprintf(stderr, "\nError setting StochasticMatrix");
		system("pause");
		exit(1);
	}
	/*Display StochasticMatrix
	size_t i = 0;
	result = NULL;
	result = (engGetVariable(ep, "StochasticMatrix"));
	printf("\nThe StochasticMatrix is:\n");
	for (i = 0; i < elements; i = i + 6) {
		printf("%f ", *(mxGetPr(result) + i));
		printf("%f ", *(mxGetPr(result) + i + 1));
		printf("%f ", *(mxGetPr(result) + i + 2));
		printf("%f ", *(mxGetPr(result) + i + 3));
		printf("%f ", *(mxGetPr(result) + i + 4));
		printf("%f \n", *(mxGetPr(result) + i + 5));
	}
	*/

	if (engEvalString(ep, "[row, column] = find(columnsums==0)")) {
		fprintf(stderr, "\nError finding row and column");
		system("pause");
		exit(1);
	}

	if (engEvalString(ep, "StochasticMatrix(:, column) = 1./dimension")) {
		fprintf(stderr, "\nError setting zero column of StochasticMatrix");
		system("pause");
		exit(1);
	}
	/*Display Modified StochasticMatrix
	result = NULL;
	result = (engGetVariable(ep, "StochasticMatrix"));
	printf("\nThe Modified StochasticMatrix is:\n");
	for (i = 0; i < elements; i = i + 6) {
		printf("%f ", *(mxGetPr(result) + i));
		printf("%f ", *(mxGetPr(result) + i + 1));
		printf("%f ", *(mxGetPr(result) + i + 2));
		printf("%f ", *(mxGetPr(result) + i + 3));
		printf("%f ", *(mxGetPr(result) + i + 4));
		printf("%f \n", *(mxGetPr(result) + i + 5));
	}
	*/
	if (engEvalString(ep, "Q = ones(dimension, dimension)")) {
		fprintf(stderr, "\nError setting matrix Q");
		system("pause");
		exit(1);
	}
	/*Display Matrix Q
	result = NULL;
	result = (engGetVariable(ep, "Q"));
	printf("\nThe Matrix Q is:\n");
	for (i = 0; i < elements; i = i + 6) {
		printf("%f ", *(mxGetPr(result) + i));
		printf("%f ", *(mxGetPr(result) + i + 1));
		printf("%f ", *(mxGetPr(result) + i + 2));
		printf("%f ", *(mxGetPr(result) + i + 3));
		printf("%f ", *(mxGetPr(result) + i + 4));
		printf("%f \n", *(mxGetPr(result) + i + 5));
	}
	*/
	if (engEvalString(ep, "TransitionMatrix = p * StochasticMatrix + (1 - p) * (Q/dimension)")) {
		fprintf(stderr, "\nError setting TransitionMatrix");
		system("pause");
		exit(1);
	}
	/*Display TransitionMatrix
	result = NULL;
	result = (engGetVariable(ep, "TransitionMatrix"));
	printf("\nThe Transition Matrix is:\n");
	for (i = 0; i < elements; i = i + 6) {
		printf("%f ", *(mxGetPr(result) + i));
		printf("%f ", *(mxGetPr(result) + i + 1));
		printf("%f ", *(mxGetPr(result) + i + 2));
		printf("%f ", *(mxGetPr(result) + i + 3));
		printf("%f ", *(mxGetPr(result) + i + 4));
		printf("%f \n", *(mxGetPr(result) + i + 5));
	}
	*/
	if (engEvalString(ep, "PageRank = ones(dimension, 1)")) {
		fprintf(stderr, "\nError initializing PageRank");
		system("pause");
		exit(1);
	}
	/*Display Initialized PageRank Vector
	result = NULL;
	result = (engGetVariable(ep, "PageRank"));
	printf("Initialized PageRank vector is:\n%f \n%f \n%f \n%f \n%f \n%f\n", *(mxGetPr(result)), *(mxGetPr(result) + 1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/
	if (engEvalString(ep, "for i = 1:100 PageRank = TransitionMatrix * PageRank; end")) {
		fprintf(stderr, "\nError determining final PageRank");
		system("pause");
		exit(1);
	}
	/*Display computed PageRank vector
	result = NULL;
	result = (engGetVariable(ep, "PageRank"));
	printf("Computed PageRank vector is:\n%f \n%f \n%f \n%f \n%f \n%f\n", *(mxGetPr(result)), *(mxGetPr(result) + 1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/
	if (engEvalString(ep, "PageRank = PageRank / sum(PageRank)")) {
		fprintf(stderr, "\nError normalizing PageRank");
		system("pause");
		exit(1);
	}
	/*Display normalized PageRank vector
	result = NULL;
	result = (engGetVariable(ep, "PageRank"));
	printf("Normalized PageRank vector is:\n%f \n%f \n%f \n%f \n%f \n%f\n", *(mxGetPr(result)), *(mxGetPr(result) + 1), *(mxGetPr(result) + 2), *(mxGetPr(result) + 3), *(mxGetPr(result) + 4), *(mxGetPr(result) + 5));
	*/
	//we retrive PageRank and return result to C Project
	printf("\nRetrieving PageRank...\n");
	if ((result = engGetVariable(ep, "PageRank")) == NULL) {
		fprintf(stderr, "\nFailed to retrieve PageRank\n");
		system("pause");
		exit(1);
	}
	//We display PageRank vector
	else {
		 size_t i = 0;
		 size_t node = 1;
		printf("\nThe PageRank vector is:\n\n");
		printf("NODE  RANK\n");
		printf("---   ----\n");
		for (i = 0; i < d; i++) {
			printf("%d     %.4f\n", node, *(mxGetPr(result) + i));
			node++;
		}
	}

	//ensure NULL termination of engEvalString
	if (engOutputBuffer(ep, buffer, BUFSIZE)) {
		fprintf(stderr, "\nCan't create buffer for MATLAB output\n");
		system("pause");
		return 1;
	}
	buffer[BUFSIZE] = '\0';

	//buffer is being cleared and refilled with results of command contained in string passed to engine
	engEvalString(ep, "whos"); // whos is a handy MATLAB command that generates a list of all current variables
	printf("%s\n", buffer);

	//memory is freed and Matlab instance is closed
	mxDestroyArray(ConnectivityMatrix);
	mxDestroyArray(result);
	ConnectivityMatrix = NULL;
	result = NULL;
	if (engClose(ep)) {
		fprintf(stderr, "\nFailed to close MATLAB engine\n");
	}

	return;
}