

if((NOT BLAZE1_INCLUDE_DIR) AND Blaze_SOURCE_DIR)
  # unless BLAZE1_INCLUDE_DIR is defined, let's use current Blaze version
  set(BLAZE1_INCLUDE_DIR ${Blaze_SOURCE_DIR})
  set(BLAZE1_FOUND TRUE)
else()
  find_package(Blaze1)
endif()

if (BLAZE1_FOUND)

  include_directories(${BLAZE1_INCLUDE_DIR})
  btl_add_bench(btl_blaze1_linear main_linear.cpp)
  btl_add_bench(btl_blaze1_vecmat main_vecmat.cpp)
  btl_add_bench(btl_blaze1_matmat main_matmat.cpp)

  btl_add_target_property(btl_blaze1_linear COMPILE_FLAGS "-DBTL_PREFIX=blaze1")
  btl_add_target_property(btl_blaze1_vecmat COMPILE_FLAGS "-DBTL_PREFIX=blaze1")
  btl_add_target_property(btl_blaze1_matmat COMPILE_FLAGS "-DBTL_PREFIX=blaze1")

  option(BTL_BENCH_NOGCCVEC "also bench Blaze explicit vec without GCC's auto vec" OFF)
  if(CMAKE_COMPILER_IS_GNUCXX AND BTL_BENCH_NOGCCVEC)
    btl_add_bench(btl_blaze1_nogccvec_linear main_linear.cpp)
    btl_add_bench(btl_blaze1_nogccvec_vecmat main_vecmat.cpp)
    btl_add_bench(btl_blaze1_nogccvec_matmat main_matmat.cpp)

    btl_add_target_property(btl_blaze1_nogccvec_linear COMPILE_FLAGS "-fno-tree-vectorize -DBTL_PREFIX=blaze1_nogccvec")
    btl_add_target_property(btl_blaze1_nogccvec_vecmat COMPILE_FLAGS "-fno-tree-vectorize -DBTL_PREFIX=blaze1_nogccvec")
    btl_add_target_property(btl_blaze1_nogccvec_matmat COMPILE_FLAGS "-fno-tree-vectorize -DBTL_PREFIX=blaze1_nogccvec")
  endif()


  if(NOT BTL_NOVEC)
    btl_add_bench(btl_blaze1_novec_linear main_linear.cpp OFF)
    btl_add_bench(btl_blaze1_novec_vecmat main_vecmat.cpp OFF)
    btl_add_bench(btl_blaze1_novec_matmat main_matmat.cpp OFF)
    btl_add_target_property(btl_blaze1_novec_linear COMPILE_FLAGS "-DEIGEN_DONT_VECTORIZE -DBTL_PREFIX=blaze1_novec")
    btl_add_target_property(btl_blaze1_novec_vecmat COMPILE_FLAGS "-DEIGEN_DONT_VECTORIZE -DBTL_PREFIX=blaze1_novec")
    btl_add_target_property(btl_blaze1_novec_matmat COMPILE_FLAGS "-DEIGEN_DONT_VECTORIZE -DBTL_PREFIX=blaze1_novec")
  endif(NOT BTL_NOVEC)

  btl_add_bench(btl_tiny_blaze1 btl_tiny_blaze1.cpp OFF)

  if(NOT BTL_NOVEC)
    btl_add_bench(btl_tiny_blaze1_novec btl_tiny_blaze1.cpp OFF)
    btl_add_target_property(btl_tiny_blaze1_novec    COMPILE_FLAGS "-DBTL_PREFIX=blaze1_tiny")

    if(BUILD_btl_tiny_blaze1_novec)
      btl_add_target_property(btl_tiny_blaze1_novec    COMPILE_FLAGS "-DEIGEN_DONT_VECTORIZE -DBTL_PREFIX=blaze1_tiny_novec")
    endif(BUILD_btl_tiny_blaze1_novec)
  endif(NOT BTL_NOVEC)

endif (BLAZE1_FOUND)
