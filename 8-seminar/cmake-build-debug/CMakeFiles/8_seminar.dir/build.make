# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /mnt/c/Assembler/8-seminar

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/c/Assembler/8-seminar/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/8_seminar.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/8_seminar.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/8_seminar.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/8_seminar.dir/flags.make

CMakeFiles/8_seminar.dir/2_task.c.o: CMakeFiles/8_seminar.dir/flags.make
CMakeFiles/8_seminar.dir/2_task.c.o: ../2_task.c
CMakeFiles/8_seminar.dir/2_task.c.o: CMakeFiles/8_seminar.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/c/Assembler/8-seminar/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/8_seminar.dir/2_task.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/8_seminar.dir/2_task.c.o -MF CMakeFiles/8_seminar.dir/2_task.c.o.d -o CMakeFiles/8_seminar.dir/2_task.c.o -c /mnt/c/Assembler/8-seminar/2_task.c

CMakeFiles/8_seminar.dir/2_task.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/8_seminar.dir/2_task.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /mnt/c/Assembler/8-seminar/2_task.c > CMakeFiles/8_seminar.dir/2_task.c.i

CMakeFiles/8_seminar.dir/2_task.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/8_seminar.dir/2_task.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /mnt/c/Assembler/8-seminar/2_task.c -o CMakeFiles/8_seminar.dir/2_task.c.s

# Object files for target 8_seminar
8_seminar_OBJECTS = \
"CMakeFiles/8_seminar.dir/2_task.c.o"

# External object files for target 8_seminar
8_seminar_EXTERNAL_OBJECTS =

8_seminar: CMakeFiles/8_seminar.dir/2_task.c.o
8_seminar: CMakeFiles/8_seminar.dir/build.make
8_seminar: CMakeFiles/8_seminar.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/c/Assembler/8-seminar/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable 8_seminar"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/8_seminar.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/8_seminar.dir/build: 8_seminar
.PHONY : CMakeFiles/8_seminar.dir/build

CMakeFiles/8_seminar.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/8_seminar.dir/cmake_clean.cmake
.PHONY : CMakeFiles/8_seminar.dir/clean

CMakeFiles/8_seminar.dir/depend:
	cd /mnt/c/Assembler/8-seminar/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/c/Assembler/8-seminar /mnt/c/Assembler/8-seminar /mnt/c/Assembler/8-seminar/cmake-build-debug /mnt/c/Assembler/8-seminar/cmake-build-debug /mnt/c/Assembler/8-seminar/cmake-build-debug/CMakeFiles/8_seminar.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/8_seminar.dir/depend
