#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    char *  a = "ho";

    if(strncmp(a,"hell",4)==0){
        printf("Yes!\n");
    } else {
        printf("No!\n");
    }
    return 0;
}