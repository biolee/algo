#include <string>
#include <iostream>

using namespace std;

struct A {
	string v;
};

void pass_value(A p1,A p2){
	p1.v = "changed";
    p2 = A{.v="changed"};
}

void pass_pointer(A* p1,A* p2){
	p1->v = "changed";
    p2 = new A{.v="changed"};
}

void pass_reference(A& p1,A& p2){
	A* p2_temp = new A{.v="changed"};

	p1.v = "changed";
    p2 = *p2_temp;
}

int main(){

	{
		A a1 = A{.v="unchanged"};
		A a2 = A{.v="unchanged"};
		pass_value(a1,a2);
		cout << "pass_value p1 " << a1.v << endl; // unchanged
	    cout << "pass_value p2 " << a2.v << endl; // unchanged
    }

	{
	    A a1 = A{.v="unchanged"};
	    A a2 = A{.v="unchanged"};
	    pass_pointer(&a1,&a2);
	    cout << "pass_pointer p1 " << a1.v << endl; // changed
	    cout << "pass_pointer p2 " << a2.v << endl; // unchanged
	}

	{
		A a1_temp = A{.v="unchanged"};
        A a2_temp = A{.v="unchanged"};
        A& a1 = a1_temp;
        A& a2 = a2_temp;
        pass_reference(a1,a2);
        cout << "pass_pointer p1 " << a1.v << endl; // changed
        cout << "pass_pointer p2 " << a2.v << endl; // changed
	}
}