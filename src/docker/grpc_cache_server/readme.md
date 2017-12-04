original fork from [xiaoxq](https://github.com/xiaoxq/docker-toolkit/tree/master/bazel-grpc-cache-server)

# Bazel GRPC Cache Server

* Read [upstream doc](https://github.com/bazelbuild/bazel/blob/master/src/main/java/com/google/devtools/build/lib/remote/README.md)
* Source code on [Github](https://github.com/xiaoxq/docker-toolkit/tree/master/bazel-grpc-cache-server)
* Built image on [Docker Hub](https://hub.docker.com/r/xiangquan/bazel-grpc-cache-server/tags/)

## Build

```bash
./build.sh
```

## Run your own instance at localhost:8089

```bash
docker run -d --rm --name=bazel-cache --net=host \
    -e PORT=8089 \
    ${USER}/bazel-grpc-cache-server
```

Then add the following config to your HOME/.bazelrc or WORKSPACE/.bazelrc:

```
startup --host_jvm_args=-Dbazel.DigestFunction=SHA1
build --spawn_strategy=remote
build --remote_cache=127.0.0.1:8089
build --strategy=Javac=remote
build --strategy=Closure=remote
```