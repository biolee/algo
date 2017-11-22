package ctci.ch_01_arrays_and_strings.Q1_01_Is_Unique;

import java.util.HashMap;
import java.util.Map;

public class Tester {

  public static void main(String[] args) {
    Map<String, Boolean> testCase = new HashMap<String, Boolean>();
    testCase.put("abcde", true);
    testCase.put("hello", false);
    testCase.put("apple", false);
    testCase.put("kite", true);
    testCase.put("padle", true);

    for (Map.Entry<String, Boolean> e : testCase.entrySet()) {
      String word = e.getKey();
      Boolean p = e.getValue();

      boolean wordA = QuestionA.isUniqueChars(word);
      boolean wordB = QuestionB.isUniqueChars(word);

      assert p == wordA;
      assert p == wordB;

      if (wordA == wordB) {
        System.out.println(word + ": " + wordA);
      } else {
        System.out.println(word + ": " + wordA + " vs " + wordB);
      }
    }
  }
}
