#include <stdint.h>

extern "C" {
  __attribute__((visibility("default"))) __attribute__((used))
  int factorial(int a){
   if (a > 1) {
          return a * factorial(a - 1);
      } else {
          return 1;
      }
  }
   __attribute__((visibility("default"))) __attribute__((used))
  int sum(int a,int b) {
        return a+b;
  }

}


