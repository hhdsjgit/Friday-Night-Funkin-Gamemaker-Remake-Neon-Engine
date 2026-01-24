// Converted from Lua to GML
// Some manual adjustments may be needed

 //  计算阶乘的函数
    function factorial(n) {
        if (n == 0) {
        return 1;
        else;
        return n * factorial(n - 1);
    }
}

 //  主程序
    for (var i = 1; i <= 10; i += ) {
    show_debug_message(i + "! = " + factorial(i));
}

 //  表操作示例
var numbers = [1, 2, 3, 4, 5];
array_push(numbers, 6);
show_debug_message("数组长度: " + array_lengthnumbers);