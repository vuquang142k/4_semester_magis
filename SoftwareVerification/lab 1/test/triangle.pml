proctype check_triangle_type(int a, b, c){
    // Проверка на существование треугольник
    if 
    :: (a + b > c && a + c > b && b + c > a) -> {
        // Сортируем стороны, чтобы С всегда была самой большой
        if 
        :: (a > b && a > c) -> {
            int tmp = a;
            a = c;
            c = tmp;
        }
        :: (b > a && b > c) -> {
            int tmp = b;
            b = c;
            c = tmp;
        }
        :: else -> skip;
        fi;

        // Проверка типа треугольник
        if 
        :: (a * a + b * b == c * c) -> printf("Прямоугольный треугольник\n");
        :: (a * a + b * b > c * c) -> printf("Остроугольный треугольник\n");
        :: else -> printf("Тупоугольный треугольник\n");
        fi;
    }
    :: else -> printf("Это не треугольник\n");
    fi;
}

init{
    run check_triangle_type(3, 4, 5);
}