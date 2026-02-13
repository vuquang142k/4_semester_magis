short var1 = 3;
short var2 = 2;
short res1 = 0;

byte mutex = 0;

proctype Thread1() {
    atomic {
        if
        :: mutex < 1 ->
            mutex++;
            var1++;
            var2++;
            mutex--;
        fi
    }
}

proctype Thread2() {
    atomic {
        if
        :: mutex < 1 ->
            mutex++;
            res1 = var1 + var2;
            mutex--;
        fi
    }
}

init {
    atomic {
        run Thread1();
        run Thread2();
    }
}