# scala 的美丽新世界

# 传参数
Scala拥有两种参数传递的方式：Call-by-Value(按值传递)与Call-by-Name(按名传递)。Call-by-Value避免了参数的重复求值，效率相对较高；而Call-by-Name避免了在函数调用时刻的参数求值，而将求值推延至实际调用点，但有可能造成重复的表达式求值。

两者存在微妙的差异，并应用于不同的场景。本文将阐述两者之间的差异，并重点讨论Call-by-Name的实现模式和应用场景。

基本概念
val与值
def与方法
val与var
val与def
参数传递
按值传递
按名传递
借贷模式
基本概念

val与值

val用于「变量声明」与「值(Value)」定义。例如，pi定义了一个常量，它直接持有Double类型的字面值。

val pi = 3.1415926
val也可以直接定义「函数值(Function Literals)」。例如，max变量定义了一个类型为(Int, Int) => Int的函数值。

val max = (x: Int, y: Int) => Int = if (x > y) x else y
当使用val定义变量时，其引用的对象将被立即求值。max在定义时，它立即对=的右侧表达式进行求值，它直接持有(Int, Int) => Int类型的函数值。上例等价于：

val max = new Function2[Int, Int, Int] {
  def apply(x: Int, y: Int): Int = if (x > y) x else y
}
但是，apply方法并没有立即被求值。直至发生函数调用时才会对apply进行求值。

def与方法

def用于定义「方法(Method)」。例如，max定义了一个(Int, Int)Int的方法，它表示max是一个参数类型为(Int, Int)，返回值类型为Int的方法定义。

def max(x: Int, y: Int): Int = if (x > y) x else y
当使用def定义方法时，其方法体并没有立即被求值。但是，每当调用一次max，方法体将被重复地被求值。

返回函数

可以将上例max方法进行变换，使其返回(Int, Int) => Int的函数值。

def max = (x: Int, y: Int) => if (x > y) x else y
此时，max定义了一个方法，但省略了参数列表，其返回值类型为(Int, Int) => Int。它等价于

def max() = (x: Int, y: Int) => if (x > y) x else y
因为max是一个「无副作用」的方法，按照惯例，可以略去「空参数列表」，即省略max后面的小括号()。一则对外声明无副作用的语义，二则使代码更加简明扼要。

方法与函数

def max(x: Int, y: Int): Int = if (x > y) x else y
def max = (x: Int, y: Int) => if (x > y) x else y
两者都定义为「方法(Method)」，但后者返回了一个函数(Function)类型。因此，后者常常也被习惯地称为「函数(Function)」。

首先，它们两者可以具有相同的调用形式：max(1, 2)。但对于后者，调用过程实际上包括了两个子过程。

首先调用max返回(Int, Int) => Int的实例；
然后再在该函数的实例上调用apply方法，它等价于：
max.apply(1, 2)
其次，两者获取函数值的方式不同。后者可以直接获取到函数值，而对于前者需要执行η扩展才能取得等价的部分应用函数。

val f = max _
此时，f也转变为(Int, Int) => Int的函数类型了。实施上，对于上例，η扩展的过程类似于如下试下。

val f = new (Int, Int) => Int {
  def apply(x: Int, y: Int): Int = max(x, y)
}
val与var

var与val都可以用于定义变量，但两者表示不同的语义。val一旦引用了对象，便不能再次引用其它对象了。

val s1 = "Alice"
s1 = "Bob"   // Error
而var引用变量可以随时改变去引用其它的对象。

var s2 = "Alice"
s2 = "Bob"  // OK
另外，var/val都可以引用不可变(Immutable)类的实例，也可以引用可变(Mutable)类的实例。

val s1 = new StringBuilder  // val可以引用可变类的实例
var s2 = "Alice"            // var也可以引用不可变类的实例
var/val的差异在于引用变量本身的可变性，前者表示引用随时可修改，而后者表示引用不可修改，与它们所引用的对象是否可变无关。

