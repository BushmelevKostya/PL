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
CMAKE_SOURCE_DIR = /mnt/c/Assembler/7-seminar

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/c/Assembler/7-seminar/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/7_seminar.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/7_seminar.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/7_seminar.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/7_seminar.dir/flags.make

CMakeFiles/7_seminar.dir/1_task/1_task.c.o: CMakeFiles/7_seminar.dir/flags.make
CMakeFiles/7_seminar.dir/1_task/1_task.c.o: ../1_task/1_task.c
CMakeFiles/7_seminar.dir/1_task/1_task.c.o: CMakeFiles/7_seminar.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/c/Assembler/7-seminar/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/7_seminar.dir/1_task/1_task.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/7_seminar.dir/1_task/1_task.c.o -MF CMakeFiles/7_seminar.dir/1_task/1_task.c.o.d -o CMakeFiles/7_seminar.dir/1_task/1_task.c.o -c /mnt/c/Assembler/7-seminar/1_task/1_task.c

CMakeFiles/7_seminar.dir/1_task/1_task.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/7_seminar.dir/1_task/1_task.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /mnt/c/Assembler/7-seminar/1_task/1_task.c > CMakeFiles/7_seminar.dir/1_task/1_task.c.i

CMakeFiles/7_seminar.dir/1_task/1_task.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/7_seminar.dir/1_task/1_task.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /mnt/c/Assembler/7-seminar/1_task/1_task.c -o CMakeFiles/7_seminar.dir/1_task/1_task.c.s

# Object files for target 7_seminar
7_seminar_OBJECTS = \
"CMakeFiles/7_seminar.dir/1_task/1_task.c.o"

# External object files for target 7_seminar
7_seminar_EXTERNAL_OBJECTS =

7_seminar: CMakeFiles/7_seminar.dir/1_task/1_task.c.o
7_seminar: CMakeFiles/7_seminar.dir/build.make
7_seminar: CMakeFiles/7_seminar.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/c/Assembler/7-seminar/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable 7_seminar"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/7_seminar.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/7_seminar.dir/build: 7_seminar
.PHONY : CMakeFiles/7_seminar.dir/build

CMakeFiles/7_seminar.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/7_seminar.dir/cmake_clean.cmake
.PHONY : CMakeFiles/7_seminar.dir/clean

CMakeFiles/7_seminar.dir/depend:
	cd /mnt/c/Assembler/7-seminar/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/c/Assembler/7-seminar /mnt/c/Assembler/7-seminar /mnt/c/Assembler/7-seminar/cmake-build-debug /mnt/c/Assembler/7-seminar/cmake-build-debug /mnt/c/Assembler/7-seminar/cmake-build-debug/CMakeFiles/7_seminar.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/7_seminar.dir/depend

