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
	case 3: // STATE 1 - lab.pml:15 - [(run Thread1())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!(addproc(II, 1, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - lab.pml:16 - [(run Thread2())] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!(addproc(II, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - lab.pml:18 - [printf('Result: res1 = %d\\n',res1)] (0:0:0 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		Printf("Result: res1 = %d\n", res1);
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - lab.pml:19 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][4] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Thread2 */
	case 7: // STATE 1 - lab.pml:11 - [res1 = (var1+var2)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		(trpt+1)->bup.oval = res1;
		res1 = (now.var1+now.var2);
#ifdef VAR_RANGES
		logval("res1", res1);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 2 - lab.pml:12 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Thread1 */
	case 9: // STATE 1 - lab.pml:6 - [var1 = (var1+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = now.var1;
		now.var1 = (now.var1+1);
#ifdef VAR_RANGES
		logval("var1", now.var1);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 2 - lab.pml:7 - [var2 = (var2+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = now.var2;
		now.var2 = (now.var2+1);
#ifdef VAR_RANGES
		logval("var2", now.var2);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 3 - lab.pml:8 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][3] = 1;
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

