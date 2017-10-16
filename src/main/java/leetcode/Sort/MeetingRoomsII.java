package leetcode.Sort;

// Given an array of meeting time intervals consisting of start and end times [[s1,e1],[s2,e2],...] (si < ei),
// find the minimum number of conference rooms required.

// For example,
// Given [[0, 30],[5, 10],[15, 20]],
// return 2.

import java.util.Arrays;

/**
 * Definition for an interval.
 * public class Interval {
 * int start;
 * int end;
 * Interval() { start = 0; end = 0; }
 * Interval(int s, int e) { start = s; end = e; }
 * }
 */

public class MeetingRoomsII {

    public int minMeetingRooms(Interval[] intervals) {

        int[] starts = new int[intervals.length];
        int[] ends = new int[intervals.length];

        for (int i = 0; i < intervals.length; i++) {

            starts[i] = intervals[i].start;
            ends[i] = intervals[i].end;

        }

        Arrays.sort(starts);
        Arrays.sort(ends);
        int rooms = 0;
        int endsItr = 0;

        for (int start : starts) {
            if (start < ends[endsItr]) {
                rooms++;
            } else {
                endsItr++;
            }
        }

        return rooms;

    }

}