#include <stdio.h>
#include <math.h>
#include "stdlib.h"
int getBitNum(int data){
	if(data == 0)
		return 1;
	int num = 0;
	int bit = floor(data / 10);
	while (bit != 0) {
		num++;
		bit = floor(bit / 10);
	}
	return num + 1;
}

int* getBitValue(int data){
	int* gather = malloc(sizeof(int) * 10) ;
	memset(gather, -1, sizeof(int) * 10);

	int index = 0;
	int bit = data;
	int nextBit = floor(data / 10);
	while (nextBit != 0) {
		gather[index++] = bit % 10;
		bit = nextBit;
		nextBit = floor(nextBit / 10);
	}
	//printf("bit = %d", bit);
	gather[index++] = bit % 10;
	gather[index++] = -1;
	return gather;
}
int main(int argc, char *argv[]) {
	srand((unsigned)time(NULL));
	int value = rand()%10000 + 1;
	printf("value %d", value);
	
	int valueGather[10];
	memset(valueGather, 0, sizeof(int) * 10);
	
	for (int i =1; i <= value; i++) {
		int* bitNumGather = getBitValue(i);
		int index = 0;
		int bitNum = bitNumGather[index];
//		printf("\ni %d", i);
		while (bitNum != -1) {
//			printf(" %d ", bitNum);
			valueGather[bitNum]++; 
			bitNum = bitNumGather[++index];
		}
	}
	
	for (int i = 0; i < 10; i++) {
		printf("\n value %d num %d", i, valueGather[i]);
	}
}