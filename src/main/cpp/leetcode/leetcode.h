#pragma once

#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include <string.h>
#include <deque>
#include <map>
#include <set>
#include <limits>
#include <list>
#include <unordered_map>
#include <unordered_set>
#include <initializer_list>
#include <ctype.h>
#include <limits.h>

using namespace std;

struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x): val(x), next(NULL) {}
};


void printListNode(ListNode* a) {
    cout << "list nodes: ";
    while(a) {
        cout << a->val << "\t";
        a = a->next;
    }   
    cout << endl;
}

ListNode* createListNode(const vector<int>& v) {
    ListNode dummy(0);
    ListNode* p = &dummy;

    for(int i = 0; i < v.size(); i++) {
        p->next = new ListNode(v[i]);
        p = p->next;
    }

    return dummy.next;
}

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

struct RandomListNode {
    int label;
    RandomListNode *next, *random;
    RandomListNode(int x) : label(x), next(NULL), random(NULL) {}
};

struct UndirectedGraphNode {
    int label;
    vector<UndirectedGraphNode *> neighbors;
    UndirectedGraphNode(int x) : label(x) {};
};

struct TreeLinkNode {
    int val;
    TreeLinkNode *left;
    TreeLinkNode *right;
    TreeLinkNode *next;
    TreeLinkNode(int x) : val(x), left(NULL), right(NULL), next(NULL) {}
};

template<typename T>
void printVector(const vector<T>& a) {
    for(int i = 0; i < a.size(); i++) {
        cout << a[i] << "\t";
    }

    cout << endl;
}

template<typename T>
void printVector2(const vector<vector<T> >& a) {
    for(int i = 0; i < a.size(); i++) {
        printVector(a[i]);    
    }
}

struct Interval {
    int start;
    int end;
    Interval() : start(0), end(0) {}
    Interval(int s, int e) : start(s), end(e) {}
};