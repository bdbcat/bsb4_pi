##---------------------------------------------------------------------------
## Author:      Pavel Kalian Dave Register
## Copyright:
## License:     wxWidgets License
##---------------------------------------------------------------------------

# define minimum cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.6.2)
CMAKE_POLICY(SET CMP0037 NEW)

PROJECT(bsb4_pi)

SET(PACKAGE_NAME bsb4_pi)
SET(VERBOSE_NAME BSB4ChartPlugin)
SET(TITLE_NAME BSB4ChartPlugin)
SET(CPACK_PACKAGE_CONTACT "Dave Register")

SET(OCPN_MIN_VERSION "ov50")

SET(VERSION_MAJOR "1")
SET(VERSION_MINOR "5")
SET(VERSION_PATCH "0")

SET(PACKAGE_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")
SET(PKG_RELEASE "1")
SET(PKG_API_VERSION "1.16")
SET(PKG_AUTHOR "David S Register")
SET(PKG_NVR ${PACKAGE_NAME}-${PACKAGE_VERSION}-${PKG_RELEASE})
SET(PKG_BASE_URL "https://dl.cloudsmith.io/public/alec-leamas/opencpn-plugins-unstable/raw/files")

include("cmake/PluginSetup.cmake")
set(PLUGIN_NAME bsb4-plugin-${PKG_TARGET}-${PKG_TARGET_VERSION})

SET (CMAKE_BUILD_TYPE Release)
# Prefer libGL.so to libOpenGL.so, see CMP0072
set(OpenGL_GL_PREFERENCE "LEGACY")


if (OCPN_FLATPAK)
    find_program(TAR NAMES gtar tar)
    if (NOT TAR)
        message(FATAL_ERROR "tar not found, required for OCPN_FLATPAK")
    endif ()
    configure_file(
        ${CMAKE_SOURCE_DIR}/bsb4-plugin.xml.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PLUGIN_NAME}.xml
    )
    add_custom_target(flatpak-build ALL
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/flatpak
        COMMAND flatpak-builder --force-clean
            ${CMAKE_CURRENT_BINARY_DIR}/app
            org.opencpn.OpenCPN.Plugin.bsb4.yaml
    )
    add_custom_target("flatpak-pkg")
    add_custom_command(
        TARGET flatpak-pkg
        COMMAND ${TAR}
            -czf ${PKG_NVR}_${PKG_TARGET_NVR}.tar.gz
            --transform 's|.*/files/|bsb4_pi-flatpak-${PACKAGE_VERSION}/|'
            ${CMAKE_CURRENT_BINARY_DIR}/app/files
    )
    return ()
endif()


INCLUDE_DIRECTORIES(BEFORE ${PROJECT_SOURCE_DIR}/api-16)
LINK_DIRECTORIES(${PROJECT_SOURCE_DIR}/api-16)

INCLUDE("cmake/PluginConfigure.cmake")
set(CMAKE_CXX_STANDARD 11)

SET(SRC_BSB4
            src/bsb4_pi.h
            src/bsb4_pi.cpp
            src/chart.cpp
            src/chart.h
            src/ellipse.c
     )
ADD_LIBRARY(${PACKAGE_NAME} SHARED ${SRC_BSB4})



INCLUDE("cmake/PluginInstall.cmake")
INCLUDE("cmake/PluginLocalization.cmake")
INCLUDE("cmake/PluginPackage.cmake")

message(STATUS "Build target: ${PKG_TARGET}-${PKG_TARGET_VERSION}")
configure_file(
  ${CMAKE_SOURCE_DIR}/bsb4-plugin.xml.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PLUGIN_NAME}.xml
)
