package leetcode.Tree;

// Given a binary algo.search tree and a node in it, find the in-order successor of that node in the
// BST.

// Note: If the given node has no in-order successor in the tree, return null.

import leetcode.util.TreeNode;

/**
 * Definition for a binary tree node. public class TreeNode { int val; TreeNode left; TreeNode
 * right; TreeNode(int x) { val = x; } }
 */
public class inorderSuccessorInBST {

  public TreeNode inorderSuccessor(TreeNode root, TreeNode p) {

    TreeNode successor = null;

    while (root != null) {

      if (p.val < root.val) {

        successor = root;
        root = root.left;

      } else {

        root = root.right;
      }
    }

    return successor;
  }
}
