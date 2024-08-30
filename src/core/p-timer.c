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
**  Module:  p-timer.c
**  Summary: timer port interface (using libuv)
**  Section: ports
**  Author:  Oldes
**  Note:
**		Keep reference of the timer port if you want to keep it alive.
**		If port is released by GC, the timer will be stopped automatically.
**
***********************************************************************/
/*
	General idea of usage:

	t: open [scheme: 'timer timeout: repeat: 0.5] ;; will wake up every half a second
	t/awake: func [event] [print "timer!"]        ;; will be evaluated on time
	wait 1                                        ;; process any events
	print 'close
	close t                                       ;; close the timer
	wait 1                                        ;; no timer events there
	print 'restart
	open t                                        ;; restarted the timer
	wait 1                                        ;; there should be 2 timer events again
	wait 1                                        ;; and again...
	t: none                                       ;; port is not referenced anymore!
	wait 1                                        ;; but still active untill it is released by GC!
	print 'recycle
	loop 2 [recycle recycle]                      ;; the timer port should be released!
	wait 1                                        ;; there should not be processed any timer events
	print 'done
*/

#include "sys-core.h"
#include "reb-evtypes.h"


static void on_timer(uv_timer_t* handle) {
	//printf("== %s\n", __func__);
	REBREQ *req = (REBREQ*)handle->data;
	CLR_FLAG(req->flags, RRF_PENDING);
	SET_FLAG(req->flags, RRF_DONE);
	OS_SIGNAL_DEVICE(req, EVT_TIME);
}


/***********************************************************************
**
*/	static int Event_Actor(REBVAL *ds, REBVAL *port_value, REBCNT action)
/*
***********************************************************************/
{
	REBSER *port;
	REBVAL *spec;
	REBVAL *handle;
	REBREQ *req;
	REBVAL *val;
	REBU64 timeout = 0;
	REBU64 repeat = 0;
	REQ_TIMER *state;
	uv_timer_t *timer;
	//puts("Timer Event_Actor");

	port = Validate_Port_Value(port_value);
	handle = Use_Port_State_Handle(port, RDI_SYSTEM, SYM_UV_TIMER_REQUEST);
	state = (REQ_TIMER*)VAL_HANDLE_CONTEXT_DATA(handle);

	req   = &state->req;
	timer = &state->timer;

	switch (action) {

	case A_OPEN:
		spec = OFV(port, STD_PORT_SPEC);
		if (IS_OBJECT(spec)) {
			val = Obj_Value(spec, STD_PORT_SPEC_TIMER_TIMEOUT);
			if (IS_INTEGER(val) && VAL_INT64(val) > 0) timeout = VAL_UNT64(val)*1000;
			else if (IS_DECIMAL(val) && VAL_DECIMAL(val) > 0) timeout = (REBU64)(VAL_DECIMAL(val)*1000);
			else if (IS_TIME(val) && VAL_TIME(val) > 0) timeout = (REBU64)(VAL_TIME(val) * 0.000001);

			val = Obj_Value(spec, STD_PORT_SPEC_TIMER_REPEAT);
			if (IS_INTEGER(val) && VAL_INT64(val) > 0) repeat = VAL_UNT64(val)*1000;
			else if (IS_DECIMAL(val) && VAL_DECIMAL(val) > 0) repeat = (REBU64)(VAL_DECIMAL(val)*1000);
			else if (IS_TIME(val) && VAL_TIME(val) > 0) repeat = (REBU64)(VAL_TIME(val) * 0.000001);
		}
		if ( IS_OPEN(req)) {
			if (timeout || repeat) {
				uv_timer_stop(timer);
				uv_timer_start(timer, on_timer, timeout, repeat);
			}
		}
		else {
			uv_timer_init(uv_default_loop(), timer);
			timer->data = req; // reference to Rebol port
			if (timeout || repeat) {
				//printf("timeout: %llu repeat: %llu\n", timeout, repeat);
				uv_timer_start(timer, on_timer, timeout, repeat);
			}
			SET_OPEN(req);
		}
		break;

	case A_OPENQ:
		return IS_OPEN(req) ? R_TRUE : R_FALSE;

	case A_CLOSE:
		if (IS_OPEN(req)) {
			uv_timer_stop(timer);
			SET_CLOSED(req);
		}
		break;

//TODO: A_MODIFY, A_QUERY ?

	case A_UPDATE:
		return R_NONE;

	default:
		Trap_Action(REB_PORT, action);
	}
	return R_ARG1;
}

static int UV_Timer_Release(void* handle) {
	//printf("UV_Timer_release: %llx\n", (unsigned long)(uintptr_t)handle);
	REQ_TIMER *state = (REQ_TIMER*)handle;
	uv_timer_stop(&state->timer);
}


/***********************************************************************
**
*/	void Init_Timer_Scheme(void)
/*
***********************************************************************/
{
	//puts("Init timer");
	REBHSP spec;
	CLEARS(&spec);
	spec.size      = sizeof(REQ_TIMER);
	spec.free      = UV_Timer_Release;
	Register_Handle_Spec(SYM_UV_TIMER_REQUEST, &spec);

	Register_Scheme(SYM_TIMER, 0, Event_Actor);
}
