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
	case 3: // STATE 1 - triangle.pml:32 - [(run check_triangle_type(3,4,5))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		if (!(addproc(II, 1, 0, 3, 4, 5)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - triangle.pml:33 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC check_triangle_type */
	case 5: // STATE 1 - triangle.pml:4 - [(((((a+b)>c)&&((a+c)>b))&&((b+c)>a)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (!(((((((P0 *)_this)->a+((P0 *)_this)->b)>((P0 *)_this)->c)&&((((P0 *)_this)->a+((P0 *)_this)->c)>((P0 *)_this)->b))&&((((P0 *)_this)->b+((P0 *)_this)->c)>((P0 *)_this)->a))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 2 - triangle.pml:7 - [(((a>b)&&(a>c)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (!(((((P0 *)_this)->a>((P0 *)_this)->b)&&(((P0 *)_this)->a>((P0 *)_this)->c))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 3 - triangle.pml:9 - [tmp = a] (0:22:3 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->_1_1_1_tmp;
		((P0 *)_this)->_1_1_1_tmp = ((P0 *)_this)->a;
#ifdef VAR_RANGES
		logval("check_triangle_type:tmp", ((P0 *)_this)->_1_1_1_tmp);
#endif
		;
		/* merge: a = c(22, 4, 22) */
		reached[0][4] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->a;
		((P0 *)_this)->a = ((P0 *)_this)->c;
#ifdef VAR_RANGES
		logval("check_triangle_type:a", ((P0 *)_this)->a);
#endif
		;
		/* merge: c = tmp(22, 5, 22) */
		reached[0][5] = 1;
		(trpt+1)->bup.ovals[2] = ((P0 *)_this)->c;
		((P0 *)_this)->c = ((P0 *)_this)->_1_1_1_tmp;
#ifdef VAR_RANGES
		logval("check_triangle_type:c", ((P0 *)_this)->c);
#endif
		;
		/* merge: .(goto)(0, 15, 22) */
		reached[0][15] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 8: // STATE 7 - triangle.pml:12 - [(((b>a)&&(b>c)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][7] = 1;
		if (!(((((P0 *)_this)->b>((P0 *)_this)->a)&&(((P0 *)_this)->b>((P0 *)_this)->c))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 8 - triangle.pml:14 - [tmp = b] (0:22:3 - 1)
		IfNotBlocked
		reached[0][8] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->_1_1_2_tmp;
		((P0 *)_this)->_1_1_2_tmp = ((P0 *)_this)->b;
#ifdef VAR_RANGES
		logval("check_triangle_type:tmp", ((P0 *)_this)->_1_1_2_tmp);
#endif
		;
		/* merge: b = c(22, 9, 22) */
		reached[0][9] = 1;
		(trpt+1)->bup.ovals[1] = ((P0 *)_this)->b;
		((P0 *)_this)->b = ((P0 *)_this)->c;
#ifdef VAR_RANGES
		logval("check_triangle_type:b", ((P0 *)_this)->b);
#endif
		;
		/* merge: c = tmp(22, 10, 22) */
		reached[0][10] = 1;
		(trpt+1)->bup.ovals[2] = ((P0 *)_this)->c;
		((P0 *)_this)->c = ((P0 *)_this)->_1_1_2_tmp;
#ifdef VAR_RANGES
		logval("check_triangle_type:c", ((P0 *)_this)->c);
#endif
		;
		/* merge: .(goto)(0, 15, 22) */
		reached[0][15] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 10: // STATE 16 - triangle.pml:22 - [((((a*a)+(b*b))==(c*c)))] (29:0:3 - 1)
		IfNotBlocked
		reached[0][16] = 1;
		if (!((((((P0 *)_this)->a*((P0 *)_this)->a)+(((P0 *)_this)->b*((P0 *)_this)->b))==(((P0 *)_this)->c*((P0 *)_this)->c))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: a */  (trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->a;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->a = 0;
		if (TstOnly) return 1; /* TT */
		/* dead 1: b */  (trpt+1)->bup.ovals[1] = ((P0 *)_this)->b;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->b = 0;
		if (TstOnly) return 1; /* TT */
		/* dead 1: c */  (trpt+1)->bup.ovals[2] = ((P0 *)_this)->c;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->c = 0;
		/* merge: printf('a\\n')(0, 17, 29) */
		reached[0][17] = 1;
		Printf("a\n");
		/* merge: .(goto)(0, 23, 29) */
		reached[0][23] = 1;
		;
		/* merge: .(goto)(0, 28, 29) */
		reached[0][28] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 11: // STATE 18 - triangle.pml:23 - [((((a*a)+(b*b))>(c*c)))] (29:0:3 - 1)
		IfNotBlocked
		reached[0][18] = 1;
		if (!((((((P0 *)_this)->a*((P0 *)_this)->a)+(((P0 *)_this)->b*((P0 *)_this)->b))>(((P0 *)_this)->c*((P0 *)_this)->c))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: a */  (trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P0 *)_this)->a;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->a = 0;
		if (TstOnly) return 1; /* TT */
		/* dead 1: b */  (trpt+1)->bup.ovals[1] = ((P0 *)_this)->b;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->b = 0;
		if (TstOnly) return 1; /* TT */
		/* dead 1: c */  (trpt+1)->bup.ovals[2] = ((P0 *)_this)->c;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)_this)->c = 0;
		/* merge: printf('Остроугольный треугольник\\n')(0, 19, 29) */
		reached[0][19] = 1;
		Printf("Остроугольный треугольник\n");
		/* merge: .(goto)(0, 23, 29) */
		reached[0][23] = 1;
		;
		/* merge: .(goto)(0, 28, 29) */
		reached[0][28] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 12: // STATE 21 - triangle.pml:24 - [printf('Тупоугольный треугольник\\n')] (0:0:0 - 1)
		IfNotBlocked
		reached[0][21] = 1;
		Printf("Тупоугольный треугольник\n");
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 26 - triangle.pml:27 - [printf('Это не треугольник\\n')] (0:0:0 - 1)
		IfNotBlocked
		reached[0][26] = 1;
		Printf("Это не треугольник\n");
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 29 - triangle.pml:29 - [-end-] (0:0:0 - 6)
		IfNotBlocked
		reached[0][29] = 1;
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

