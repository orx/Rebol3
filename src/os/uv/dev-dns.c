/***********************************************************************
**
**  REBOL [R3] Language Interpreter and Run-time Environment
**
**  Copyright 2012 REBOL Technologies
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
**  Title: Device: DNS access
**  Author: Carl Sassenrath
**  Purpose: Calls local DNS services for domain name lookup.
**  Notes:
**      See MS WSAAsyncGetHost* details regarding multiple requests.
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
#include "sys-net.h"
#include "uv.h"

static uv_loop_t * dns_sync_loop;


void on_addr_resolved(uv_getaddrinfo_t *resolver, int err, struct addrinfo *res) {
	//printf("\n== %s\n", __func__);
	REBREQ *req = (REBREQ*)resolver->data;
	if (!err) {
		struct sockaddr_in *ai_addr = (struct sockaddr_in*)res->ai_addr;
		req->net.remote_ip = ai_addr->sin_addr.s_addr;
	} else {
		req->error = err;
		//fprintf(stderr, "getaddrinfo callback error %s\n", uv_err_name(err));
	}
	SET_FLAG(req->flags, RRF_DONE);
	//free(resolver);
}

void on_name_resolved(uv_getnameinfo_t *resolver, int err, const char* hostname, const char* service) {
	//printf("\n== %s %s\n", __func__, hostname);
	REBREQ *req = (REBREQ*)resolver->data;
	if (!err) {
		req->data = hostname;
	} else {
		req->error = err;
		//fprintf(stderr, "getnameinfo callback error %s\n", uv_err_name(err));
	}
	SET_FLAG(req->flags, RRF_DONE);
	//free(resolver);
}


/***********************************************************************
**
*/	DEVICE_CMD Init_DNS(REBREQ *dr)
/*
***********************************************************************/
{
	REBDEV *dev = (REBDEV*)dr; // just to keep compiler happy

	dns_sync_loop = (uv_loop_t*)OS_Make(sizeof(uv_loop_t));
	uv_loop_init(dns_sync_loop);
	SET_FLAG(dev->flags, RDF_INIT);
	return DR_DONE;
}

/***********************************************************************
**
*/	DEVICE_CMD Quit_DNS(REBREQ *dr)
/*
***********************************************************************/
{
	REBDEV *dev = (REBDEV*)dr; // just to keep compiler happy
	uv_loop_close(dns_sync_loop);
	OS_Free(dns_sync_loop);
	dns_sync_loop = NULL;

	CLR_FLAG(dev->flags, RDF_INIT);
	return DR_DONE;
}

/***********************************************************************
**
*/	DEVICE_CMD Open_DNS(REBREQ *sock)
/*
***********************************************************************/
{
	SET_OPEN(sock);

	return DR_DONE;
}


/***********************************************************************
**
*/	DEVICE_CMD Close_DNS(REBREQ *sock)
/*
**		Note: valid even if not open.
**
***********************************************************************/
{
	puts("Close_DNS");
	// Terminate a pending request:
#ifdef HAS_ASYNC_DNS
	if (GET_FLAG(sock->flags, RRF_PENDING)) {
		CLR_FLAG(sock->flags, RRF_PENDING);
		if (sock->handle) WSACancelAsyncRequest(sock->handle);
	}
#endif
	if (sock->net.host_info) OS_Free(sock->net.host_info);
	sock->net.host_info = 0;
	sock->handle = 0;
	SET_CLOSED(sock);
	return DR_DONE; // Removes it from device's pending list (if needed)
}


