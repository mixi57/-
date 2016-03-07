#include <iostream>

using namespace std;
int main(int argc, char *argv[]) {
	int n = 7;
	int a[] = {1, 2, 1, 2, 1, 2, 7};
	
	int tolVal = 0;
	int gatherValue = 0;
	for (int i = 1; i <= n; i++) {
		tolVal += a[i];
	}
	int num = n / 3 + 1;
//	printf("num %d\n", num);
	for (int i = 0; i < num; i++) {
//		printf("i %d ga %d  %d\n", gatherValue, a[i], i);
		gatherValue += a[i];
		if (i < num - 1) {
			for (int j = i + 1; j < n; j++) {
				bool trueValue = true;
				int k = 0;
				for (; k <= i; k ++) {
//					printf("kkk %d ", k);
					if(a[k] == a[j]){
						trueValue = false;
						break;
					}
				}
				if (trueValue) {
//					printf("ijji %d %d \n", i, j);
					if (j != i + 1){
						int temp = a[j];
						a[j] = a[k];
						a[k] = temp;
//						printf("$$$ %d %d %d %d\n", i, j, a[i], a[j]);
					}
					break;
				}
			}
		}
	}
	printf("ga %d to %d\n", gatherValue, tolVal);
	printf("%d",  (3 * gatherValue - tolVal) / 2);
	
}