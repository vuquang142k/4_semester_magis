	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 4: // STATE 2
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 5: // STATE 4
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Server */

	case 6: // STATE 1
		;
		XX = 1;
		unrecv(now.client_to_server, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.client_to_server, XX-1, 1, ((P1 *)_this)->msg_type, 0);
		((P1 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 7: // STATE 2
		;
	/* 0 */	((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 8: // STATE 4
		;
		_m = unsend(now.server_to_client);
		;
		goto R999;

	case 9: // STATE 7
		;
		XX = 1;
		unrecv(now.client_to_server, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.client_to_server, XX-1, 1, ((P1 *)_this)->msg_type, 0);
		((P1 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 10: // STATE 8
		;
	/* 0 */	((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 11: // STATE 10
		;
		_m = unsend(now.server_to_client);
		;
		goto R999;
;
		
	case 12: // STATE 13
		goto R999;

	case 13: // STATE 14
		;
		XX = 1;
		unrecv(now.client_to_server, XX-1, 0, ((P1 *)_this)->received_data, 1);
		unrecv(now.client_to_server, XX-1, 1, ((P1 *)_this)->msg_type, 0);
		((P1 *)_this)->received_data = trpt->bup.ovals[0];
		((P1 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 14: // STATE 15
		;
	/* 0 */	((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 15: // STATE 17
		;
		_m = unsend(now.server_to_client);
		;
		goto R999;

	case 16: // STATE 18
		;
		XX = 1;
		unrecv(now.client_to_server, XX-1, 0, ((P1 *)_this)->received_data, 1);
		unrecv(now.client_to_server, XX-1, 1, ((P1 *)_this)->msg_type, 0);
		((P1 *)_this)->received_data = trpt->bup.ovals[0];
		((P1 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 17: // STATE 19
		;
	/* 0 */	((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 18: // STATE 21
		;
		_m = unsend(now.server_to_client);
		;
		goto R999;

	case 19: // STATE 22
		;
		_m = unsend(now.server_to_client);
		;
		goto R999;

	case 20: // STATE 27
		;
		XX = 1;
		unrecv(now.client_to_server, XX-1, 0, 0, 1);
		unrecv(now.client_to_server, XX-1, 1, ((P1 *)_this)->msg_type, 0);
		((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 21: // STATE 28
		;
	/* 0 */	((P1 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 22: // STATE 32
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Client */
;
		;
		
	case 24: // STATE 2
		;
		_m = unsend(now.client_to_server);
		;
		goto R999;

	case 25: // STATE 3
		;
		XX = 1;
		unrecv(now.server_to_client, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.server_to_client, XX-1, 1, ((P0 *)_this)->msg_type, 0);
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 26: // STATE 4
		;
	/* 0 */	((P0 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 27: // STATE 6
		;
		_m = unsend(now.client_to_server);
		;
		goto R999;

	case 28: // STATE 12
		;
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		((P0 *)_this)->seq_num = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 29: // STATE 13
		;
		_m = unsend(now.client_to_server);
		;
		goto R999;

	case 30: // STATE 14
		;
		((P0 *)_this)->data = trpt->bup.oval;
		;
		goto R999;

	case 31: // STATE 15
		;
		XX = 1;
		unrecv(now.server_to_client, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.server_to_client, XX-1, 1, ((P0 *)_this)->msg_type, 0);
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 32: // STATE 16
		;
	/* 0 */	((P0 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 33: // STATE 25
		;
		XX = 1;
		unrecv(now.server_to_client, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.server_to_client, XX-1, 1, ((P0 *)_this)->msg_type, 0);
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 34: // STATE 26
		;
	/* 0 */	((P0 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;
;
		
	case 35: // STATE 30
		goto R999;

	case 36: // STATE 31
		;
		_m = unsend(now.client_to_server);
		;
		goto R999;

	case 37: // STATE 32
		;
		XX = 1;
		unrecv(now.server_to_client, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.server_to_client, XX-1, 1, ((P0 *)_this)->msg_type, 0);
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 38: // STATE 33
		;
	/* 0 */	((P0 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;

	case 39: // STATE 37
		;
		XX = 1;
		unrecv(now.server_to_client, XX-1, 0, trpt->bup.ovals[0], 1);
		unrecv(now.server_to_client, XX-1, 1, ((P0 *)_this)->msg_type, 0);
		((P0 *)_this)->msg_type = trpt->bup.ovals[1];
		;
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 40: // STATE 38
		;
	/* 0 */	((P0 *)_this)->msg_type = trpt->bup.oval;
		;
		;
		goto R999;
;
		
	case 41: // STATE 42
		goto R999;

	case 42: // STATE 43
		;
		_m = unsend(now.client_to_server);
		;
		goto R999;

	case 43: // STATE 44
		;
		p_restor(II);
		;
		;
		goto R999;
	}

