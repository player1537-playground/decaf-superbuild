# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED Tess_FOUND)
return()
endif()


find_package(QHull REQUIRED)
find_package(Diy REQUIRED)


set(EP_TESS Tess)
ExternalProject_Add(
    ${EP_TESS}

    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${EP_TESS}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_TESS}-build
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_TESS}

    GIT_REPOSITORY https://github.com/diatomic/tess2.git
    GIT_TAG ba601f0bdd881284e38fd233961ace7022713911  # Nov 23, 2020, 3:16 PM EST

    CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -Dserial:STRING=QHull
        -DDIY_INCLUDE_DIRS:PATH=${Diy_INCLUDE_DIRS}
        -DQHull_INCLUDE_DIRS:PATH=${QHull_INCLUDE_DIRS}/libqhull
        -DQHull_LIBRARY:PATH=${QHull_LIBRARIES}
)
ExternalProject_Add_StepDependencies(${EP_TESS} build ${QHull_EP_NAME} ${Diy_EP_NAME})
ExternalProject_Get_Property(${EP_TESS} INSTALL_DIR)
set(Tess_EP_NAME ${EP_TESS})
set(Tess_ROOT_DIR ${INSTALL_DIR})
set(Tess_INCLUDE_DIRS ${INSTALL_DIR}/include)
set(Tess_LIBRARIES ${INSTALL_DIR}/lib/libtess.a)


find_package_handle_standard_args(
    Tess
    REQUIRED_VARS
        Tess_EP_NAME
        Tess_ROOT_DIR
        Tess_INCLUDE_DIRS
        Tess_LIBRARIES
)
