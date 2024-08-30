/***********************************************************************
**
**  REBOL [R3] Language Interpreter and Run-time Environment
**
**  Copyright 2012 REBOL Technologies
**  Copyright 2012-2024 Rebol Open Source Developers
**  REBOL is a trademark of REBOL Technologies
**
**  Licensed under the Apache License, Version 2.0 (the "License");
**  you may not use this file except in compliance with the License.
**  You may obtain a copy of the License at
**
**  http://www.apache.org/licenses/LICENSE-2.0
**
**  Unless required by applicable law or agreed to in writing, software
**  distributed under the License is distributed on an "AS IS" BASIS,
**  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
**  See the License for the specific language governing permissions and
**  limitations under the License.
**
************************************************************************
**
**  Title: Device: System access (using libuv)
**  Author: Oldes
**  Purpose: Poll default libuv loop
**
************************************************************************
**
**  NOTE to PROGRAMMERS:
**
**    1. Keep code clear and simple.
**    2. Document unusual code, reasoning, or gotchas.
**    3. Use same style for code, vars, indent(4), comments, etc.
**    4. Keep in mind Linux, OS X, BSD, big/little endian CPUs.
**    5. Test everything, then test it again.
**
***********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "reb-host.h"
#include "host-lib.h"
#include "uv.h"


/***********************************************************************
**
*/	DEVICE_CMD Open_SYSTEM(REBREQ *sock)
/*
***********************************************************************/
{
	puts("Open_SYSTEM");
	SET_OPEN(sock);
	return DR_DONE;
}


/***********************************************************************
**
*/	DEVICE_CMD Close_SYSTEM(REBREQ *sock)
/*
**		Note: valid even if not open.
**
***********************************************************************/
{
	puts("Close_SYSTEM");
	SET_CLOSED(sock);
	return DR_DONE; // Removes it from device's pending list (if needed)
}


/***********************************************************************
**
*/	DEVICE_CMD Read_SYSTEM(REBREQ *sock)
/*
**
***********************************************************************/
{
	return DR_DONE;
}


/***********************************************************************
**
*/	DEVICE_CMD Poll_SYSTEM(REBREQ *dr)
/*
**
***********************************************************************/
{
	printf("P");
	return DR_DONE;
}


/***********************************************************************
**
**	Command Dispatch Table (RDC_ enum order)
**
***********************************************************************/

static DEVICE_CMD_FUNC Dev_Cmds[RDC_MAX] =
{
	0, //Init_Net,	// Shared init - called only once
	0, //Quit_Net,	// Shared
	Open_SYSTEM,
	Close_SYSTEM,
	0, // Read_SYSTEM,
	0,	// write
	Poll_SYSTEM,
};

DEFINE_DEV(Dev_System, "SYSTEM", 1, Dev_Cmds, RDC_MAX, sizeof(REBREQ));
