package leetcode.Array;

import org.junit.Test;

import java.util.HashMap;

import static org.junit.Assert.assertArrayEquals;

public class GameOfLifeTest {
    @Test
    public void gameOfLife() throws Exception {
        HashMap<int[][], int[][]> testCase = new HashMap<int[][], int[][]>();
        for (int i = 0; i < 10; i++) {
            testCase.put(new int[][]{{0, 0, 0}, {0, 0, 0}}, new int[][]{{0, 0, 0}, {0, 0, 0}});
        }

        for (int[][] k : testCase.keySet()) {
            int[][] v = testCase.get(k);
            GameOfLife.gameOfLife(k);
            assertArrayEquals(k, v);
        }
    }
}