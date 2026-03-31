# OBS CMake common compiler options module

include_guard(GLOBAL)

option(OBS_COMPILE_DEPRECATION_AS_WARNING "Downgrade deprecation warnings to actual warnings" FALSE)
mark_as_advanced(OBS_COMPILE_DEPRECATION_AS_WARNING)

# Set C and C++ language standards to C17 and C++17
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

# Set symbols to be hidden by default for C and C++
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)

# clang options for C, C++, ObjC, and ObjC++
set(
  _obs_clang_common_options
  -fno-strict-aliasing
  -Wno-trigraphs
  -Wno-missing-field-initializers
  -Wno-missing-prototypes
  -Werror=return-type
  -Wno-unreachable-code
  -Wno-quoted-include-in-framework-header
  -Wno-missing-braces
  -Wno-parentheses
  -Wno-switch
  -Wno-microsoft-cast
  -Wno-microsoft-string-literal-from-predefined
  -Wno-macro-redefined
  -Wno-incompatible-function-pointer-types
  -Wno-incompatible-pointer-types
  -Wno-nontrivial-memcall
  -Wno-bitwise-op-parentheses
  -Wno-ignored-attributes
  -Wno-reorder-ctor
  -Wno-four-char-constants
  -Wno-visibility
  -Wno-deprecated-declarations
  -Wno-enum-compare-conditional
  -Wno-reserved-macro-identifier
  -Wno-zero-as-null-pointer-constant
  -Wno-old-style-cast
  -Wno-gnu-anonymous-struct
  -Wno-c++98-compat-pedantic
  -Wno-int-to-pointer-cast
  -Wno-switch-default
  -Wno-switch-enum
  -Wno-nested-anon-types
  -Wno-documentation
  -Wno-documentation-deprecated-sync
  -Wno-unqualified-std-cast-call
  -Wno-pessimizing-move
  -Wno-reserved-identifier
  -Wno-documentation-unknown-command
  -Wno-gnu-zero-variadic-macro-arguments
  -Wno-disabled-macro-expansion
  -Wno-unused-function
  -Wno-unused-label
  -Wno-unused-parameter
  -Wno-unused-variable
  -Wno-unused-but-set-variable
  -Wno-unused-local-typedef
  -Wno-unused-value
  -Wempty-body
  -Wuninitialized
  -Wno-unknown-pragmas
  -Wconstant-conversion
  -Wno-conversion
  -Wno-int-conversion
  -Wno-bool-conversion
  -Wno-enum-conversion
  -Wno-non-literal-null-conversion
  -Wno-sign-compare
  -Wno-shorten-64-to-32
  -Wno-pointer-sign
  -Wno-newline-eof
  -Wno-implicit-fallthrough
  -Wno-sign-conversion
  -Winfinite-recursion
  -Wno-comma
  -Wno-strict-prototypes
  -Wno-semicolon-before-method-body
  -Wformat-security
  -Wvla
  -Wno-error=shorten-64-to-32
  $<$<BOOL:${OBS_COMPILE_DEPRECATION_AS_WARNING}>:-Wno-error=deprecated-declarations>
)

# clang options for C
set(_obs_clang_c_options ${_obs_clang_common_options} -Wno-shadow -Wno-float-conversion)

# clang options for C++
set(
  _obs_clang_cxx_options
  ${_obs_clang_common_options}
  -Wno-non-virtual-dtor
  -Wno-overloaded-virtual
  -Wno-exit-time-destructors
  -Wno-shadow
  -Winvalid-offsetof
  -Wmove
  -Werror=block-capture-autoreleasing
  -Wrange-loop-analysis
  -Wno-inconsistent-missing-override
  -Wno-unused-private-field
  -Wno-delete-non-abstract-non-virtual-dtor
)

if(CMAKE_CXX_STANDARD GREATER_EQUAL 20)
  list(APPEND _obs_clang_cxx_options -fno-char8_t)
endif()

if(NOT DEFINED CMAKE_COMPILE_WARNING_AS_ERROR)
  set(CMAKE_COMPILE_WARNING_AS_ERROR OFF)
endif()

# Enable interprocedural optimization
message(STATUS "Checking for interprocedural optimization support")
if(NOT DEFINED HAS_INTERPROCEDURAL_OPTIMIZATION)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT _ipo_result OUTPUT _ipo_output)
  set(
    HAS_INTERPROCEDURAL_OPTIMIZATION
    ${_ipo_result}
    CACHE BOOL
    "Result of compiler check for interprocedural optimization"
    FORCE
  )

  if(HAS_INTERPROCEDURAL_OPTIMIZATION)
    message(STATUS "Checking for interprocedural optimization support - available")
  else()
    message(STATUS "Checking for interprocedural optimization support - unavailable")
  endif()

  mark_as_advanced(HAS_INTERPROCEDURAL_OPTIMIZATION)
  unset(_ipo_result)
  unset(_ipo_output)
endif()

if(HAS_INTERPROCEDURAL_OPTIMIZATION)
  message(STATUS "Checking for interprocedural optimization support - enabled [Release, MinSizeRel]")
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_DEBUG OFF)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELWITHDEBINFO OFF)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_MINSIZEREL ON)
else()
  message(STATUS "Checking for interprocedural optimization support - disabled")
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_DEBUG OFF)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELWITHDEBINFO OFF)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE OFF)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_MINSIZEREL OFF)
endif()
