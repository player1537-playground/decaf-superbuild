# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED Henson_FOUND)
return()
endif()


set(EP_HENSON Henson)
ExternalProject_Add(
    ${EP_HENSON}

    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${EP_HENSON}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_HENSON}-build
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_HENSON}

    GIT_REPOSITORY https://github.com/henson-insitu/henson.git
    GIT_TAG e6584dd2275b1ab208a5dd759148513f741e8bef  # Jun 8, 2020, 4:23 PM EDT

    CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DPYBIND11_PYTHON_VERSION:STRING=3.6
)
ExternalProject_Get_Property(${EP_HENSON} INSTALL_DIR)
set(Henson_EP_NAME ${EP_HENSON})
set(Henson_ROOT_DIR ${INSTALL_DIR})
set(Henson_INCLUDE_DIRS ${INSTALL_DIR}/include)
set(Henson_LIBRARIES ${INSTALL_DIR}/lib/libhenson.a)


find_package_handle_standard_args(
    Henson
    REQUIRED_VARS
        Henson_EP_NAME
        Henson_ROOT_DIR
        Henson_INCLUDE_DIRS
        Henson_LIBRARIES
)
