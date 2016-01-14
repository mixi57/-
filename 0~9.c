#include <stdio.h>
#include <math.h>
#include "stdlib.h"

int* getBitValue(int data){
	int* gather = malloc(sizeof(int) * 10);
	memset(gather, -1, sizeof(int) * 10);

	int index = 0;
	int bit = data;
	int nextBit = floor(data / 10);
	while (nextBit != 0) {
		gather[index++] = bit % 10;
		bit = nextBit;
		nextBit = floor(nextBit / 10);
	}

	gather[index++] = bit % 10;
	return gather;
}
int main(int argc, char *argv[]) {
	srand((unsigned)time(NULL));
	int value = rand()%10000 + 1;//3401;//1234;//21;//99;//10;//123;//100;//1000;//3401;//
	printf("value %d\n", value);	
	
	int valueGather[10];
	memset(valueGather, 0, sizeof(int) * 10);
	
	int* bitValue = getBitValue(value);
	//数字位数
	int bit = 0;
	while (bitValue[bit] >= 0) {
		bit++;
	}

	// 把前面满的先算了
	if (bit > 1) {
		for (int i = 1; i < bit; i++) {
			int zeroAddNum = i == 1 ? 0 : 9 * pow(10, i - 2) * (i - 1);
			valueGather[0] += zeroAddNum;
			for (int j = 1; j < 10; j++) {
				valueGather[j] += zeroAddNum + pow(10, i - 1); 
			}
		}
	} 

	// 开始算后面的
	const int num = bit;
	int frontGather[num];
	memset(frontGather, 0, sizeof(int) * num);
	int frontIndex = 0;
	while (bit > 1) {
		// 
		int v = bitValue[bit - 1];
		int i = bit == num ? 1 : 0;

		while (i < v) {
			int otherAddNum = pow(10, bit - 2) * (bit - 1);
			for (int index = 0; index <= 9; index++) {
				valueGather[index] += otherAddNum + (i == index ? pow(10, bit - 1) : 0); 
			}
			i++;
		}
		if (frontIndex > 0 && v > 0) {
			for (int i = 0; i < frontIndex; i++) {
				valueGather[frontGather[i]] += (pow(10, bit -1) * v);
			}
		}
		bit--;
		frontGather[frontIndex++] = v;
	}

	//个位数
	int v = bitValue[0];

	for (int i = 1; i <= v; i++) {
		valueGather[i] += 1;
	}
	if(num > 1)
		valueGather[0] += 1;

	if (frontIndex > 0) {
		for (int i = 0; i < frontIndex; i++) {
			valueGather[frontGather[i]] += (v + 1);
		}
	}

	for (int i = 0; i < 10; i++) {
		printf("\n value %d num %d", i, valueGather[i]);
	}
	return 0;
}