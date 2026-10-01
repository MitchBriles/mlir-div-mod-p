# CMake Written by Claude Opus 5.5 
cmake_minimum_required(VERSION 3.20)
# HandleLLVMOptions probes flags with the C compiler, so C must be enabled.
project(ModPAnalysis LANGUAGES C CXX)

# LLVM_DIR must match the build mlir-opt came from, or the plugin won't load.
set(LLVM_BUILD "" CACHE PATH "LLVM build tree containing mlir-opt")
if(NOT LLVM_BUILD)
  message(FATAL_ERROR "Set -DLLVM_BUILD=<path to an LLVM build with MLIR>")
endif()
set(MLIR_DIR "${LLVM_BUILD}/lib/cmake/mlir")
set(LLVM_DIR "${LLVM_BUILD}/lib/cmake/llvm")
find_package(MLIR REQUIRED CONFIG)

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}" "${LLVM_CMAKE_DIR}")
include(AddLLVM)
include(HandleLLVMOptions)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include_directories(SYSTEM ${LLVM_INCLUDE_DIRS} ${MLIR_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# MLIR symbols are left undefined and resolved from mlir-opt at load time.
add_llvm_library(ModPAnalysis MODULE ModPAnalysis.cpp PLUGIN_TOOL mlir-opt)
set_target_properties(ModPAnalysis PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

set(MLIR_OPT "${LLVM_TOOLS_BINARY_DIR}/mlir-opt")
if(NOT EXISTS "${MLIR_OPT}")
  message(FATAL_ERROR "mlir-opt not found in ${LLVM_TOOLS_BINARY_DIR}")
endif()

# Two steps: configure_file fills in @MLIR_OPT@, file(GENERATE) the plugin path.
configure_file(run.sh.in run.sh.in @ONLY)
file(GENERATE OUTPUT run.sh INPUT "${CMAKE_CURRENT_BINARY_DIR}/run.sh.in"
  FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                   GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
