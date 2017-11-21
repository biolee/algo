
--------- Style Guide -------

# Message And Field Names
```proto
// CPP
package foo.bar; // -> namespace foo::bar::

// go
option go_package = "hs"; // use this first
package example.high_score;

// java
package foo.bar;
option java_outer_classname = "Foo"; // ->use this first
option java_package = "com.example.foo.bar";
option optimize_for = CODE_SIZE;
option optimize_for = LITE_RUNTIME;

message SongServerRequest {
  required string song_name = 1;
}

enum Foo {
  FIRST_VALUE = 0;
  SECOND_VALUE = 1;
}

service FooService {
  rpc GetSomething(FooRequest) returns (FooResponse);
}
```

- `CamelCase` for message names
- `underscore_separated_names` for field names
- `CAPITALS_WITH_UNDERSCORES` for Enums value names
- `CamelCase` for both service name and any RPC method names



## Generate code

```c
// C++:
const string& song_name() { ... }
void set_song_name(const string& x) { ... }
```
```java
// Java:
public String getSongName() { ... }
public Builder setSongName(String v) { ... }
```

```go
// go

func (i *Message)GetSongName(){...}
func (i *Message)SetSongName(){...}

```

