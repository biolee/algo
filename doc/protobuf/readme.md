# why gRPC?

REST+JSON 是目前web app与api server之间的实施标准, 甚至[angular http](https://angular.io/guide/http)默认将http response解析为json
然而，gRPC作为server to server, server to client通信有如下优势

1. single ground truth

不论是私有RPC还是REST+JSON的文档（如swagger），文档和实际接口之间依然有滞后，不过得承认swagger能直接在浏览器里调用是有优势的

2. strongly typed

动态语言慢慢加入类型，比如前端使用Typescript的越来越多, Python也开始加入[Type Hints](https://www.python.org/dev/peps/pep-0484/)

gRPC为跨语言的API提供强类型，不会因为跨语言的json序列化差异引入bug

![gRPC web](https://wp.improbable.io/wp-content/uploads/2017/04/blog2-960x342.jpg)
Google在github上有个[private的项目](https://github.com/grpc/grpc-web), 从[这里](https://github.com/grpc/grpc-experiments/issues/159)申请访问
实现一个http1的proxy，让浏览器能够直接访问gRPC服务，社区有一个类似可用的[方案](https://github.com/improbable-eng/grpc-web/tree/master/go/grpcweb),并且
这个项目能自动生成Typescript

另一种思路是个人不太看好的方式，在proto 文件里添加http的标注，生成proxy，比如[googleapis](https://github.com/googleapis/googleapis/blob/master/google/genomics/v1/datasets.proto#L41)

3. 相比JSON性能更高

Protobuf相比JSON编码更紧凑，解析更高效, HTTP2 让网络传输更高效

4. 多语言

gRPC能够自动生成多个语言的client code

5. Standardized Status Codes

6. use case
- tensorflow serving [prediction service](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/apis/prediction_service.proto#L15)
- etcd ["Simple: well-defined, user-facing API (gRPC)"](https://github.com/coreos/etcd)
- cockroach ["The primary motivation is to minimize the impact that raft snapshots have on other RPCs (#3013)"](https://github.com/cockroachdb/cockroach/blob/master/docs/RFCS/20151207_grpc.md)
- tidb [Now we have already used gRPC in TiKV in production for a long time](https://pingcap.github.io/blog/2017/09/12/futuresandgrpc/)

# gRPC Protobuf package 最佳实践
- [doc](https://github.com/biolee/grpc_starter)
- [code demo](https://github.com/biolee/grpc_starter)

# grpc multi language
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
- Json 
	- cpp
		- header `#include <google/protobuf/util/json_util.h>`
		- [doc](https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.util.json_util) 
		- google::protobuf::util::MessageToJsonString
		```cpp
		util::Status util::MessageToJsonString(
                const Message & message,
                string * output,
                const JsonOptions & options)
		```
		- google::protobuf::util::JsonStringToMessage
		```cpp
		util::Status util::JsonStringToMessage(
                          const string & input,
                          Message * message,
                          const JsonParseOptions & options)
		```
		- google::protobuf::util::BinaryToJsonStream
		```cpp
		util::Status util::BinaryToJsonStream(
                TypeResolver * resolver,
                const string & type_url,
                io::ZeroCopyInputStream * binary_input,
                io::ZeroCopyOutputStream * json_output,
                const JsonPrintOptions & options)
        ```
        - google::protobuf::util::JsonToBinaryStream
        ```cpp
        util::Status util::JsonToBinaryStream(
                TypeResolver * resolver,
                const string & type_url,
                io::ZeroCopyInputStream * json_input,
                io::ZeroCopyOutputStream * binary_output,
                const JsonParseOptions & options)
        ```
    - go
        - `import "github.com/golang/protobuf/jsonpb"`
        - `func Unmarshal(r io.Reader, pb proto.Message) error`
        - `func UnmarshalNext(dec *json.Decoder, pb proto.Message) error`
        - `func UnmarshalString(str string, pb proto.Message) error`
        - `func (m *Marshaler) Marshal(out io.Writer, pb proto.Message) error`
        - `func (m *Marshaler) MarshalToString(pb proto.Message) (string, error)`
    - java
        - `com.google.protobuf.util.JsonFormat`
            - `public static JsonFormat.Printer printer()`
            - `public static JsonFormat.Parser parser()`
        - `com.google.protobuf.util.JsonFormat.Parser` merge
        ```java
		public void merge(String json,
                          Message.Builder builder)
                   throws InvalidProtocolBufferException
		```
		```java
		public void merge(Reader json,
                          Message.Builder builder)
                   throws IOException
		```
		- `com.google.protobuf.util.JsonFormat.Printer`
		```java
		public String print(MessageOrBuilder message)
                     throws InvalidProtocolBufferException
		```
	- python
		- `from google.protobuf.json_format import MessageToJson,Parse`
		- `MessageToJson(message, including_default_value_fields=False)-> json_string`
		- `Parse(text, message, ignore_unknown_fields=False) -> message`
		- err
			- `SerializeToJsonError`
			- `ParseError`
- gRPC Error
	- cpp
		- server
	    ```cpp
	        class GreeterServiceImpl final : public Greeter::Service {
	          Status SayHello(ServerContext* context, const HelloRequest* request,HelloReply* reply) override {
	            grpc::Status(grpc::StatusCode::Unimplemented),"Currently Unimplemented")
	          }
	        };
	    ```
		- client
		```cpp
			Status status = stub_->SayHello(&context, request, &reply);
                if (status.ok()) {
                  return reply.message();
                } else {
                  std::cout << status.error_code() << ": " << status.error_message()
                            << std::endl;
                  return "RPC failed";
                }
		```	
	- java
		- server
		```java
			class GreeterImpl extends GreeterGrpc.GreeterImplBase {
                @Override
                public void sayHello(HelloRequest req, StreamObserver<HelloReply> responseObserver) {
	                HelloReply reply = HelloReply.newBuilder().build();
	                responseObserver.onNext(reply);
	                responseObserver.onError(Status.UNIMPLEMENTED
	                              .withDescription("Currently Unimplemented")
	                              .asRuntimeException());
	                responseObserver.onCompleted();
                }
           }
		```
		- client
		```java
			class client{
				static void sayHello(){
		    		channel = ManagedChannelBuilder.forAddress("localhost", 50051)
                                      .usePlaintext(true)
                                      .build();
		    		blockingStub = GreeterGrpc.newBlockingStub(channel);
                    			
                    HelloRequest request = HelloRequest.newBuilder().setName(name).build();
                    HelloReply response;
                    try {
                          response = blockingStub.sayHello(request);
                    } catch (StatusRuntimeException e) {
                        status = e.getStatus()
                        logger.log(Level.WARNING, "RPC failed: code {0} detail {1}", status.getCode(),status.getDescription());
                    }
				}
			}
		```
	- go
		- server
		```go
		func (i *HelloService) SayHello(ctx context.Context, in *SayHelloRequest) (*SayHelloReponce, error) {
            return &SayHelloReponce{}, status.Errorf(codes.Unimplemented, "Currently Unimplemented")
        }
		```
		- client
		```go
		responce,err := helloClient.SayHello(context.Background(),&SayHelloRequest{})
		s = status.FromError(err)
		if s.Code() == codes.Unimplemented{
			fmt.print(s.Message())
			fmt.print(s.Details())
		}
		```
	- python
		- server
        ```python
            class HelloService(hello_pb2_grpc.HelloServiceServicer):
                def SayHello(self, request, context):
                    context.set_code(grpc.StatusCode.UNAUTHENTICATED)
                    context.set_details('Currently Unimplemented')
                    return hello_pb2_grpc.SayHelloResponce()
        ```
		- client
		```python
			try:
                response = stub.SayHello(hello_pb2.SayHelloRequest(), metadata=[("key", "value")])
            except grpc.RpcError as e:
                    if e.code() == grpc.StatusCode.UNAUTHENTICATED:
                        print(e.details())
		```
	- node
		- server
		```js
			function sayHello(call, callback) {
	          var reply = new messages.HelloReply();
	          callback({
	                       code: grpc.status.UNIMPLEMENTED,
	                       message: 'Currently Unimplemented',
	                   }, reply);
	        }
		```
		- client
		```js
              var request = new messages.HelloRequest();
              client.sayHello(request, function(err, response) {
                if (err.code ===grpc.status.UNIMPLEMENTED){
                  console.log(err.message)
              	}
              });
		```
	- Error status codes
		```go
		const (
            // OK is returned on success.
            OK  Code = 0
        
            // Canceled indicates the operation was canceled (typically by the caller).
            Canceled Code = 1
        
            // Unknown error.  An example of where this error may be returned is
            // if a Status value received from another address space belongs to
            // an error-space that is not known in this address space.  Also
            // errors raised by APIs that do not return enough error information
            // may be converted to this error.
            Unknown Code = 2
        
            // InvalidArgument indicates client specified an invalid argument.
            // Note that this differs from FailedPrecondition. It indicates arguments
            // that are problematic regardless of the state of the system
            // (e.g., a malformed file name).
            InvalidArgument Code = 3
        
            // DeadlineExceeded means operation expired before completion.
            // For operations that change the state of the system, this error may be
            // returned even if the operation has completed successfully. For
            // example, a successful response from a server could have been delayed
            // long enough for the deadline to expire.
            DeadlineExceeded Code = 4
        
            // NotFound means some requested entity (e.g., file or directory) was
            // not found.
            NotFound Code = 5
        
            // AlreadyExists means an attempt to create an entity failed because one
            // already exists.
            AlreadyExists Code = 6
        
            // PermissionDenied indicates the caller does not have permission to
            // execute the specified operation. It must not be used for rejections
            // caused by exhausting some resource (use ResourceExhausted
            // instead for those errors).  It must not be
            // used if the caller cannot be identified (use Unauthenticated
            // instead for those errors).
            PermissionDenied Code = 7
        
            // Unauthenticated indicates the request does not have valid
            // authentication credentials for the operation.
            Unauthenticated Code = 16
        
            // ResourceExhausted indicates some resource has been exhausted, perhaps
            // a per-user quota, or perhaps the entire file system is out of space.
            ResourceExhausted Code = 8
        
            // FailedPrecondition indicates operation was rejected because the
            // system is not in a state required for the operation's execution.
            // For example, directory to be deleted may be non-empty, an rmdir
            // operation is applied to a non-directory, etc.
            //
            // A litmus test that may help a service implementor in deciding
            // between FailedPrecondition, Aborted, and Unavailable:
            //  (a) Use Unavailable if the client can retry just the failing call.
            //  (b) Use Aborted if the client should retry at a higher-level
            //      (e.g., restarting a read-modify-write sequence).
            //  (c) Use FailedPrecondition if the client should not retry until
            //      the system state has been explicitly fixed.  E.g., if an "rmdir"
            //      fails because the directory is non-empty, FailedPrecondition
            //      should be returned since the client should not retry unless
            //      they have first fixed up the directory by deleting files from it.
            //  (d) Use FailedPrecondition if the client performs conditional
            //      REST Get/Update/Delete on a resource and the resource on the
            //      server does not match the condition. E.g., conflicting
            //      read-modify-write on the same resource.
            FailedPrecondition Code = 9
        
            // Aborted indicates the operation was aborted, typically due to a
            // concurrency issue like sequencer check failures, transaction aborts,
            // etc.
            //
            // See litmus test above for deciding between FailedPrecondition,
            // Aborted, and Unavailable.
            Aborted Code = 10
        
            // OutOfRange means operation was attempted past the valid range.
            // E.g., seeking or reading past end of file.
     \       //
            // Unlike InvalidArgument, this error indicates a problem that may
            // be fixed if the system state changes. For example, a 32-bit file
            // system will generate InvalidArgument if asked to read at an
            // offset that is not in the range [0,2^32-1], but it will generate
            // OutOfRange if asked to read from an offset past the current
            // file size.
            //
            // There is a fair bit of overlap between FailedPrecondition and
            // OutOfRange.  We recommend using OutOfRange (the more specific
            // error) when it applies so that callers who are iterating through
            // a space can easily look for an OutOfRange error to detect when
            // they are done.
            OutOfRange Code = 11
        
            // Unimplemented indicates operation is not implemented or not
            // supported/enabled in this service.
            Unimplemented Code = 12
        
            // Internal errors.  Means some invariants expected by underlying
            // system has been broken.  If you see one of these errors,
            // something is very broken.
            Internal Code = 13
        
            // Unavailable indicates the service is currently unavailable.
            // This is a most likely a transient condition and may be corrected
            // by retrying with a backoff.
            //
            // See litmus test above for deciding between FailedPrecondition,
            // Aborted, and Unavailable.
            Unavailable Code = 14
        
            // DataLoss indicates unrecoverable data loss or corruption.
            DataLoss Code = 15
        )
		
		```
		
- Auth & dist trace by meta data
	- python
		- server
			```python
				# ------- Sending metadata -----------
                # Unary call
                class HelloService(hello_pb2_grpc.HelloServiceServicer):
                    def SayHello(self, request, context):
                        metadata = [("key", "value")]
                        context.initial_metadata(metadata)
                        context.send_initial_metadata(metadata)
                        context.terminal_metadata(metadata)
                        context.set_trailing_metadata(metadata)
                       
                        for k,v in metadata:
                            use(k,v)
				
				# -------- Receiving metadata --------
				# Unary call
				class HelloService(hello_pb2_grpc.HelloServiceServicer):
                    def SayHello(self, request, context):
                        metadata = context.invocation_metadata()   
                        for k,v in metadata:
                            use(k,v)
               	
            	
			```
		- client
			```python
				response,call = stub.SayHello(hello_pb2.SayHelloRequest(),_TIMEOUT_SECONDS, metadata=[("key", "value")],with_call=True)
				call.code()
				call.details()
				for i in call.initial_metadata():
                    print(i)
                for i in call.terminal_metadata():
                    print(i)
			```
	- go
		- server
		```go
			// Receiving metadata
	
			// Unary call
			func (s *server) SomeRPC(ctx context.Context, in *pb.someRequest) (*pb.someResponse, error) {
                // create and send header
                header := metadata.Pairs("header-key", "val")
                grpc.SendHeader(ctx, header)
                // create and set trailer
                trailer := metadata.Pairs("trailer-key", "val")
                grpc.SetTrailer(ctx, trailer)
            }
          
          	// Streaming call
        	func (s *server) SomeStreamingRPC(stream pb.Service_SomeStreamingRPCServer) error {
                // create and send header
                header := metadata.Pairs("header-key", "val")
                stream.SendHeader(header)
                // create and set trailer
                trailer := metadata.Pairs("trailer-key", "val")
                stream.SetTrailer(trailer)
            }
		```
		- client
		```go
			// ------- Sending metadata -----------
			md := metadata.New(map[string]string{"key1": "val1", "key2": "val2"})
            ctx := metadata.NewOutgoingContext(context.Background(), md)
          	// make unary RPC
            response, err := client.SomeRPC(ctx, someRequest)
            
            // or make streaming RPC
            stream, err := client.SomeStreamingRPC(ctx)
          
          	// ------- Receiving metadata ---------
        	// Unary call
        	var header, trailer metadata.MD // variable to store header and trailer
            r, err := client.SomeRPC(
                ctx,
                someRequest,
                grpc.Header(&header),    // will retrieve header
                grpc.Trailer(&trailer),  // will retrieve trailer
            )
          	// Streaming call
        	stream, err := client.SomeStreamingRPC(ctx)
            // retrieve header
            header, err := stream.Header()
            // retrieve trailer
            trailer := stream.Trailer()
		```
	- java 
		- client
		```java
			class HeaderClientInterceptor implements ClientInterceptor {
				@Override
                public <ReqT, RespT> ClientCall<ReqT, RespT> interceptCall(MethodDescriptor<ReqT, RespT> method,
                                                                               CallOptions callOptions, Channel next) {
                	return new SimpleForwardingClientCall<ReqT, RespT>(next.newCall(method, callOptions)){
              	    	@Override
                        public void start(Listener<RespT> responseListener, Metadata headers){}
              		};
               }
			}
			class demo{
				static void main(){
		    		Map<String, String> headerMap = new HashMap<>();
                    ClientInterceptor interceptor = new HeaderClientInterceptor(headerMap);
                    ManagedChannel managedChannel = ManagedChannelBuilder.forAddress(host, port).usePlaintext(true).build();
                    Channel channel = ClientInterceptors.intercept(managedChannel, interceptor);
				}					
			}
		```
		- server
		```java
			public class HeaderServerInterceptor implements ServerInterceptor {
				@Override
                  public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(ServerCall<ReqT, RespT> call,
                                                                            	final Metadata requestHeaders,
                                                                            	ServerCallHandler<ReqT, RespT> next) {};
			}
			class Main{
				static void main(){
		    		Server server = ServerBuilder.forPort(port)
                                  .addService(ServerInterceptors.intercept(new GreeterImpl(), new HeaderServerInterceptor()))
                                  .build()
                                  .start();
				}				
			}
				
			
		```
		
- multiplex
	```
	# golang
		
	lis, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", *port))
	grpcServer := grpc.NewServer(opts...)
	pb.RegisterService1Server(grpcServer, Service1Server1{})
    pb.RegisterRouteGuideServer(grpcServer, Service1Server1{})
    grpcServer.Serve(lis)
        
    # python
        
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    helloworld_pb2_grpc.add_ServiceServicer1_to_server(ServiceServicer1(),erver)
    helloworld_pb2_grpc.add_ServiceServicer2_to_server(ServiceServicer2(),erver)
    server.add_insecure_port('[::]:50051')
	server.start()
	try:
	    while True:
	        time.sleep(_ONE_DAY_IN_SECONDS)
	except KeyboardInterrupt:
	    server.stop(0)
	     
	# CPP
	
	Service1Impl service1{};
	Service2Impl service2{};
	    
	std::string server_address("0.0.0.0:50051");
	ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service1);
    builder.RegisterService(&service2);
    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Server listening on " << server_address << std::endl;
    server->Wait();
        
    # Java
    
    server = ServerBuilder.forPort(port)
                .addService(new Service1Impl())
                .addService(new Service2Impl())
                .build()
                .start();
        
	```
- getClient
	```
	# golang
	conn, err := grpc.Dial(*serverAddr, opts...)
	client := pb.NewService1Client(conn)
	responce,
	
	# python
	channel = grpc.insecure_channel('localhost:50051')
	stub = helloworld_pb2_grpc.Service1Stub(channel)
	
	# CPP
	std::shared_ptr<Channel> channel = grpc::CreateChannel("localhost:50051", grpc::InsecureChannelCredentials())
	std::unique_ptr<Greeter::Stub> stub = Service1::NewStub(channel)
	
	# java
	ManagedChannel chan = ManagedChannelBuilder.forAddress(host, port).build()
	blockingStub = GreeterGrpc.newBlockingStub(channel)
	```

- stream

	```
	# golang server
	type service1Server sturct {}
	
	# f(u)->u
	func (s *service1Server) Rpc1(ctx context.Context, in *pb.SomeRequest) (*pb.SomeResponse, error) {}
	# f(u)->s
	func (s *service1Server) Rpc2(in *pb.SomeRequest, stream pb.Service1Server_Rpc2Server) (error) {}
	# f(s)->u
	func (s *service1Server) Rpc3(stream pb.Service1Server_Rpc3Server) error {
		for {
			in, err := stream.Recv()
			err := stream.Send(out)
		}
	}
	# f(s)->s
	func (s *service1Server) Rpc4(stream pb.Service1Server_Rpc4Server) error {
		for {
			in, err := stream.Recv()
			err := stream.Send(out)
		}
	}
	type RouteGuideServer interface {
		// A simple RPC.
		//
		// Obtains the feature at a given position.
		//
		// A feature with an empty name is returned if there's no feature at the given
		// position.
		GetFeature(context.Context, *Point) (*Feature, error)
		// A server-to-client streaming RPC.
		//
		// Obtains the Features available within the given Rectangle.  Results are
		// streamed rather than returned at once (e.g. in a response message with a
		// repeated field), as the rectangle may cover a large area and contain a
		// huge number of features.
		ListFeatures(*Rectangle, RouteGuide_ListFeaturesServer) error
		// A client-to-server streaming RPC.
		//
		// Accepts a stream of Points on a route being traversed, returning a
		// RouteSummary when traversal is completed.
		RecordRoute(RouteGuide_RecordRouteServer) error
		// A Bidirectional streaming RPC.
		//
		// Accepts a stream of RouteNotes sent while a route is being traversed,
		// while receiving other RouteNotes (e.g. from other users).
		RouteChat(RouteGuide_RouteChatServer) error
	}
	type RouteGuide_ListFeaturesServer interface {
		Send(*Feature) error
		grpc.ServerStream
	}
	
	# golang client
	type MyServiceClient interface {
		// A simple RPC.
		//
		// Obtains the feature at a given position.
		//
		// A feature with an empty name is returned if there's no feature at the given
		// position.
		# f(u)->u
		RpcUU(ctx context.Context, in *Point, opts ...grpc.CallOption) (*Feature, error)
		// A server-to-client streaming RPC.
		//
		// Obtains the Features available within the given Rectangle.  Results are
		// streamed rather than returned at once (e.g. in a response message with a
		// repeated field), as the rectangle may cover a large area and contain a
		// huge number of features.
		# f(u)->s
		RpcUS(ctx context.Context, in *Rectangle, opts ...grpc.CallOption) (RouteGuide_ListFeaturesClient, error)
		// A client-to-server streaming RPC.
		//
		// Accepts a stream of Points on a route being traversed, returning a
		// RouteSummary when traversal is completed.
		# f(s)->u
		RecordRoute(ctx context.Context, opts ...grpc.CallOption) (RouteGuide_RecordRouteClient, error)
		// A Bidirectional streaming RPC.
		//
		// Accepts a stream of RouteNotes sent while a route is being traversed,
		// while receiving other RouteNotes (e.g. from other users).
		# f(s)->s
		RouteChat(ctx context.Context, opts ...grpc.CallOption) (RouteGuide_RouteChatClient, error)
	}
	
	type RouteGuide_RecordRouteClient interface {
		Send(*Point) error
		CloseAndRecv() (*RouteSummary, error)
		grpc.ClientStream
	}
	
	# python
	# f(u)->u
	GetFeature(self, request, context)->responce
	response,call = stub.SayHello(hello_pb2.SayHelloRequest(),_TIMEOUT_SECONDS, metadata=[("key", "value")],with_call=True)
	# f(s)->u
	ListFeatures(self, request, context)->generator:
		yeild responce_chunk
	features = stub.ListFeatures(rectangle)
	# f(u)->s
	# f(s)->s
	
	```

- blocking and nonblocking
	```
	# TODO
	```

# gRPC tools

## Go
```bash
go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
go get -u google.golang.org/grpc
protoc --go_out=. *.proto
protoc --go_out=plugins=grpc:. *.proto
```

## Node

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
## Python

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

## Java

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
or generate by commandline
```bash
# Compiling grpc java codegen
# Clone and Change to the `compiler` directory:
git clone https://github.com/grpc/grpc-java.git ${GRPC_JAVA_ROOT}
cd ${GRPC_JAVA_ROOT}/compiler
#Compile the plugin:
../gradlew java_pluginExecutable
export PROTOC_GEN_GRPC_JAVA=${GRPC_JAVA_ROOT}/build/exe/java_plugin/protoc-gen-grpc-java

protoc -I=path/to/ptoyo \
		--plugin=protoc-gen-grpc-java=${PROTOC_GEN_GRPC_JAVA} \
		--java_out=src/main/java \
		--grpc-java_out=src/main/java \
		foo.proto
```

## CPP

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