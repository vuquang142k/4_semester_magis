cmake_minimum_required(VERSION 3.20)
project(Lab_01 LANGUAGES C CXX CUDA)

# Find and require the CUDA Toolkit
#set (CMAKE_CUDA_COMPILER "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.8/bin/nvcc.exe")
find_package(CUDAToolkit REQUIRED)

# Set project-wide properties and CUDA architectures
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CUDA_ARCHITECTURES 75)  # Adjust this value to match your GPU architecture.
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Wno-deprecated-gpu-targets")

# Optionally, add debug flags if you want to replicate makefile's debug logic
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -G")
endif()

# Include directories, if your makefile includes additional directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Define the sources exactly as in your makefile
set(SOURCES
    matmulKernel.cu
    matmulMain.cpp
)

# Create the executable target with these sources
add_executable(matmul ${SOURCES})

# Add CUDA-specific compile options (e.g., enable extended lambda support)
target_compile_options(matmul PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)

# Set the required C++ and CUDA standards
target_compile_features(matmul PRIVATE cxx_std_17 cuda_std_17)

# Enable CUDA separable compilation if needed (useful for multi-translation unit projects)
set_target_properties(matmul PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

# Include CUDA toolkit directories and link against CUDA libraries
target_include_directories(matmul PRIVATE ${CUDAToolkit_INCLUDE_DIRS})
target_link_libraries(matmul PRIVATE ${CUDAToolkit_LIBRARIES})
