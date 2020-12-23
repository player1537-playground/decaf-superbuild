# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED Decaf_FOUND)
return()
endif()


unset(_extra_cmake_cache_args)
unset(_extra_ep_deps)
unset(_libraries)
unset(_include_dirs)


set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_MULTHREADED ON)
set(Boost_USE_STATIC_RUNTIME OFF)
find_package(Boost 1.65.1 REQUIRED system serialization)
list(APPEND _libraries ${Boost_LIBRARIES})
list(APPEND _include_dirs ${Boost_INCLUDE_DIRS})


find_package(MPI)
list(APPEND _libraries ${MPI_C_LIBRARIES})
list(APPEND _include_dirs ${MPI_INCLUDE_PATH})


if("Henson" IN_LIST Decaf_FIND_COMPONENTS)
    find_package(Henson REQUIRED)

    list(APPEND _extra_cmake_cache_args
        -DHENSON_INCLUDE_DIR:PATH=${Henson_ROOT_DIR}
        -DHENSON_LIBRARY:PATH=${Henson_LIBRARIES}
        -Dbuild_examples_henson:BOOL=ON
    )
    list(APPEND _extra_ep_deps
        ${Henson_EP_NAME}
    )
    list(APPEND _libraries ${Henson_LIBRARIES})
    list(APPEND _include_dirs ${Henson_INCLUDE_DIRS})
else()
    list(APPEND _extra_cmake_cache_args
        -Dbuild_examples_henson:BOOL=OFF
    )
endif()


if("TessDense" IN_LIST Decaf_FIND_COMPONENTS)
    find_package(Tess REQUIRED)
    find_package(QHull REQUIRED)
    find_package(Diy REQUIRED)

    list(APPEND _extra_cmake_cache_args
        -DTESS_INCLUDE_DIR:PATH=${Tess_INCLUDE_DIRS}
        -DTESS_LIBRARY:PATH=${Tess_LIBRARIES}
        -DQHull_LIBRARY:PATH=${QHull_LIBRARIES}
        -DDIY_INCLUDE_DIR:PATH=${Diy_INCLUDE_DIRS}
        -Dserial:STRING=QHull
        -Dbuild_examples_tess_dense:BOOL=ON
    )
    list(APPEND _extra_ep_deps
        ${Tess_EP_NAME}
        ${QHull_EP_NAME}
        ${Diy_EP_NAME}
    )
else()
    list(APPEND _extra_cmake_cache_args
        -Dbuild_examples_tess_dense:BOOL=OFF
    )
endif()


if("FermiHEP" IN_LIST Decaf_FIND_COMPONENTS)
    list(APPEND _extra_cmake_cache_args
        -Dbuild_examples_fermi_hep:BOOL=ON
    )
else()
    list(APPEND _extra_cmake_cache_args
        -Dbuild_examples_fermi_hep:BOOL=OFF
    )
endif()


if("Python" IN_LIST Decaf_FIND_COMPONENTS)
    # nothing needed
else()
    # nothing needed
endif()


set(EP_DECAF Decaf)
ExternalProject_Add(
    ${EP_DECAF}

    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${EP_DECAF}
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_DECAF}-build
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${EP_DECAF}

    GIT_REPOSITORY https://bitbucket.org/tpeterka1/decaf.git
    GIT_TAG decaf-henson

    CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        ${_extra_cmake_cache_args}
)
ExternalProject_Add_StepDependencies(${EP_DECAF} build ${_extra_ep_deps})
ExternalProject_Get_Property(${EP_DECAF} INSTALL_DIR)
ExternalProject_Get_Property(${EP_DECAF} SOURCE_DIR)
set(Decaf_EP_NAME ${EP_DECAF})
set(Decaf_ROOT_DIR ${INSTALL_DIR})
set(Decaf_INCLUDE_DIRS
    ${INSTALL_DIR}/include
    ${SOURCE_DIR}/include
)
set(Decaf_LIBRARY_DIRS ${INSTALL_DIR}/lib)
set(Decaf_LIBRARIES
    ${INSTALL_DIR}/lib/libdecaf.a
    ${INSTALL_DIR}/lib/libbredala_transport_mpi.so
    ${INSTALL_DIR}/lib/libbredala_datamodel.so
    ${INSTALL_DIR}/lib/libdca.so
    ${INSTALL_DIR}/lib/libmanala.so
)
set(Decaf_DEFINITIONS -DTRANSPORT_MPI=1)



if("Henson" IN_LIST Decaf_FIND_COMPONENTS)
    set(Decaf_Henson_EXECUTABLE ${INSTALL_DIR}/examples/henson/python/decaf-henson_python)
    set(Decaf_Henson_FOUND ON)
endif()


if("TessDense" IN_LIST Decaf_FIND_COMPONENTS)
    set(Decaf_TessDense_FOUND ON)
endif()


if("FermiHEP" IN_LIST Decaf_FIND_COMPONENTS)
    set(Decaf_FermiHEP_FOUND ON)
endif()


if("Python" IN_LIST Decaf_FIND_COMPONENTS)
    set(Decaf_Python_EXECUTABLE ${INSTALL_DIR}/python/decaf.py)
    set(Decaf_Python_FOUND ON)
endif()


add_library(Decaf::Decaf IMPORTED INTERFACE)
target_include_directories(
    Decaf::Decaf
    INTERFACE
        ${Decaf_INCLUDE_DIRS}
        ${_include_dirs}
)
target_link_libraries(
    Decaf::Decaf
    INTERFACE
        ${Decaf_LIBRARIES}
        ${_libraries}
)
target_compile_definitions(
    Decaf::Decaf
    INTERFACE
        ${Decaf_DEFINITIONS}
)


configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/decaf-henson_python.in
    ${CMAKE_CURRENT_BINARY_DIR}/decaf-henson_python
    @ONLY
)


find_package_handle_standard_args(
    Decaf
    REQUIRED_VARS
        Decaf_EP_NAME
        Decaf_ROOT_DIR
    HANDLE_COMPONENTS
)
