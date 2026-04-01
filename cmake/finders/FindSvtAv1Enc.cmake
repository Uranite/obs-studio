#[=======================================================================[.rst
FindSvtAv1Enc
----------

FindModule for SvtAv1Enc (SVT-AV1 Encoder) library

Imported Targets
^^^^^^^^^^^^^^^^

This module defines the :prop_tgt:`IMPORTED` target ``SvtAv1Enc::SvtAv1Enc``.

Result Variables
^^^^^^^^^^^^^^^^

This module sets the following variables:

``SvtAv1Enc_FOUND``
  True, if all required components and the core library were found.
``SvtAv1Enc_VERSION``
  Detected version of found SvtAv1Enc library.

Cache variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``SvtAv1Enc_LIBRARY``
  Path to the library component of SvtAv1Enc.
``SvtAv1Enc_INCLUDE_DIR``
  Directory containing ``EbSvtAv1Enc.h``.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_search_module(PC_SvtAv1Enc QUIET SvtAv1Enc)
endif()

find_path(
  SvtAv1Enc_INCLUDE_DIR
  NAMES EbSvtAv1Enc.h
  HINTS ${PC_SvtAv1Enc_INCLUDE_DIRS}
  PATHS /usr/include /usr/local/include
  DOC "SvtAv1Enc include directory"
)

if(PC_SvtAv1Enc_VERSION VERSION_GREATER 0)
  set(SvtAv1Enc_VERSION ${PC_SvtAv1Enc_VERSION})
else()
  set(SvtAv1Enc_VERSION 0.0.0)
endif()

find_library(
  SvtAv1Enc_LIBRARY
  NAMES SvtAv1Enc libSvtAv1Enc
  HINTS ${PC_SvtAv1Enc_LIBRARY_DIRS}
  PATHS /usr/lib /usr/local/lib
  DOC "SvtAv1Enc location"
)

if(CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin|Windows")
  set(SvtAv1Enc_ERROR_REASON "Ensure that obs-deps is provided as part of CMAKE_PREFIX_PATH.")
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux|FreeBSD")
  set(SvtAv1Enc_ERROR_REASON "Ensure SvtAv1Enc libraries are available in local library paths.")
endif()

find_package_handle_standard_args(
  SvtAv1Enc
  REQUIRED_VARS SvtAv1Enc_LIBRARY SvtAv1Enc_INCLUDE_DIR
  VERSION_VAR SvtAv1Enc_VERSION
  REASON_FAILURE_MESSAGE "${SvtAv1Enc_ERROR_REASON}"
)
mark_as_advanced(SvtAv1Enc_INCLUDE_DIR SvtAv1Enc_LIBRARY)
unset(SvtAv1Enc_ERROR_REASON)

if(SvtAv1Enc_FOUND)
  if(NOT TARGET SvtAv1Enc::SvtAv1Enc)
    if(IS_ABSOLUTE "${SvtAv1Enc_LIBRARY}")
      add_library(SvtAv1Enc::SvtAv1Enc UNKNOWN IMPORTED)
      set_property(TARGET SvtAv1Enc::SvtAv1Enc PROPERTY IMPORTED_LOCATION "${SvtAv1Enc_LIBRARY}")
    else()
      add_library(SvtAv1Enc::SvtAv1Enc INTERFACE IMPORTED)
      set_property(TARGET SvtAv1Enc::SvtAv1Enc PROPERTY IMPORTED_LIBNAME "${SvtAv1Enc_LIBRARY}")
    endif()

    set_target_properties(
      SvtAv1Enc::SvtAv1Enc
      PROPERTIES
        INTERFACE_COMPILE_OPTIONS "${PC_SvtAv1Enc_CFLAGS_OTHER}"
        INTERFACE_INCLUDE_DIRECTORIES "${SvtAv1Enc_INCLUDE_DIR}"
        VERSION ${SvtAv1Enc_VERSION}
    )
  endif()
endif()

include(FeatureSummary)
set_package_properties(
  SvtAv1Enc
  PROPERTIES
    URL "https://gitlab.com/AOMediaCodec/SVT-AV1"
    DESCRIPTION "Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)"
)
