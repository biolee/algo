package leetcode.String;

public class palindromePermutation {

    public boolean canPermutePalindrome(String s) {

        char[] characters = new char[256];

        for (int i = 0; i < s.length(); i++) {

            characters[s.charAt(i)]++;

        }

        int oddCount = 0;

        for (char character : characters) {

            if (!(character % 2 == 0)) {

                oddCount++;

                if (oddCount > 1) {

                    return false;

                }

            }

        }

        return true;

    }

}