val与def

def用于定义方法，val定义值。对于「返回函数值的方法」与「直接使用val定义的函数值」之间存在微妙的差异，即使它们都定义了相同的逻辑。例如：

val max = (x: Int, y: Int) => if (x > y) x else y 
def max = (x: Int, y: Int) => if (x > y) x else y
语义差异

虽然两者之间仅存在一字之差，但却存在本质的差异。

def用于定义「方法」，而val用于定义「值」。
def定义的方法时，方法体并未被立即求值；而val在定义时，其引用的对象就被立即求值了。
def定义的方法，每次调用方法体就被求值一次；而val仅在定义变量时仅求值一次。
例如，每次使用val定义的max，都是使用同一个函数值；也就是说，如下语句为真。

max eq max   // true
而每次使用def定义的max，都将返回不同的函数值；也就是说，如下语句为假。

max eq max   // false
其中，eq通过比较对象id实现比较对象间的同一性的。

类型参数

val代表了一种饿汉求值的思维，而def代表了一种惰性求值的思维。但是，def具有更好可扩展性，因为它可以支持类型参数。

def max[T : Ordering](x: T, y: T): T = Ordering[T].max(x, y)
lazy惰性

def在定义方法时并不会产生实例，但在每次方法调用时生成不同的实例；而val在定义变量时便生成实例，以后每次使用val定义的变量时，都将得到同一个实例。

lazy的语义介于def与val之间。首先，lazy val与val语义类似，用于定义「值(value)」，包括函数值。

lazy val max = (x: Int, y: Int) => if (x > y) x else y
其次，它又具有def的语义，它不会在定义max时就完成求值。但是，它与def不同，它会在第一次使用max时完成值的定义，对于以后再次使用max将返回相同的函数值。

参数传递

Scala存在两种参数传递的方式。

Pass-by-Value：按值传递
Pass-by-Name：按名传递
按值传递

默认情况下，Scala的参数是按照值传递的。

def and(x: Boolean, y: Boolean) = x && y
对于如下调用语句：

and(false, s.contains("horance"))
表达式s.contains("horance")首先会被立即求值，然后才会传递给参数y；而在and函数体内再次使用y时，将不会再对s.contains("horance")表达式求值，直接获取最先开始被求值的结果。

传递函数

将上例and实现修改一下，让其具有函数类型的参数。

def and(x: () => Boolean, y: () => Boolean) = x() && y()
其中，() => Boolean等价于Function0[Boolean]，表示参数列表为空，返回值为Boolean的函数类型。

调用方法时，传递参数必须显式地加上() =>的函数头。

and(() => false, () => s.contains("horance"))
此时，它等价于如下实现：

