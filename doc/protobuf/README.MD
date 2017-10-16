[message documentation](https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.message#Message)

- Basic Operations
    - cpp
        - message.New()
        - message.CopyFrom(const Message & from)
        - message.MergeFrom(const Message & from)
    - go
        - deepCloneMessage = proto.Clone(oldMessage)
        - proto.Merge(dst, src Message)
    - java
        - Builder.build()
    - python
        - message.CopyFrom()
        - message.MergeFrom()
    - js
        - message.cloneMessage()
- Debugging & Testing
    - cpp
        - message.DebugString()
        - message.PrintDebugString()
    - go
        - s = proto.MarshalTextString(pb Message)
        - err = proto.MarshalText(w io.Writer, pb Message)
    - java
        - message.toString()
    - python
        - message.__unicode__()
        - message.__str__()
    - js
        - JSON.stringify(message.toObject())
- Heavy I/O
    - cpp
        - ParseFromFileDescriptor(int file_descriptor)
        - ParseFromIstream(std::istream * input)
        - SerializeToFileDescriptor(int file_descriptor)
        - SerializeToOstream(std::ostream * output)  
    - go
        - github.com/golang/protobuf/proto
        - proto.String("hello")
        - proto.Unmarshal(data, newMessage)
        - data, err := proto.Marshal(message)
    - java
        - DynamicMessage
        - message.parseFrom()
        - message.writeTo()
    - python
        - message.ParseFromString()
        - message.MergeFromString()
        - message.SerializeToString()
    - js
        - message.deserializeBinary()
        - message.deserializeBinaryFromReader()
        - message.serializeBinary()
        - serializeBinaryToWriter()
        - message.decode()?
        - base64 to array
        - const buffer = Uint8Array.from(atob(base64_string), c => c.charCodeAt(0))
    - js-3
        - let buffer = message.encode(message).finish();
        - let message = message.decode(buffer);
        - var message = AwesomeMessage.create({ awesomeField: "AwesomeString" });
        - toObject 
        ```js
            var object = AwesomeMessage.toObject(message, {
              enums: String,  // enums as string names
              longs: String,  // longs as strings (requires long.js)
              bytes: String,  // bytes as base64 encoded strings
              defaults: true, // includes default values
              arrays: true,   // populates empty arrays (repeated fields) even if defaults=false
              objects: true,  // populates empty objects (map fields) even if defaults=false
              oneofs: true    // includes virtual oneof fields set to the present field's name
            });
         ```

# Go
```bash
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
go get -u google.golang.org/grpc
protoc --go_out=. *.proto
protoc --go_out=plugins=grpc:. *.proto
```

# Node

```bash
## protobuf

yarn add google-protobuf
# or not official
yarn add protobufjs
protoc --js_out=import_style=commonjs,binary:. helloworld.proto
# or
npm install -g grpc-tools
grpc_tools_node_protoc --js_out=import_style=commonjs,binary:. helloworld.proto


## gRPC
yarn add grpc
npm install -g grpc-tools
grpc_tools_node_protoc --js_out=import_style=commonjs,binary:. --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` helloworld.proto
```
# Python

```bash
## protobuf

pip install protobuf
protoc -I=. --python_out=. helloworld.proto
# or
python -m grpc_tools.protoc -I=. --python_out=. helloworld.proto

## gRPC
pip install grpcio
pip install grpcio-tools
python -m grpc_tools.protoc -I=. --python_out=. --grpc_python_out=. helloworld.proto
```

# Java

```xml
<project>
  ...
    <build>
      <extensions>
        <extension>
          <groupId>kr.motd.maven</groupId>
          <artifactId>os-maven-plugin</artifactId>
          <version>1.5.0.Final</version>
        </extension>
      </extensions>
      <plugins>
        <plugin>
          <groupId>org.xolstice.maven.plugins</groupId>
          <artifactId>protobuf-maven-plugin</artifactId>
          <version>0.5.0</version>
          <configuration>
            <protocArtifact>com.google.protobuf:protoc:3.3.0:exe:${os.detected.classifier}</protocArtifact>
            <pluginId>grpc-java</pluginId>
            <pluginArtifact>io.grpc:protoc-gen-grpc-java:1.6.1:exe:${os.detected.classifier}</pluginArtifact>
          </configuration>
          <executions>
            <execution>
              <goals>
                <goal>compile</goal>
                <goal>compile-custom</goal>
              </goals>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>

  <dependencies>
    <dependency>
          <groupId>com.google.protobuf</groupId>
          <artifactId>protobuf-java</artifactId>
          <version>3.4.0</version>
    </dependency>
    <dependency>
      <groupId>io.grpc</groupId>
      <artifactId>grpc-netty</artifactId>
      <version>1.6.1</version>
    </dependency>
    <dependency>
      <groupId>io.grpc</groupId>
      <artifactId>grpc-protobuf</artifactId>
      <version>1.6.1</version>
    </dependency>
    <dependency>
      <groupId>io.grpc</groupId>
      <artifactId>grpc-stub</artifactId>
      <version>1.6.1</version>
    </dependency>
    ...
  </dependencies>
  ...
</project>
```

# CPP

### Install

- protobuf

```bash
# mac
brew install protobuf

# build from source 

## prepare for linux
sudo apt-get install autoconf automake libtool curl make g++ unzip

## prepare for mac
brew install automake libtool

## build
git clone https://github.com/google/protobuf.git && cd protobuf
./autogen.sh
./configure
# ./configure --prefix=/usr/local
make
make check
sudo make install
sudo ldconfig # refresh shared library cache.
```

- grpc

```bash
# mac
brew install grpc

# build from source 

## prepare for linux
sudo apt-get install build-essential autoconf libtool
sudo apt-get install libgflags-dev libgtest-dev
sudo apt-get install clang libc++-dev

## prepare for mac
brew install autoconf automake libtool shtool
brew install gflags

## build
git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc && cd grpc
git submodule update --init
make
make install
```

### make
```makefile
## Protobuf
.PHONY: %.pb.cc
%.pb.cc: %.proto
    $(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

## gRPC
.PHONY: %.grpc.pb.cc
%.grpc.pb.cc: %.proto
    $(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
```