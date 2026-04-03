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
	case 3: // STATE 1 - lab.pml:28 - [(run Thread1())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!(addproc(II, 1, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - lab.pml:29 - [(run Thread2())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!(addproc(II, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - lab.pml:30 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Thread2 */
	case 6: // STATE 1 - lab.pml:18 - [((busy==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		if (!((((int)now.busy)==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 2 - lab.pml:18 - [busy = (busy+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		(trpt+1)->bup.oval = ((int)now.busy);
		now.busy = (((int)now.busy)+1);
#ifdef VAR_RANGES
		logval("busy", ((int)now.busy));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 3 - lab.pml:19 - [assert((busy>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][3] = 1;
		spin_assert((((int)now.busy)>1), "(busy>1)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 4 - lab.pml:21 - [var1 = (var1+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][4] = 1;
		(trpt+1)->bup.oval = now.var1;
		now.var1 = (now.var1+1);
#ifdef VAR_RANGES
		logval("var1", now.var1);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 5 - lab.pml:22 - [res1 = (var1+var2)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		(trpt+1)->bup.oval = res1;
		res1 = (now.var1+now.var2);
#ifdef VAR_RANGES
		logval("res1", res1);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 6 - lab.pml:24 - [busy = (busy-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][6] = 1;
		(trpt+1)->bup.oval = ((int)now.busy);
		now.busy = (((int)now.busy)-1);
#ifdef VAR_RANGES
		logval("busy", ((int)now.busy));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 7 - lab.pml:25 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][7] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Thread1 */
	case 13: // STATE 1 - lab.pml:8 - [((busy==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (!((((int)now.busy)==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 2 - lab.pml:8 - [busy = (busy+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = ((int)now.busy);
		now.busy = (((int)now.busy)+1);
#ifdef VAR_RANGES
		logval("busy", ((int)now.busy));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 3 - lab.pml:9 - [assert((busy>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		spin_assert((((int)now.busy)>1), "(busy>1)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 4 - lab.pml:11 - [var1 = (var1+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		(trpt+1)->bup.oval = now.var1;
		now.var1 = (now.var1+1);
#ifdef VAR_RANGES
		logval("var1", now.var1);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 5 - lab.pml:12 - [var2 = (var2+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		(trpt+1)->bup.oval = now.var2;
		now.var2 = (now.var2+1);
#ifdef VAR_RANGES
		logval("var2", now.var2);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 18: // STATE 6 - lab.pml:14 - [busy = (busy-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][6] = 1;
		(trpt+1)->bup.oval = ((int)now.busy);
		now.busy = (((int)now.busy)-1);
#ifdef VAR_RANGES
		logval("busy", ((int)now.busy));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 19: // STATE 7 - lab.pml:15 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][7] = 1;
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

