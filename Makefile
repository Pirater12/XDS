TEST_DEFS   := -DXDS_TEST

ARM_FILES := source/arm/dyncom/*.cpp source/arm/interpreter/*.cpp source/arm/skyeye_common/vfp/vfpdouble.cpp source/arm/skyeye_common/vfp/vfp.cpp source/arm/skyeye_common/vfp/vfpsingle.cpp source/arm/disassembler/*.cpp
ARM_FLAGS := -Isource/
KERNEL_FILES := source/kernel/*.cpp
HARDWARE_FILES := source/hardware/*.cpp
PROCESS9_FILES := source/process9/*.cpp source/process9/archive/*.cpp
UTIL_FILES := source/util/*.cpp

#COMMON_FILES := source/Bootloader.cpp source/arm/*.cpp $(ARM_FILES) $(KERNEL_FILES) $(HARDWARE_FILES) $(PROCESS9_FILES) $(UTIL_FILES)
SOURCE_FILES := source/citraimport/glad/src/glad.o external/imgui/imgui.o external/imgui/examples/opengl3_example/imgui_impl_glfw_gl3.o $(shell for file in `find source -name *.cpp`; do echo $$file ; done)

ARCH := -m32

CFLAGS := $(ARCH) -I$(PWD)/external/glfw/include -I$(PWD)/include -I$(PWD)/source/citraimport -I$(PWD)/external/gl3w/include -I$(PWD)/external/imgui -g --std=c11 $(ARM_FLAGS) -mtune=native -msse4.1 -Wfatal-errors
CXXFLAGS := $(ARCH) -I$(PWD)/external/glfw/include -I$(PWD)/include -I$(PWD)/source/citraimport -I$(PWD)/source/citraimport/GPU -I$(PWD)/external/gl3w/include -I$(PWD)/external/imgui -g --std=c++14 $(ARM_FLAGS) -mtune=native -msse4.1 -Wfatal-errors -fpermissive
LDFLAGS := $(ARCH) -L/opt/local/lib -L$(PWD)/external/gl3w -L$(PWD)/external/glfw/src -lpthread -lX11 -lXxf86vm -lXrender -lXcursor -lXrandr -lXinerama -lglfw3 -lgl3w -lGL -ldl

COMMON_FILES := $(patsubst %.cpp,%.o,$(patsubst %.c,%.o,$(SOURCE_FILES)))

xds: deps $(COMMON_FILES) source/Main.cpp
	echo $(COMMON_FILES)
	g++ -o xds $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES) $(LDFLAGS)

deps:
	cd external/gl3w && ./gl3w_gen.py && CFLAGS= CXXFLAGS= LDFLAGS= CC="gcc $(ARCH)" CXX="g++ $(ARCH)" cmake . && make
	cd external/glfw && CFLAGS= CXXFLAGS= LDFLAGS= CC="gcc $(ARCH)" CXX="g++ $(ARCH)" cmake . && make

clean-deps:
	cd external/gl3w && git clean -fxd
	cd external/glfw && git clean -fxd

%.o: %.c
	gcc $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	g++ $(CXXFLAGS) -c -o $@ $<

test: tests/kernel/MemoryMap.o tests/kernel/HandleTable.o tests/kernel/LinkedList.o tests/kernel/ResourceLimit.o tests/util/Mutex.o
	g++ -o xds_test_memorymap tests/kernel/MemoryMap.o $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_handletable tests/kernel/HandleTable.o $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_linkedlist tests/kernel/LinkedList.o $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_resourcelimit tests/kernel/ResourceLimit.o $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_mutex tests/util/Mutex.o $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)

runtests:
	./xds_test_memorymap
	./xds_test_handletable
	./xds_test_linkedlist
	./xds_test_resourcelimit
	./xds_test_mutex

clean: clean-deps
	rm -f $(COMMON_FILES) ./xds ./xds_test_memorymap ./xds_test_handletable ./xds_test_linkedlist ./xds_test_resourcelimit ./xds_test_mutex
