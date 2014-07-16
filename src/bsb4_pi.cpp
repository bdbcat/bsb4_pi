/******************************************************************************
 * $Id: grib_pi.cpp,v 1.8 2010/06/21 01:54:37 bdbcat Exp $
 *
 * Project:  OpenCPN
 * Purpose:  GRIB Plugin
 * Author:   David Register
 *
 ***************************************************************************
 *   Copyright (C) 2010 by David S. Register   *
 *   $EMAIL$   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************
 */


#include "wx/wxprec.h"

#ifndef  WX_PRECOMP
  #include "wx/wx.h"
#endif //precompiled headers

//#include <vld.h>

#include "bsb4_pi.h"
#include "chart.h"


// the class factories, used to create and destroy instances of the PlugIn

extern "C" DECL_EXP opencpn_plugin* create_pi(void *ppimgr)
{
    return new bsb4_pi(ppimgr);
}

extern "C" DECL_EXP void destroy_pi(opencpn_plugin* p)
{
    delete p;
}





//---------------------------------------------------------------------------------------------------------
//
//    PlugIn Implementation
//
//---------------------------------------------------------------------------------------------------------

#include "default_pi.xpm"


//---------------------------------------------------------------------------------------------------------
//
//          PlugIn initialization and de-init
//
//---------------------------------------------------------------------------------------------------------

bsb4_pi::bsb4_pi(void *ppimgr)
      :opencpn_plugin(ppimgr)
{
      // Create the PlugIn icons

      m_pplugin_icon = new wxBitmap(default_pi);
}

bsb4_pi::~bsb4_pi()
{
      delete m_pplugin_icon;
}

int bsb4_pi::Init(void)
{

      AddLocaleCatalog( _T("opencpn-bsb4_pi") );

      //    Build an arraystring of dynamically loadable chart class names
      m_class_name_array.Add(_T("ChartBSB4"));

      return (INSTALLS_PLUGIN_CHART);

}

bool bsb4_pi::DeInit(void)
{
      return true;
}

int bsb4_pi::GetAPIVersionMajor()
{
      return MY_API_VERSION_MAJOR;
}

int bsb4_pi::GetAPIVersionMinor()
{
      return MY_API_VERSION_MINOR;
}

int bsb4_pi::GetPlugInVersionMajor()
{
      return PLUGIN_VERSION_MAJOR;
}

int bsb4_pi::GetPlugInVersionMinor()
{
      return PLUGIN_VERSION_MINOR;
}

wxBitmap *bsb4_pi::GetPlugInBitmap()
{
      return m_pplugin_icon;
}

wxString bsb4_pi::GetCommonName()
{
      return _("BSB4");
}


wxString bsb4_pi::GetShortDescription()
{
      return _("BSB4 PlugIn for OpenCPN");
}


wxString bsb4_pi::GetLongDescription()
{
      return _("BSB4 PlugIn for OpenCPN\n\
Provides support of BSB Version 4 Raster charts.\n\n\
Supported charts must have been installed with \n\
appropriate encryption certificates in place.\n\
");

}

wxArrayString bsb4_pi::GetDynamicChartClassNameArray()
{
      return m_class_name_array;
}


