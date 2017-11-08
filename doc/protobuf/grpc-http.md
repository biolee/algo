```proto
package foo.bar;

service MyService{
	rpc Func(Request)returns(Responce);
}
```
->
```
[POST /foo.bar.MyService/Func HTTP/1.1\r\n]
Connection: keep-alive\r\n
x-grpc-web: 1\r\n
content-type: application/grpc-web+proto\r\n
Accept-Encoding: gzip, deflate, br\r\n


http.content_type == "application/octet-stream"
http.transfer_encoding == "chunked"
```