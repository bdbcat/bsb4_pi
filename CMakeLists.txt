##---------------------------------------------------------------------------
## Author:      Pavel Kalian Dave Register
## Copyright:
## License:     wxWidgets License
##---------------------------------------------------------------------------

# define minimum cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.6.2)

PROJECT(bsb4_pi)

SET(PACKAGE_NAME bsb4_pi)
SET(VERBOSE_NAME BSB4ChartPlugin)
SET(TITLE_NAME BSB4ChartPlugin)
SET(CPACK_PACKAGE_CONTACT "Dave Register")

SET(OCPN_MIN_VERSION "ov50")

SET(VERSION_MAJOR "1")
SET(VERSION_MINOR "5")

#SET(CMAKE_BUILD_TYPE Debug)

SET (CMAKE_BUILD_TYPE Release)
# Prefer libGL.so to libOpenGL.so, see CMP0072
set(OpenGL_GL_PREFERENCE "LEGACY")

INCLUDE_DIRECTORIES(BEFORE ${PROJECT_SOURCE_DIR}/api-16)
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
