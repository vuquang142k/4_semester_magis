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
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC check_triangle_type */
;
		;
		;
		;
		
	case 7: // STATE 5
		;
		((P0 *)_this)->c = trpt->bup.ovals[2];
		((P0 *)_this)->a = trpt->bup.ovals[1];
		((P0 *)_this)->_1_1_1_tmp = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;
;
		;
		
	case 9: // STATE 10
		;
		((P0 *)_this)->c = trpt->bup.ovals[2];
		((P0 *)_this)->b = trpt->bup.ovals[1];
		((P0 *)_this)->_1_1_2_tmp = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 10: // STATE 16
		;
	/* 2 */	((P0 *)_this)->c = trpt->bup.ovals[2];
	/* 1 */	((P0 *)_this)->b = trpt->bup.ovals[1];
	/* 0 */	((P0 *)_this)->a = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 11: // STATE 18
		;
	/* 2 */	((P0 *)_this)->c = trpt->bup.ovals[2];
	/* 1 */	((P0 *)_this)->b = trpt->bup.ovals[1];
	/* 0 */	((P0 *)_this)->a = trpt->bup.ovals[0];
		;
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;
;
		;
		;
		;
		
	case 14: // STATE 29
		;
		p_restor(II);
		;
		;
		goto R999;
	}

