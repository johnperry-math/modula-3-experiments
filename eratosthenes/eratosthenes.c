#include <stdio.h>
#include <math.h>

#define FIRSTNUM 2
#define LASTNUM  1000001

int main() {

  int a[LASTNUM];
  int n = LASTNUM - 2;
  
  for (int i = FIRSTNUM; i < LASTNUM; ++i) a[i] = 1;

  int b = (int )sqrt(LASTNUM) + 1;
  for (int i = FIRSTNUM; i < b; ++i)
    if (a[i]) {
      //printf("%d ", i);
      for (int j = i*i; j < LASTNUM; j += i) {
        if (a[j]) {
          a[j] = 0;
          n -= 1;
        }
      }
    }
  //for (int i = b; i < LASTNUM; ++i)
  //  if (a[i]) printf("%d ", i);

  printf("There are %d primes from 2 to %d\n", n, LASTNUM - 1);

}