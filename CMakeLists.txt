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

SET(VERSION_MAJOR "1")
SET(VERSION_MINOR "5")

#SET(CMAKE_BUILD_TYPE Debug)
SET (CMAKE_BUILD_TYPE Release)

INCLUDE("cmake/PluginConfigure.cmake")

SET(SRC_BSB4
            src/bsb4_pi.h
            src/bsb4_pi.cpp
            src/chart.cpp
            src/chart.h
            src/ellipse.c
     )
ADD_LIBRARY(${PACKAGE_NAME} SHARED ${SRC_BSB4})

IF(WIN32)
  SET(OPENCPN_IMPORT_LIB "C:/Projects/opencpn/build/${CMAKE_CFG_INTDIR}/opencpn.lib")
  TARGET_LINK_LIBRARIES( ${PACKAGE_NAME} ${OPENCPN_IMPORT_LIB} )
ENDIF(WIN32)


INCLUDE("cmake/PluginInstall.cmake")
INCLUDE("cmake/PluginLocalization.cmake")
INCLUDE("cmake/PluginPackage.cmake")
