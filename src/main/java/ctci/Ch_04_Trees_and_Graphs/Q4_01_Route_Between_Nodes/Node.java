package ctci.Ch_04_Trees_and_Graphs.Q4_01_Route_Between_Nodes;

class Node {
  public int adjacentCount;
  public Question.State state;
  private Node adjacent[];
  private String vertex;

  public Node(String vertex, int adjacentLength) {
    this.vertex = vertex;
    adjacentCount = 0;
    adjacent = new Node[adjacentLength];
  }

  public void addAdjacent(Node x) {
    if (adjacentCount < adjacent.length) {
      this.adjacent[adjacentCount] = x;
      adjacentCount++;
    } else {
      System.out.print("No more adjacent can be added");
    }
  }

  public Node[] getAdjacent() {
    return adjacent;
  }

  public String getVertex() {
    return vertex;
  }
}
