#include "leetcode.h"

class Solution {
public:
    int findMin(vector<int> &num) {
        int size = num.size();

        if(size == 0) {
            return 0;
        } else if(size == 1) {
            return num[0];
        } else if(size == 2) {
            return min(num[0], num[1]);
        }

        int start = 0;
        int stop = size - 1;

        while(start < stop - 1) {
            if(num[start] < num[stop]) {
                return num[start];
            }

            int mid = start + (stop - start) / 2;
            if(num[mid] > num[start]) {
                start = mid;
            } else if(num[mid] < num[start]) {
                stop = mid;
            } 
        }

        return min(num[start], num[stop]);
    }
};

int main() {
    Solution sln;

    vector<int> v{1,2,3,4,5,6,7};
    int m = sln.findMin(v);

    cout << m << endl;

    v = vector<int>{4,5,6,7,0,1,2};
    m = sln.findMin(v);

    cout << m << endl;
    return 0;
}