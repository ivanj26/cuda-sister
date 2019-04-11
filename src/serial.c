#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include "util.h"

/**
 * Reference: https://www.geeksforgeeks.org/radix-sort/
*/

int getMax(int* arr, int n) {
	int max = arr[0];
	for (int i = 1; i < n; i++) {
		if (arr[i] > max) {
			max = arr[i];
		}
	}

	return max;
}

void countSort(int* arr, int n, int exp) {
    int* output = malloc(n * sizeof(int));
    int i, count[10] = {0}; 
   
    for (i = 0; i < n; i++) {
        count[ (arr[i]/exp)%10 ]++; 
    }

    for (i = 1; i < 10; i++) {
        count[i] += count[i - 1]; 
    }
  
    for (i = n - 1; i >= 0; i--) { 
        output[count[ (arr[i]/exp)%10 ] - 1] = arr[i]; 
        count[ (arr[i]/exp)%10 ]--; 
    }
  
    for (i = 0; i < n; i++) {
        arr[i] = output[i]; 
    }
}

void radixSort(int* arr, int n) {
    int max = getMax(arr, n); 
  
    for (int exp = 1; max/exp > 0; exp *= 10) {
    	countSort(arr, n, exp); 
    }
}

int main (int argc, char* argv[]) {
	clock_t beginTime;
	clock_t endTime;
	int seedCount = strtol(argv[1], NULL, 10);
	int* arr = malloc(seedCount * sizeof(int));

	rng(arr, seedCount, 13516104);

	// Serial execution.
	beginTime = clock();
	radixSort(arr, seedCount);
	endTime = clock();
	printf("Serial Exec Time: ");
	printExecTime(beginTime, endTime);
}