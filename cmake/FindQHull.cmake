# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED QHull_FOUND)
return()
endif()


set(EP_QHULL QHull)
ExternalProject_Add(
    ${EP_QHULL}

    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${EP_QHULL}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_QHULL}-build
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_QHULL}

    URL http://www.qhull.org/download/qhull-2020-src-8.0.0.tgz
    URL_HASH SHA256=1ac92a5538f61e297c72aebe4d4ffd731ceb3e6045d6d15faf1c212713798df4

    CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
)
ExternalProject_Get_Property(${EP_QHULL} INSTALL_DIR)
set(QHull_EP_NAME ${EP_QHULL})
set(QHull_ROOT_DIR ${INSTALL_DIR})
set(QHull_INCLUDE_DIRS ${INSTALL_DIR}/include)
set(QHull_LIBRARIES ${INSTALL_DIR}/lib/libqhull.so)


find_package_handle_standard_args(
    QHull
    REQUIRED_VARS
        QHull_EP_NAME
        QHull_ROOT_DIR
        QHull_INCLUDE_DIRS
        QHull_LIBRARIES
)