and(new Function0[Boolean] { 
  def apply(): Boolean = false
}, new Function0[Boolean] {
  def apply(): Boolean = s.contains("horance")
}
此时，and方法将按照「按值传递」将Function0的两个对象引用分别传递给了x与y的引用变量。但时，此时它们函数体，例如s.contains("horance")，在参数传递之前并没有被求值；直至在and的方法体内，x与y调用了apply方法时才被求值。

也就是说，and方法可以等价实现为：

def and(x: () => Boolean, y: () => Boolean) = x.apply() && y.apply()
按名传递

通过Function0[R]的参数类型，在传递参数前实现了延迟初始化的技术。但实现中，参数传递时必须构造() => R的函数值，并在调用点上显式地加上()完成apply方法的调用，存在很多的语法噪声。

因此，Scala提供了另外一种参数传递的机制：按名传递。按名传递略去了所有()语法噪声。例如，函数实现中，x与y不用显式地加上()便可以完成调用。

def and(x: => Boolean, y: => Boolean) = x && y
其次，调用点用户无需构造() => R的函数值，但它却拥有延迟初始化的功效。

and(false, s.contains("horance"))
借贷模式

资源回收是计算机工程实践中一项重要的实现模式。对于具有GC的程序设计语言，它仅仅实现了内存资源的自动回收，而对于诸如文件IO，数据库连接，Socket连接等资源需要程序员自行实现资源的回收。

该问题可以形式化地描述为：给定一个资源R，并将资源传递给用户空间，并回调算法f: R => T；当过程结束时资源自动释放。

Input: Given resource: R
Output：T
Algorithm：Call back to user namespace: f: R => T, and make sure resource be closed on done.
因此，该实现模式也常常被称为「借贷模式」，是保证资源自动回收的重要机制。本文通过using的抽象控制，透视Scala在这个领域的设计技术，以便巩固「按名传递」技术的应用。

控制抽象：using

import scala.language.reflectiveCalls

object using {
  type Closeable = { def close(): Unit }

  def apply[T <: Closeable, R](resource: => T)(f: T => R): R = {
    var source = null.asInstanceOf[T]
    try {
      source = resource
      f(source)
    } finally {
      if (source != null) source.close
    }
  }
}
客户端

例如如下程序，它读取用户根目录下的README.md文件，并传递给using，using会将文件句柄回调给用户空间，用户实现文件的逐行读取；当读取完成后，using自动关闭文件句柄，释放资源，但用户无需关心这个细节。

import scala.io.Source
import scala.util.Properties

def read: String = using(Source.fromFile(readme)) { 
  _.getLines.mkString(Properties.lineSeparator)
}
鸭子编程

type Closeable = { def close(): Unit }定义了一个Closeable的类型别名，使得T必须是具有close方法的子类型，这是Scala支持「鸭子编程」的一种重要技术。例如，File满足T类型的特征，它具有close方法。

惰性求值

resource: => T是按照by-name传递，在实参传递形参过程中，并未对实参进行立即求值，而将求值推延至resource: => T的调用点。

对于本例，using(Source.fromFile(source))语句中，Source.fromFile(source)并没有马上发生调用并传递给形参，而将求值推延至source = resource语句。
```xml
<build>
  <plugins>
    <plugin>
      <artifactId>maven-assembly-plugin</artifactId>
      <version>2.3</version>
      <configuration>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
      </configuration>
      <executions>
        <execution>
          <id>make-assembly</id> <!-- this is used for inheritance merges -->
          <phase>package</phase> <!--  bind to the packaging phase -->
          <goals>
            <goal>single</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
  </build>
```

```bash
mvn clean compile assembly:single
```

```xml
<dependencies>
  <dependency>
   <groupId>org.scala-lang</groupId>
   <artifactId>scala-library</artifactId>
   <version>2.7.2</version>
  </dependency>
 </dependencies>

 <build>
  <pluginManagement>
   <plugins>
    <plugin>
     <groupId>net.alchim31.maven</groupId>
     <artifactId>scala-maven-plugin</artifactId>
     <version>3.2.1</version>
    </plugin>
    <plugin>
     <groupId>org.apache.maven.plugins</groupId>
     <artifactId>maven-compiler-plugin</artifactId>
     <version>2.0.2</version>
    </plugin>
   </plugins>
  </pluginManagement>
  <plugins>
   <plugin>
    <groupId>net.alchim31.maven</groupId>
    <artifactId>scala-maven-plugin</artifactId>
    <executions>
     <execution>
      <id>scala-compile-first</id>
      <phase>process-resources</phase>
      <goals>
       <goal>add-source</goal>
       <goal>compile</goal>
      </goals>
     </execution>
     <execution>
      <id>scala-test-compile</id>
      <phase>process-test-resources</phase>
      <goals>
       <goal>testCompile</goal>
      </goals>
     </execution>
    </executions>
   </plugin>
   <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <executions>
     <execution>
      <phase>compile</phase>
      <goals>
       <goal>compile</goal>
      </goals>
     </execution>
    </executions>
   </plugin>
  </plugins>
 </build>

```
