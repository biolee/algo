package leetcode.DepthFirstSearch;

// Given a binary tree, find its maximum depth.

// The maximum depth is the number of nodes along the longest path from the root node down to the
// farthest leaf node.

import leetcode.util.TreeNode;

/**
 * Definition for a binary tree node. public class TreeNode { int val; TreeNode left; TreeNode
 * right; TreeNode(int x) { val = x; } }
 */
public class maximumDepthOfABinaryTree {

  public int maxDepth(TreeNode root) {

    if (root == null) return 0;

    return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
  }
}
