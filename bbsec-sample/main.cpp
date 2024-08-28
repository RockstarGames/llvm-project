// This is a temporary file used for testing the functionality of basic block sections
// clang++ -ffunction-sections -fdata-sections -fbasic-block-sections=all -fno-exceptions -fno-unwind-tables -fno-async-exceptions -fno-asynchronous-unwind-tables -fno-omit-frame-pointer -Xclang -triple=x86_64-windows-msvc -g main.cpp -o BasicBlockSections.exe
#include <iostream>

int Sum(int a, int b) { return a + b; }

int GetMax(int a, int b) { 
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

int Power(int a, int b) { 
    int res = 1;
    for (int i = 0; i < b; i++) {
        res = res * a;
    }
    return res;
}

int main() { 
	int a = 1;
    int b = 2;
	std::cout << a << std::endl;
	std::cout << b << std::endl;
    int c = Sum(a, b);
    std::cout << c << std::endl;
    int d = GetMax(a, b);
    std::cout << d << std::endl;
    int e = GetMax(b, a);
    std::cout << e << std::endl;
    int f = Power(3, 3);
    std::cout << f << std::endl;
    return 0;
}