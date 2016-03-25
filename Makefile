TEST_DEFS   := -DXDS_TEST

ARM_FILES := source/arm/dyncom/*.cpp source/arm/interpreter/*.cpp source/arm/skyeye_common/vfp/vfpdouble.cpp source/arm/skyeye_common/vfp/vfp.cpp source/arm/skyeye_common/vfp/vfpsingle.cpp source/arm/disassembler/*.cpp
ARM_FLAGS := -Isource/
KERNEL_FILES := source/kernel/*.cpp
HARDWARE_FILES := source/hardware/*.cpp
PROCESS9_FILES := source/process9/*.cpp source/process9/archive/*.cpp
UTIL_FILES := source/util/*.cpp


#COMMON_FILES := source/Bootloader.cpp source/arm/*.cpp $(ARM_FILES) $(KERNEL_FILES) $(HARDWARE_FILES) $(PROCESS9_FILES) $(UTIL_FILES)
COMMON_FILES := source/citraimport/glad/src/glad.c external/imgui/imgui.cpp external/imgui/imgui_draw.cpp external/imgui/examples/opengl3_example/imgui_impl_glfw_gl3.cpp $(shell for file in `find source -name *.cpp`; do echo $$file; done)


BUILD_FLAGS := -I/opt/local/include -Iinclude -Isource/citraimport -Iexternal/gl3w/include -Iexternal/imgui -g --std=c++11 $(ARM_FLAGS) -mtune=native -msse4.1 -Wfatal-errors
LINK_FLAGS := -L/opt/local/lib -Lexternal/gl3w -lglfw -lpthread -lgl3w -liconv -framework OpenGL -framework Cocoa

main:
	g++ -c source/Main.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds $(TEST_DEFS) $(BUILD_FLAGS) $(LINK_FLAGS) *.o

test:
	g++ -o xds_test_memorymap tests/kernel/MemoryMap.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_handletable tests/kernel/HandleTable.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_linkedlist tests/kernel/LinkedList.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_resourcelimit tests/kernel/ResourceLimit.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)
	g++ -o xds_test_mutex tests/util/Mutex.cpp $(TEST_DEFS) $(BUILD_FLAGS) $(COMMON_FILES)

runtests:
	./xds_test_memorymap
	./xds_test_handletable
	./xds_test_linkedlist
	./xds_test_resourcelimit
	./xds_test_mutex

clean:
	rm ./*.o ./xds ./xds_test_memorymap ./xds_test_handletable ./xds_test_linkedlist ./xds_test_resourcelimit ./xds_test_mutex
