-- 计算阶乘的函数
function factorial(n)
    if n == 0 then
        return 1
    else
        return n * factorial(n - 1)
    end
end

-- 主程序
for i = 1, 10 do
    print(i .. "! = " .. factorial(i))
end

-- 表操作示例
local numbers = {1, 2, 3, 4, 5}
table.insert(numbers, 6)
print("数组长度: " .. #numbers)