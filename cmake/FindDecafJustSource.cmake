# vim: sta:et:sw=4:ts=4:sts=4:ai

cmake_minimum_required(VERSION 3.11)
include(ExternalProject)
include(FindPackageHandleStandardArgs)


if(DEFINED DecafJustSource_FOUND)
return()
endif()


set(EP_DECAF_JUST_SOURCE DecafJustSource)
ExternalProject_Add(
    ${EP_DECAF_JUST_SOURCE}

    GIT_REPOSITORY https://bitbucket.org/tpeterka1/decaf.git
    GIT_TAG decaf-henson

    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""
)
ExternalProject_Get_Property(${EP_DECAF_JUST_SOURCE} SOURCE_DIR)
set(DecafJustSource_EP_NAME ${EP_DECAF_JUST_SOURCE})
set(DecafJustSource_ROOT_DIR ${SOURCE_DIR})


find_package_handle_standard_args(
    DecafJustSource
    REQUIRED_VARS
        DecafJustSource_EP_NAME
        DecafJustSource_ROOT_DIR
)
