#include "WProgram.h"
#include "Collections.h"
#include "EventLoop.h"
#include "Observable.h"



int main (int argc, char * const argv[]) 
{
    printf("Collections test %s\n",  testCollections()?"Succeeded":"Failed");
    printf("Observable test %s\n", testObservable()?"Succeeded":"Failed");
    printf("Event Loop test %s\n", eventLoopTest()?"Succeeded":"Failed");
    
    return 0;
}
