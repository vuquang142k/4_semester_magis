short var1 = 3;
short var2 = 2;
short res1 = 0;

proctype Thread1() {
    var1++;
    var2++;
}

proctype Thread2() {
    res1 = var1 + var2;
}

init {
    run Thread1();
    run Thread2();

    printf("Result: res1 = %d\n", res1)
}