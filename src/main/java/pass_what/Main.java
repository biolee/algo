package pass_what;

public class Main {
  public static void pass_pointer(A p1, A p2) {
    p1.v = "changed";
    p2 = new A("changed");
  }

  public static void main(String[] a) {
    {
      A a1 = new A("unchanged");
      A a2 = new A("unchanged");

      pass_pointer(a1, a2);

      System.out.println(a1.v); // changed
      System.out.println(a2.v); // unchanged
    }
  }

  static class A {
    String v;

    A(String s) {
      v = s;
    }
  }
}
