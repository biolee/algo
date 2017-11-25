all:static_main dyn_main

.PHONY : staticlib
staticlib:
	g++ -c math.cpp -I./include  -o build/math.o && \
		ar -crv build/libmath.a build/math.o

.PHONY : static_main
static_main: staticlib
	g++ -o build/static_main main.cpp -I./include -L./build -l math  && \
		./build/static_main

.PHONY : dynamic
dynamiclib:
	g++ -fPIC -c math.cpp  -I./include -o build/math.o && \
		g++ -shared -o build/libmath.dylib build/math.o
		# g++ -fPIC -shared -o libmath.so math.cpp
		# mac: dylib
		# linux: .so


.PHONY : dyn_main
dyn_main: dynamiclib
	g++ -o build/dyn_main main.cpp -I./include -L build -l math && \
		export DYLD_LIBRARY_PATH="./build:$LD_LIBRARY_PATH" && \
		./build/dyn_main
#		linux export LD_LIBRARY_PATH="lib/dynamic:$LD_LIBRARY_PATH"

clean:
	rm build/*

all:
	make static_main
	make dyn_main
