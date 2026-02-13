short var1 = 3;
short var2 = 2;
short res1 = 0;

byte busy = 0;

proctype Thread1() {
    (busy == 0) -> busy++;

    var1++;
    var2++;

    busy--;
}

proctype Thread2() {
    (busy == 0) -> busy++;
    
    var1++;
    res1 = var1 + var2;

    busy--;
}

init {
    run Thread1();
    run Thread2();
}