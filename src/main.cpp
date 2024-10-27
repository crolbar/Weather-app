#include <iostream>
#include "./util.cpp"


int main() {
    std::string resp = fetch("https://jsonplaceholder.typicode.com/todos/1");

    std::cout << resp + "\n";

    return 0;
}
