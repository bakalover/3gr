#include <stdio.h>
#define SIZE 15

typedef int (*ptr)(int, int, int);

int *createInitializedVector(int size) {
  int *vector = (int *)malloc(size * sizeof(int));
  if (vector != NULL) {
    for (int i = 0; i < size; i++) {
      vector[i] = 0;
    }
  }
  return vector;
  ptr a;
}

int main() {

  int vec[SIZE];

  for (int i = 0; i < SIZE; i++) {
    vec[i] = i;
  }

  int *ptrAdd = vec + 0x7 + 6;
  int *ptrSub = ptrAdd - 2;
  int cmp = ptrSub < vec;

  printf("%d", cmp);
}