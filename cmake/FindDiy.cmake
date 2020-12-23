# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED Diy_FOUND)
return()
endif()


find_package(DecafJustSource REQUIRED)


set(EP_DIY Diy)
ExternalProject_Add(
    ${EP_DIY}

    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${EP_DIY}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_DIY}-build
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_DIY}

    GIT_REPOSITORY https://github.com/diatomic/diy.git
    GIT_TAG 81d28770e4a4fe2f125a8170b0d43ff39b012cd9  # Oct 22, 2020, 11:46 AM EDT
    
    PATCH_COMMAND rm -rf <SOURCE_DIR>/include/diy/thirdparty/fmt
    COMMAND cp -r ${DecafJustSource_ROOT_DIR}/include/fmt <SOURCE_DIR>/include/diy/thirdparty/fmt

    CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -Dbuild_examples:BOOL=OFF
        -Dbuild_tests:BOOL=OFF
)
ExternalProject_Add_StepDependencies(${EP_DIY} build ${EP_DECAF_JUST_SOURCE})
ExternalProject_Get_Property(${EP_DIY} INSTALL_DIR)
set(Diy_EP_NAME ${EP_DIY})
set(Diy_ROOT_DIR ${INSTALL_DIR})
set(Diy_INCLUDE_DIRS ${INSTALL_DIR}/include)


find_package_handle_standard_args(
    Diy
    REQUIRED_VARS
        Diy_EP_NAME
        Diy_ROOT_DIR
        Diy_INCLUDE_DIRS
)
