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

	case 5: // STATE 3
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Thread2 */
;
		;
		
	case 7: // STATE 2
		;
		now.busy = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 9: // STATE 4
		;
		now.var1 = trpt->bup.oval;
		;
		goto R999;

	case 10: // STATE 5
		;
		res1 = trpt->bup.oval;
		;
		goto R999;

	case 11: // STATE 6
		;
		now.busy = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 7
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Thread1 */
;
		;
		
	case 14: // STATE 2
		;
		now.busy = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 16: // STATE 4
		;
		now.var1 = trpt->bup.oval;
		;
		goto R999;

	case 17: // STATE 5
		;
		now.var2 = trpt->bup.oval;
		;
		goto R999;

	case 18: // STATE 6
		;
		now.busy = trpt->bup.oval;
		;
		goto R999;

	case 19: // STATE 7
		;
		p_restor(II);
		;
		;
		goto R999;
	}

