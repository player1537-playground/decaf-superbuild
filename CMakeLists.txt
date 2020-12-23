# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
project(DecafCCGrid2021)


list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)


set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED ON)
find_package(Decaf REQUIRED COMPONENTS Henson TessDense Python)


foreach(_part evaluate steer visualize)
    add_library(
        ${_part}
        SHARED
            src/${_part}.cpp
    )
    target_link_libraries(
        ${_part}
        PRIVATE
            Decaf::Decaf
    )
endforeach()


configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/topology.py.in
    ${CMAKE_CURRENT_BINARY_DIR}/topology.py
    @ONLY
)
