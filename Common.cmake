macro(gen_link_name_for_app)
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(LINK_NAME "${PROJECT_NAME}-d")
    else ()
        set(LINK_NAME "${PROJECT_NAME}")
    endif ()
endmacro()

macro(gen_link_name_for_lib)
    if (CMAKE_HOST_WIN32)
        set(LINK_NAME "lib${PROJECT_NAME}-${PROJECT_VERSION}")
    else ()
        set(LINK_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
    endif ()

    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(LINK_NAME "${LINK_NAME}-d")
    endif ()

    set(LIB_FOR_TEST ${LINK_NAME} CACHE INTERNAL "lib for test")
endmacro()

macro(gen_link_name_for_test)
    if (CMAKE_BUILD_TYPE MATCHES "Debug")
        set(LINK_NAME_FOR_TEST "${PROJECT_NAME}-d")
    else ()
        set(LINK_NAME_FOR_TEST "${PROJECT_NAME}")
    endif ()
endmacro()

macro(use_qt5)
    if (NOT DEFINED CMAKE_BUILD_TYPE)
        MESSAGE(FATAL_ERROR "CMAKE_BUILD_TYPE not defined! It must be defined as 'Debug' or 'Release'!")
    endif ()

    set(CMAKE_SKIP_BUILD_RPATH ON)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_STANDARD 17)

    set(CMAKE_AUTOUIC ON)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    set(QT5_COMPONENTS ${ARGN} CACHE INTERNAL "qt5 components")

    foreach (COMP IN LISTS QT5_COMPONENTS)
        find_package(QT NAMES Qt5 COMPONENTS ${COMP} REQUIRED)
        find_package(Qt5 COMPONENTS ${COMP} REQUIRED)
    endforeach ()
endmacro()
macro(link_qt5)
    foreach (COMP IN LISTS QT5_COMPONENTS)
        if (LINK_NAME)
            target_link_libraries(${LINK_NAME} PRIVATE Qt5::${COMP})
        else ()
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::${COMP})
        endif ()
    endforeach ()
endmacro()

macro(use_qt5_for_test)
    if (NOT DEFINED CMAKE_BUILD_TYPE)
        message(FATAL_ERROR "CMAKE_BUILD_TYPE not defined! It must be defined as 'Debug' or 'Release'!")
    endif ()

    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_STANDARD 17)

    set(CMAKE_AUTOUIC ON)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    set(QT5_COMPONENTS ${ARGN} CACHE INTERNAL "qt5 components for tests")

    foreach (COMP IN LISTS QT5_COMPONENTS_FOR_TEST)
        find_package(QT NAMES Qt5 COMPONENTS ${COMP} REQUIRED)
        find_package(Qt5 COMPONENTS ${COMP} REQUIRED)
    endforeach ()
endmacro()
macro(link_qt5_for_test)
    foreach (COMP IN LISTS QT5_COMPONENTS_FOR_TEST)
        if (LINK_NAME)
            target_link_libraries(${LINK_NAME_FOR_TEST} PRIVATE Qt5::${COMP})
        else ()
            target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::${COMP})
        endif ()
    endforeach ()
endmacro()

macro(link_lib_for_test)
    if (LIB_FOR_TEST)
        if (LINK_NAME_FOR_TEST)
            if (CMAKE_HOST_WIN32)
                target_link_libraries(${LINK_NAME_FOR_TEST} PRIVATE ${LIB_FOR_TEST})
            else ()
                target_link_libraries(${LINK_NAME_FOR_TEST} PRIVATE ${LIB_FOR_TEST})
            endif ()
        endif ()
    endif ()
endmacro()

// todo: include_thirdparty_lib
// todo: link_thirdparty_lib
// todo: use_cbb
// todo: link_cbb
// todo: link_cbb_for_test
// todo: link_lib_for_test

macro(build_with_windows_subsystem)
    if (WIN32)
        if (LINK_NAME)
            set_target_properties(${LINK_NAME} PROPERTIES LINK_FLAGS "/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")
        else()
            set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")
        endif ()
    endif ()
endmacro()
