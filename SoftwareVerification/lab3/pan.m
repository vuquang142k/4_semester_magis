#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - lab.pml:110 - [(run Client())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!(addproc(II, 1, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - lab.pml:111 - [(run Server())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!(addproc(II, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 4 - lab.pml:113 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][4] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Server */
	case 6: // STATE 1 - lab.pml:70 - [client_to_server?_,msg_type] (0:0:2 - 1)
		reached[1][1] = 1;
		if (q_len(now.client_to_server) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.client_to_server, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P1 *)_this)->msg_type;
		;
		qrecv(now.client_to_server, XX-1, 0, 0);
		((P1 *)_this)->msg_type = qrecv(now.client_to_server, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Server:msg_type", ((P1 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.client_to_server);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 7: // STATE 2 - lab.pml:72 - [((msg_type==SYN))] (4:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((P1 *)_this)->msg_type==3)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->msg_type = 0;
		/* merge: printf('The server receives a SYN from the client and sends a SYN_ACK in response\\n')(0, 3, 4) */
		reached[1][3] = 1;
		Printf("The server receives a SYN from the client and sends a SYN_ACK in response\n");
		_m = 3; goto P999; /* 1 */
	case 8: // STATE 4 - lab.pml:74 - [server_to_client!0,SYN_ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[1][4] = 1;
		if (q_full(now.server_to_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.server_to_client);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 2); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server_to_client, 0, 0, 2, 2);
		_m = 2; goto P999; /* 0 */
	case 9: // STATE 7 - lab.pml:77 - [client_to_server?_,msg_type] (0:0:2 - 2)
		reached[1][7] = 1;
		if (q_len(now.client_to_server) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.client_to_server, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P1 *)_this)->msg_type;
		;
		qrecv(now.client_to_server, XX-1, 0, 0);
		((P1 *)_this)->msg_type = qrecv(now.client_to_server, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Server:msg_type", ((P1 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.client_to_server);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 10: // STATE 8 - lab.pml:79 - [((msg_type==ACK))] (10:0:1 - 1)
		IfNotBlocked
		reached[1][8] = 1;
		if (!((((P1 *)_this)->msg_type==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->msg_type = 0;
		/* merge: printf('The server receives an ACK from the client\\n')(0, 9, 10) */
		reached[1][9] = 1;
		Printf("The server receives an ACK from the client\n");
		_m = 3; goto P999; /* 1 */
	case 11: // STATE 10 - lab.pml:81 - [server_to_client!0,ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[1][10] = 1;
		if (q_full(now.server_to_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.server_to_client);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server_to_client, 0, 0, 4, 2);
		_m = 2; goto P999; /* 0 */
	case 12: // STATE 13 - lab.pml:84 - [printf('The server is waiting for data\\n')] (0:14:0 - 2)
		IfNotBlocked
		reached[1][13] = 1;
		Printf("The server is waiting for data\n");
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 14 - lab.pml:85 - [client_to_server?received_data,msg_type] (0:0:2 - 1)
		reached[1][14] = 1;
		if (q_len(now.client_to_server) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->received_data;
		(trpt+1)->bup.ovals[1] = ((P1 *)_this)->msg_type;
		;
		((P1 *)_this)->received_data = qrecv(now.client_to_server, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Server:received_data", ((P1 *)_this)->received_data);
#endif
		;
		((P1 *)_this)->msg_type = qrecv(now.client_to_server, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Server:msg_type", ((P1 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.client_to_server);
		sprintf(simtmp, "%d", ((P1 *)_this)->received_data); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 14: // STATE 15 - lab.pml:88 - [((msg_type==DATA))] (17:0:1 - 1)
		IfNotBlocked
		reached[1][15] = 1;
		if (!((((P1 *)_this)->msg_type==5)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->msg_type = 0;
		/* merge: printf('The server receives data %d and sends an ACK back to the client\\n',received_data)(0, 16, 17) */
		reached[1][16] = 1;
		Printf("The server receives data %d and sends an ACK back to the client\n", ((P1 *)_this)->received_data);
		_m = 3; goto P999; /* 1 */
	case 15: // STATE 17 - lab.pml:90 - [server_to_client!0,ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[1][17] = 1;
		if (q_full(now.server_to_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.server_to_client);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server_to_client, 0, 0, 4, 2);
		_m = 2; goto P999; /* 0 */
	case 16: // STATE 18 - lab.pml:91 - [client_to_server?received_data,msg_type] (0:0:2 - 1)
		reached[1][18] = 1;
		if (q_len(now.client_to_server) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->received_data;
		(trpt+1)->bup.ovals[1] = ((P1 *)_this)->msg_type;
		;
		((P1 *)_this)->received_data = qrecv(now.client_to_server, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Server:received_data", ((P1 *)_this)->received_data);
#endif
		;
		((P1 *)_this)->msg_type = qrecv(now.client_to_server, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Server:msg_type", ((P1 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.client_to_server);
		sprintf(simtmp, "%d", ((P1 *)_this)->received_data); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 17: // STATE 19 - lab.pml:93 - [((msg_type==FIN_ACK))] (21:0:1 - 1)
		IfNotBlocked
		reached[1][19] = 1;
		if (!((((P1 *)_this)->msg_type==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->msg_type = 0;
		/* merge: printf('The server receives a FIN_ACK from the client and sends an ACK and a FIN_ACK to the client\\n')(0, 20, 21) */
		reached[1][20] = 1;
		Printf("The server receives a FIN_ACK from the client and sends an ACK and a FIN_ACK to the client\n");
		_m = 3; goto P999; /* 1 */
	case 18: // STATE 21 - lab.pml:95 - [server_to_client!0,ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[1][21] = 1;
		if (q_full(now.server_to_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.server_to_client);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server_to_client, 0, 0, 4, 2);
		_m = 2; goto P999; /* 0 */
	case 19: // STATE 22 - lab.pml:96 - [server_to_client!0,FIN_ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[1][22] = 1;
		if (q_full(now.server_to_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.server_to_client);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server_to_client, 0, 0, 1, 2);
		_m = 2; goto P999; /* 0 */
	case 20: // STATE 27 - lab.pml:100 - [client_to_server?0,msg_type] (0:0:1 - 3)
		reached[1][27] = 1;
		if (q_len(now.client_to_server) == 0) continue;

		XX=1;
		if (0 != qrecv(now.client_to_server, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
		;
		((P1 *)_this)->msg_type = qrecv(now.client_to_server, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Server:msg_type", ((P1 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.client_to_server);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 21: // STATE 28 - lab.pml:103 - [((msg_type==ACK))] (32:0:1 - 1)
		IfNotBlocked
		reached[1][28] = 1;
		if (!((((P1 *)_this)->msg_type==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P1 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->msg_type = 0;
		/* merge: printf('The server received an ACK from the client and is shutting down\\n')(0, 29, 32) */
		reached[1][29] = 1;
		Printf("The server received an ACK from the client and is shutting down\n");
		/* merge: .(goto)(0, 31, 32) */
		reached[1][31] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 22: // STATE 32 - lab.pml:106 - [-end-] (0:0:0 - 2)
		IfNotBlocked
		reached[1][32] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Client */
	case 23: // STATE 1 - lab.pml:14 - [printf('The client sends a SYN.\\n')] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		Printf("The client sends a SYN.\n");
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 2 - lab.pml:15 - [client_to_server!data,SYN] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (q_full(now.client_to_server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.client_to_server);
		sprintf(simtmp, "%d", ((P0 *)_this)->data); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.client_to_server, 0, ((P0 *)_this)->data, 3, 2);
		_m = 2; goto P999; /* 0 */
	case 25: // STATE 3 - lab.pml:17 - [server_to_client?_,msg_type] (0:0:2 - 1)
		reached[0][3] = 1;
		if (q_len(now.server_to_client) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.server_to_client, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		;
		qrecv(now.server_to_client, XX-1, 0, 0);
		((P0 *)_this)->msg_type = qrecv(now.server_to_client, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server_to_client);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 26: // STATE 4 - lab.pml:19 - [((msg_type==SYN_ACK))] (6:0:1 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		if (!((((P0 *)_this)->msg_type==2)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P0 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		/* merge: printf('The client receives a SYN-ACK from the server and sends an ACK in response.\\n')(0, 5, 6) */
		reached[0][5] = 1;
		Printf("The client receives a SYN-ACK from the server and sends an ACK in response.\n");
		_m = 3; goto P999; /* 1 */
	case 27: // STATE 6 - lab.pml:21 - [client_to_server!0,ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[0][6] = 1;
		if (q_full(now.client_to_server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.client_to_server);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.client_to_server, 0, 0, 4, 2);
		_m = 2; goto P999; /* 0 */
	case 28: // STATE 9 - lab.pml:25 - [((seq_num<2))] (13:0:3 - 1)
		IfNotBlocked
		reached[0][9] = 1;
		if (!((((P0 *)_this)->seq_num<2)))
			continue;
		/* merge: printf('The client sends data %d\\n',data)(13, 10, 13) */
		reached[0][10] = 1;
		Printf("The client sends data %d\n", ((P0 *)_this)->data);
		/* merge: seq_num = (seq_num+1)(13, 11, 13) */
		reached[0][11] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->seq_num;
		((P0 *)_this)->seq_num = (((P0 *)_this)->seq_num+1);
#ifdef VAR_RANGES
		logval("Client:seq_num", ((P0 *)_this)->seq_num);
#endif
		;
		/* merge: msg_type = DATA(13, 12, 13) */
		reached[0][12] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		((P0 *)_this)->msg_type = 5;
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: msg_type */  
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		_m = 3; goto P999; /* 3 */
	case 29: // STATE 13 - lab.pml:29 - [client_to_server!data,DATA] (0:0:0 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		if (q_full(now.client_to_server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.client_to_server);
		sprintf(simtmp, "%d", ((P0 *)_this)->data); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 5); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.client_to_server, 0, ((P0 *)_this)->data, 5, 2);
		_m = 2; goto P999; /* 0 */
	case 30: // STATE 14 - lab.pml:30 - [data = (data+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][14] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->data;
		((P0 *)_this)->data = (((P0 *)_this)->data+1);
#ifdef VAR_RANGES
		logval("Client:data", ((P0 *)_this)->data);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 31: // STATE 15 - lab.pml:31 - [server_to_client?_,msg_type] (0:0:2 - 1)
		reached[0][15] = 1;
		if (q_len(now.server_to_client) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.server_to_client, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		;
		qrecv(now.server_to_client, XX-1, 0, 0);
		((P0 *)_this)->msg_type = qrecv(now.server_to_client, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server_to_client);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 32: // STATE 16 - lab.pml:33 - [((msg_type==ACK))] (22:0:1 - 1)
		IfNotBlocked
		reached[0][16] = 1;
		if (!((((P0 *)_this)->msg_type==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P0 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		/* merge: printf('The client receives an ACK from the server\\n')(0, 17, 22) */
		reached[0][17] = 1;
		Printf("The client receives an ACK from the server\n");
		/* merge: .(goto)(0, 19, 22) */
		reached[0][19] = 1;
		;
		/* merge: .(goto)(0, 23, 22) */
		reached[0][23] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 33: // STATE 25 - lab.pml:41 - [server_to_client?_,msg_type] (0:0:2 - 3)
		reached[0][25] = 1;
		if (q_len(now.server_to_client) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.server_to_client, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		;
		qrecv(now.server_to_client, XX-1, 0, 0);
		((P0 *)_this)->msg_type = qrecv(now.server_to_client, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server_to_client);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 34: // STATE 26 - lab.pml:43 - [((msg_type==ACK))] (31:0:1 - 1)
		IfNotBlocked
		reached[0][26] = 1;
		if (!((((P0 *)_this)->msg_type==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P0 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		/* merge: printf('The client receives an ACK from the server\\n')(31, 27, 31) */
		reached[0][27] = 1;
		Printf("The client receives an ACK from the server\n");
		/* merge: .(goto)(31, 29, 31) */
		reached[0][29] = 1;
		;
		/* merge: printf('The client sends a FIN_ACK to the server\\n')(31, 30, 31) */
		reached[0][30] = 1;
		Printf("The client sends a FIN_ACK to the server\n");
		_m = 3; goto P999; /* 3 */
	case 35: // STATE 30 - lab.pml:47 - [printf('The client sends a FIN_ACK to the server\\n')] (0:31:0 - 2)
		IfNotBlocked
		reached[0][30] = 1;
		Printf("The client sends a FIN_ACK to the server\n");
		_m = 3; goto P999; /* 0 */
	case 36: // STATE 31 - lab.pml:48 - [client_to_server!0,FIN_ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[0][31] = 1;
		if (q_full(now.client_to_server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.client_to_server);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.client_to_server, 0, 0, 1, 2);
		_m = 2; goto P999; /* 0 */
	case 37: // STATE 32 - lab.pml:50 - [server_to_client?_,msg_type] (0:0:2 - 1)
		reached[0][32] = 1;
		if (q_len(now.server_to_client) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.server_to_client, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		;
		qrecv(now.server_to_client, XX-1, 0, 0);
		((P0 *)_this)->msg_type = qrecv(now.server_to_client, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server_to_client);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 38: // STATE 33 - lab.pml:52 - [((msg_type==ACK))] (37:0:1 - 1)
		IfNotBlocked
		reached[0][33] = 1;
		if (!((((P0 *)_this)->msg_type==4)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P0 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		/* merge: printf('The client received an ACK from the server\\n')(0, 34, 37) */
		reached[0][34] = 1;
		Printf("The client received an ACK from the server\n");
		/* merge: .(goto)(0, 36, 37) */
		reached[0][36] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 39: // STATE 37 - lab.pml:56 - [server_to_client?_,msg_type] (0:0:2 - 2)
		reached[0][37] = 1;
		if (q_len(now.server_to_client) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = qrecv(now.server_to_client, XX-1, 0, 0);
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->msg_type;
		;
		qrecv(now.server_to_client, XX-1, 0, 0);
		((P0 *)_this)->msg_type = qrecv(now.server_to_client, XX-1, 1, 1);
#ifdef VAR_RANGES
		logval("Client:msg_type", ((P0 *)_this)->msg_type);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server_to_client);
		sprintf(simtmp, "%d", ((int)_)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)_this)->msg_type); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 40: // STATE 38 - lab.pml:58 - [((msg_type==FIN_ACK))] (43:0:1 - 1)
		IfNotBlocked
		reached[0][38] = 1;
		if (!((((P0 *)_this)->msg_type==1)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: msg_type */  (trpt+1)->bup.oval = ((P0 *)_this)->msg_type;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->msg_type = 0;
		/* merge: printf('The client received a FIN_ACK from the server\\n')(43, 39, 43) */
		reached[0][39] = 1;
		Printf("The client received a FIN_ACK from the server\n");
		/* merge: .(goto)(43, 41, 43) */
		reached[0][41] = 1;
		;
		/* merge: printf('The client sends the final ACK to the server and terminates its operation\\n')(43, 42, 43) */
		reached[0][42] = 1;
		Printf("The client sends the final ACK to the server and terminates its operation\n");
		_m = 3; goto P999; /* 3 */
	case 41: // STATE 42 - lab.pml:62 - [printf('The client sends the final ACK to the server and terminates its operation\\n')] (0:43:0 - 2)
		IfNotBlocked
		reached[0][42] = 1;
		Printf("The client sends the final ACK to the server and terminates its operation\n");
		_m = 3; goto P999; /* 0 */
	case 42: // STATE 43 - lab.pml:63 - [client_to_server!0,ACK] (0:0:0 - 1)
		IfNotBlocked
		reached[0][43] = 1;
		if (q_full(now.client_to_server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.client_to_server);
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.client_to_server, 0, 0, 4, 2);
		_m = 2; goto P999; /* 0 */
	case 43: // STATE 44 - lab.pml:64 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][44] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