/***********************************************************************
**
*/	DEVICE_CMD Read_DNS(REBREQ *sock)
/*
**		Initiate the GetHost request and return immediately.
**		Note the temporary results buffer (must be freed later).
**
***********************************************************************/
{
	void *host = NULL;
	uv_loop_t *loop;
	uv_getaddrinfo_t *addr_resolver = NULL;
	uv_getnameinfo_t *name_resolver = NULL;
	struct addrinfo hints;
	struct sockaddr_in addr;
	int err;

	loop = IS_OPEN(sock) ? uv_default_loop() : dns_sync_loop;

	//TODO: keep info in the sock (REBREQ), that the port still used, so it is not release by GC!
	//Keep allocated resolvers in a linked list?

	//puts("Read_DNS");
	if (GET_FLAG(sock->modes, RST_REVERSE)) {
		uv_getnameinfo_t *name_resolver = (uv_getnameinfo_t*)OS_Make(sizeof(uv_getnameinfo_t));
		name_resolver->data = (void*)sock;

		addr.sin_family = AF_INET;
		addr.sin_addr.s_addr = sock->net.remote_ip;

		err = uv_getnameinfo(loop, name_resolver, on_name_resolved, (const struct sockaddr*)&addr, 0);

		if (err) {
			fprintf(stderr, "getaddrinfo call error %s\n", uv_err_name(err));
			goto error;
		}
	}
	else if (sock->data == NULL) {
		puts("gethostname");
		host = OS_Make(MAXGETHOSTSTRUCT); // be sure to free it
		sock->net.host_info = host; // stores allocated buffer, deallocated on close or on error
		if(0 == gethostname(host, MAXGETHOSTSTRUCT)) {
			sock->data = host;
			SET_FLAG(sock->modes, RST_REVERSE);
			SET_FLAG(sock->flags, RRF_DONE);
			return DR_DONE;
		}
		goto error;
	} else {
		addr_resolver = (uv_getaddrinfo_t*)OS_Make(sizeof(uv_getaddrinfo_t));
		addr_resolver->data = (void*)sock;

		//puts("gethostbyname");
		hints.ai_family = PF_INET;
		hints.ai_socktype = SOCK_STREAM;
		hints.ai_protocol = IPPROTO_TCP;
		hints.ai_flags = 0;

		err = uv_getaddrinfo(loop, addr_resolver, on_addr_resolved, sock->data, NULL, &hints);
		if (err) {
			fprintf(stderr, "getaddrinfo call error %s\n", uv_err_name(err));
			goto error;
		}
	}
	if (loop == dns_sync_loop) {
		//puts("dns_loop runs");
		uv_run(loop, UV_RUN_DEFAULT);
		//puts("dns_loop ends");
		return DR_DONE;
	} else {
		//req->net.host_info = (addr_resolver)? addr_resolver : name_resolver;
		return DR_PEND; // keep it on pending list
	}

error:
	if (host) OS_Free(host);
	if (addr_resolver) OS_Free(addr_resolver);
	if (name_resolver) OS_Free(name_resolver);
	sock->error = err;
	//OS_Signal_Device(sock, EVT_ERROR);
	return DR_ERROR; // Remove it from pending list
}


/***********************************************************************
**
*/	DEVICE_CMD Poll_DNS(REBREQ *dr)
/*
**		Check for completed DNS requests. These are marked with
**		RRF_DONE by the windows message event handler (dev-event.c).
**		Completed requests are removed from the pending queue and
**		event is signalled (for awake dispatch).
**
***********************************************************************/
{
	REBDEV *dev = (REBDEV*)dr;  // to keep compiler happy
	REBREQ **prior = &dev->pending;
	REBREQ *req;
	REBOOL change = FALSE;

	//printf("\n== %s %s\n", __func__);

	// Scan the pending request list:
	for (req = *prior; req; req = *prior) {

		// If done or error, remove command from list:
		if (GET_FLAG(req->flags, RRF_DONE)) { // req->error may be set
			*prior = req->next;
			req->next = 0;
			CLR_FLAG(req->flags, RRF_PENDING);
			OS_Signal_Device(req, req->error ? EVT_ERROR : EVT_READ);
			change = TRUE;
		}
		else prior = &req->next;
	}

	return change;
}


/***********************************************************************
**
**	Command Dispatch Table (RDC_ enum order)
**
***********************************************************************/

static DEVICE_CMD_FUNC Dev_Cmds[RDC_MAX] =
{
	Init_DNS,
	Quit_DNS,
	Open_DNS,
	Close_DNS,
	Read_DNS,
	0,	// write
	Poll_DNS,
};

DEFINE_DEV(Dev_DNS, "DNS", 1, Dev_Cmds, RDC_MAX, 0);
