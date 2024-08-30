
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define OS_LIB_TABLE		// include the host-lib dispatch table

#include "reb-host.h"		// standard host include files
#include "host-lib.h"		// OS host library (dispatch table)


// Host bare-bones stdio functs:
extern REBREQ *Open_StdIO(REBOOL cgi);
extern void Close_StdIO(void);
extern void Put_Str(REBYTE *buf);
extern REBYTE *Get_Str(void);



//extern REB_NORETURN void OS_Exit(int code);  
//extern void *OS_Make(size_t size);    // src/os/posix/host-lib.c
//extern void  OS_Free(void *mem);    // src/os/posix/host-lib.c

REBARGS Main_Args;

REBOL_HOST_LIB *Host_Lib;

int main(int argc, char **argv) {
	REBYTE vers[8];
	REBREQ *std_io = NULL;
	int res;

	Parse_Args(argc, (REBCHR **)argv, &Main_Args);
	Main_Args.options |= RO_QUIET;

	vers[0] = 5; // len
	RL_Version(&vers[0]);
	printf("Hello libRebol version: %i.%i.%i\n", vers[1], vers[2], vers[3]);

	Host_Lib = &Host_Lib_Init;
	Host_Lib->std_io = Open_StdIO(0);
	res = RL_Init(&Main_Args, Host_Lib);
	if(res!=0) {
		printf("init failed: %i\n", res);
		return res;
	}
	//

	//RXIARG arg;
	//puts("RL_Start");
	res = RL_Start(0, 0, 0);

	puts("do string..");
	RL_Do_String("ls . \n reverse {olleh}\n", 0, 0);
	RL_Print_TOS(TRUE, "");

	OS_Exit(0);
	return 0;
}


