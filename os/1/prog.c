#include<stdio.h>
#include<stdlib.h>
#inlclude<unistd.h>
int main(){
  while(1){
    int p = fork();
    if(p==0){
      exit(0);
    }
  }
}
