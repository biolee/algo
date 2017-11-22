package leetcode.LinkedList; // Reverse a singly linked list.

import leetcode.util.ListNode;

/**
 * Definition for singly-linked list. public class ListNode { int val; ListNode next; ListNode(int
 * x) { val = x; } }
 */
public class reverseLinkedList {

  public ListNode reverseList(ListNode head) {

    if (head == null) return head;

    ListNode newHead = null;

    while (head != null) {

      ListNode next = head.next;
      head.next = newHead;
      newHead = head;
      head = next;
    }

    return newHead;
  }
}
