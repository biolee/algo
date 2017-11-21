all:static_main dyn_main

.PHONY : staticlib
staticlib:
	cd lib/static && \
		g++ -c StaticMath.cpp  && \
		ar -crv libstaticmath.a StaticMath.o

.PHONY : static_main
static_main: staticlib
	cd g++ -o static_main main_static.cpp -Ilib/static -L./lib/static -lstaticmath  && \
		./static_main

.PHONY : dynamiclib
dynamiclib:
	cd lib/dynamic && \
		g++ -fPIC -c DynamicMath.cpp && \
		g++ -shared -o libdynmath.dylib DynamicMath.o
		# g++ -fPIC -shared -o libdynmath.so DynamicMath.cpp
		# mac: dylib
		# linux: .so
		#


.PHONY : dyn_main
dyn_main: dynamiclib
	cd g++ -o dyn_main main_dynamic.cpp -Ilib/dynamic -L./lib/dynamic -ldynmath && \
		export DYLD_LIBRARY_PATH="lib/dynamic:$LD_LIBRARY_PATH" && \
		./dyn_main
#		export LD_LIBRARY_PATH="lib/dynamic:$LD_LIBRARY_PATH" && \
