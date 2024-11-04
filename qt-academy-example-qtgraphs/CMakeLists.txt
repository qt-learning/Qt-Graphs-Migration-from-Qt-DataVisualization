cmake_minimum_required(VERSION 3.16)

project(qt-academy-example-qtgraphs VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appqt-academy-example-qtgraphs
    main.cpp
)

set_source_files_properties("../shared-assets/T5111G-korkeusmalli.jpg"
    PROPERTIES QT_RESOURCE_ALIAS "T5111G-korkeusmalli.jpg"
    )
set_source_files_properties("../shared-assets/T5111R-peruskarttarasteri.jpg"
    PROPERTIES QT_RESOURCE_ALIAS "T5111R-peruskarttarasteri.jpg"
    )
set_source_files_properties("../shared-assets/T5111G-rinnevarjoste.jpg"
    PROPERTIES QT_RESOURCE_ALIAS "T5111G-rinnevarjoste.jpg"
    )
set_source_files_properties("../shared-assets/T5111G-ortokuva.jpg"
    PROPERTIES QT_RESOURCE_ALIAS "T5111G-ortokuva.jpg"
    )
set(shared_resource_files
    ../shared-assets/T5111G-korkeusmalli.jpg
    ../shared-assets/T5111R-peruskarttarasteri.jpg
    ../shared-assets/T5111G-rinnevarjoste.jpg
    ../shared-assets/T5111G-ortokuva.jpg
    )

qt_add_qml_module(appqt-academy-example-qtgraphs
    URI QtAcademyExampleQtGraphs
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    QML_FILES
        Main.qml
        Marker.qml
    RESOURCES
        assets/marker.mesh
        ${shared_resource_files}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appqt-academy-example-qtgraphs PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appqt-academy-example-qtgraphs
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appqt-academy-example-qtgraphs
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appqt-academy-example-qtgraphs
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
