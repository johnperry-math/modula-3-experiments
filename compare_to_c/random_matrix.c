#include <stdio.h>
#include <stdlib.h>
#include <time.h>

unsigned long M[20][40];

int main() {
  for (unsigned long k = 0; k < 1000000000; ++k)
    M[k % 20][k % 40] = k;
  for (unsigned i = 0; i < 20; ++i) {
    printf("[ ");
    for (unsigned j = 0; j < 40; ++j) {
      printf("%d", M[i][j]);
      if (j < 39) printf(", ");
    }
    printf(" ]\n");
  }
}
