package leetcode.Array;

import org.junit.Test;

import static org.junit.Assert.*;

public class BestTimeToBuyAndSellStockTest {
    @Test
    public void maxProfit() throws Exception {
        int maxProfit = BestTimeToBuyAndSellStock.maxProfit(new int[]{7, 1, 5, 3, 6, 4});
        assertEquals(maxProfit,5);

        maxProfit = BestTimeToBuyAndSellStock.maxProfit(new int[]{7, 6, 4, 3, 1});
        assertEquals(maxProfit,0);
    }

}