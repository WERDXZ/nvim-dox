#include <iostream>

int test(){
	return 0;
}

template<typename T, typename M>
decltype(auto) getT(T t, M m){
	m+t;
	return t;
}

int add(int a, int b){
	return a+b;
}

class T{};

struct M{};

template<typename T>
class t{};

template<typename M>
struct m{};
