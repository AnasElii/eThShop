cmake_minimum_required(VERSION 3.21)
project(eThShop VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CXX_STANDARD 17)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_PREFIX_PATH $ENV{QTMSVCDIR})

# Enable qml debugging
#set(QML_IMPORT_TRACE TRUE)
#set(QML_IMPORT_PATH ${CMAKE_SOURCE_DIR}/interfaces)
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG")

# ========= Set directories
set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/src")
set(INCLUDE_DIR "${CMAKE_SOURCE_DIR}/include")
set(RESOURCE_DIR "${CMAKE_SOURCE_DIR}/resources")

# ========= Include directories
include_directories(${SOURCE_DIR})
include_directories(${INCLUDE_DIR})
include_directories(${RESOURCE_DIR})

# ========= Add directories files
file(GLOB_RECURSE SOURCES
    "${SOURCE_DIR}/*.cpp"
    "${INCLUDE_DIR}/*.h"
)

# ========= Include libraries
find_package(Qt6 COMPONENTS Core Gui Qml Quick QuickControls2 Network Widgets REQUIRED)

# ========= Add executable
qt_add_executable(${CMAKE_PROJECT_NAME}
    ${SOURCES}
)

# ========= Add Fonts to Sources
# Set the directory containing your font files
set(FONT_DIR ${RESOURCE_DIR}/fonts)

# Use file(GLOB ...) to get a list of font files
file(GLOB FONT_FILES ${FONT_DIR}/*.otf ${FONT_DIR}/*.ttf)

# Create a target to process and set the QT_RESOURCE_ALIAS property for each font file
foreach(FONT_FILE ${FONT_FILES})
    get_filename_component(FONT_NAME ${FONT_FILE} NAME)
    set_property(SOURCE ${FONT_FILE} PROPERTY QT_RESOURCE_ALIAS "fonts/${FONT_NAME}")
endforeach()

# ========= Add Icons to Sources
# Set the directory containing your icon files
set(ICON_DIR ${RESOURCE_DIR}/icons)

# Use file(GLOB ...) to get a list of icon files
file(GLOB ICON_FILES ${ICON_DIR}/*.svg ${ICON_DIR}/*.png)

# Create a target to process and set the QT_RESOURCE_ALIAS property for each icon file
foreach(ICON_FILE ${ICON_FILES})
    get_filename_component(ICON_NAME ${ICON_FILE} NAME)
    set_property(SOURCE ${ICON_FILE} PROPERTY QT_RESOURCE_ALIAS "icons/${ICON_NAME}")
endforeach()

# ========= Add Images to Sources
# Set the directory containing your images files
set(IMAGE_DIR ${RESOURCE_DIR}/images)

# Use file(GLOB ...) to get a list of images files
file(GLOB IMAGE_FILES ${IMAGE_DIR}/*.png ${IMAGE_DIR}/*.jpg ${IMAGE_DIR}/*.jpeg ${IMAGE_DIR}/*.svg)

# Create a target to process and set the QT_RESOURCE_ALIAS property for each images file
foreach(IMAGE_FILE ${IMAGE_FILES})
    get_filename_component(IMAGE_NAME ${IMAGE_FILE} NAME)
    set_property(SOURCE ${IMAGE_FILE} PROPERTY QT_RESOURCE_ALIAS "images/${IMAGE_NAME}")
endforeach()

# ========= Set Resources
set(RESOURCE_DIR

    # fonts
    ${FONT_FILES}
        
    # images
    ${IMAGE_FILES}

    # icons
    ${ICON_FILES}
    
)

# ========= Add qml medule
qt_add_qml_module(${CMAKE_PROJECT_NAME}
    URI mainLib
    VERSION 1.0
    QML_FILES
    # Pages
    interfaces/main.qml
    interfaces/HomePage.qml
    interfaces/ProductPage.qml
    interfaces/AddProductPage.qml
    interfaces/AddProductS2Page.qml
    interfaces/SearchPage.qml
    interfaces/UserPage.qml
    interfaces/MyProductPage.qml
    interfaces/FavoritePage.qml
    interfaces/SettingsPage.qml
    interfaces/LoginPage.qml
    interfaces/RegisterPage.qml
    interfaces/TypePage.qml
     interfaces/ProfileImagePage.qml
    # Components
    interfaces/components/MyCard.qml
    interfaces/components/MyButton.qml
    interfaces/components/MyIconButton.qml
    interfaces/components/MyIconText.qml
    interfaces/components/MyIconTextButton.qml
    interfaces/components/MySlideIcon.qml
    interfaces/components/MyUserInfo.qml
    interfaces/components/MyProfileWrapper.qml
    interfaces/components/MyHeader.qml
    interfaces/components/MySideMenu.qml
    interfaces/components/MyTextButton.qml
    interfaces/components/MyDialog.qml
    interfaces/components/MyStepBar.qml
    interfaces/components/MyImageUploadItem.qml
    interfaces/components/MyImageHolder.qml
    interfaces/components/MyCustomDialog.qml
    interfaces/components/MyNavBar.qml
    interfaces/components/MyTabBar.qml
    # Debug UI
    interfaces/components/InfoText.qml
    interfaces/AddImages.qml
    
    RESOURCES
    ${RESOURCE_DIR}
)

# ========= Configure Android package
if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    set_property(TARGET ${CMAKE_PROJECT_NAME} PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR ${ANDROID_PACKAGE_SOURCE_DIR})
    add_custom_target(cmake_android_package
        SOURCES
        ${ANDROID_PACKAGE_SOURCE_DIR}/AndroidManifest.xml
        ${ANDROID_PACKAGE_SOURCE_DIR}/build.gradle
        ${ANDROID_PACKAGE_SOURCE_DIR}/grable.properties
        ${ANDROID_PACKAGE_SOURCE_DIR}/res/values/libs.xml
    )

    # ========= Include openssl
    include(FetchContent)
    FetchContent_Declare(
        android_openssl
        DOWNLOAD_EXTRACT_TIMESTAMP true
        URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip

        # URL_HASH MD5=c97d6ad774fab16be63b0ab40f78d945 # optional
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)

    # include(D:/Dev/android_openssl/CMakeLists.txt)
endif()

# ========= Cnfigure iOS package
if(APPLE)
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
endif()

# ========= Link target subDirectories
target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC src)
target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC include)
target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC resources)

# ========= Link libraries
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::CorePrivate
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    Qt6::Network
)
