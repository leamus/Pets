
QT += core gui
QT += qml quick     #QML和Quick
QT += sql           #数据库
QT += network       #网络
QT += multimedia    #多媒体
QT += sensors
QT += texttospeech  #文字转语音
#QT += webkitwidgets
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

#QT += websockets \
#    xml svg \
#    bluetooth nfc \
#    positioning location \
#    3dcore 3dinput 3dquick 3drender



#C++11支持lamda表达式
QMAKE_CXXFLAGS += -std=c++0x    #支持lambda表达式
CONFIG += c++11                 #支持lambda表达式
#CONFIG += console               #将输出到控制台

CONFIG += mobility
MOBILITY += sensors



CONFIG(debug, debug|release) {  #debug版本
#LIBS += -L../lib1 -lhellod
#LIBS += -L$$PWD/ -lxxx
#LIBS += -Lxxx -lyyy        #xxx是路径,yyy是lib/so名

#LIBS += -lwsock32


#RESOURCES += \
#    Res.qrc \
#    QML.qrc
}
else {          #release版本
#LIBS += -L../lib2 -lhello

#RESOURCES += \
#    Res.qrc \
#    QML.qrc

DEFINES += QT_MESSAGELOGCONTEXT #使Release版本输出的日志包含文件名、函数名和行数
#DEFINES+=QT_NO_DEBUG_OUTPUT    #屏蔽release版本中所有qDebug()提示信息
#DEFINES+=QT_NO_WARNING_OUTPUT
#DEFINES+=QT_NO_INFO_OUTPUT

#-W[no-]<警告选项>。例如代码：
QMAKE_CXXFLAGS += -Wno-unused-parameter #没有用到的参数变量
QMAKE_CXXFLAGS += -Wno-unused-variable  #没有用到的变量
QMAKE_CXXFLAGS += -Wunused-but-set-variable #没有用到的变量
QMAKE_CXXFLAGS += -Wno-sign-compare #忽略有符号比较?
#QMAKE_CXXFLAGS += -fpermissive

}

android {
    #QAndroidJniObject、QtAndroid 属于 androidextras 模块
    QT += androidextras

    #指定 安卓包路径(包含资源、assets、src、AndroidManifest.xml)
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

}
win32 {
    LIBS += -ldbghelp       #程序奔溃后产生dump文件
}
ios {
#    ICON_DATA.files = \
#        $$PWD/ios/Icon.png \
#        $$PWD/ios/Icon@2x.png \
#        $$PWD/ios/Icon-60.png \
#        $$PWD/ios/Icon-60@2x.png \
#        $$PWD/ios/Icon-72.png \
#        $$PWD/ios/Icon-72@2x.png \
#        $$PWD/ios/Icon-76.png \
#        $$PWD/ios/Icon-76@2x.png \
#        $$PWD/ios/Def.png \
#        $$PWD/ios/Def@2x.png \
#        $$PWD/ios/Def-Portrait.png \
#        $$PWD/ios/Def-568h@2x.png
#    QMAKE_BUNDLE_DATA += ICON_DATA

    #包含这句后，Qt不会自动生成Info.plist文件了!!!
    QMAKE_INFO_PLIST = $$PWD/ios/Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
}
else {
}



TARGET = Pets
TEMPLATE = app      #应用



#TEMPLATE = lib     #库
#CONFIG += staticlib    #静态库(不加则是动态库,动态库还需要global文件,内容如下)

#include <QtCore/qglobal.h>
#if defined(SHARELIB_LIBRARY)
#  define SHARELIBSHARED_EXPORT Q_DECL_EXPORT
#else
#  define SHARELIBSHARED_EXPORT Q_DECL_IMPORT
#endif

#还要加下面的???
#unix {
#    target.path = /usr/lib
#    INSTALLS += target
#}



#lupdate_only {
#SOURCES += \
#    qml/*.qml
#}

#TRANSLATIONS = resources/translations/leamus_ru.ts




RC_ICONS = icon.ico



SOURCES += _SRC/main.cpp \
    _SRC/GameManager.cpp \
    _SRC/GamePlatform.cpp \
    _SRC/Game.cpp \
    _SRC/UserInfo.cpp \
    \
    _SRC/Game/SocketDefine.cpp \
    _SRC/Game/GameDefine.cpp \
    _SRC/Game/Player.cpp \
    \
    _SRC/_Global/GameModel.cpp \
    _SRC/_Global/GameModelThread.cpp \
    _SRC/_Global/GameCommon.cpp \
    _SRC/_Global/GlobalClass.cpp \
    _SRC/_Global/Platform/Platform.cpp \
    _SRC/_Global/HTTP/HTTPDownload.cpp \
    _SRC/_Global/Sqlite/Sqlite.cpp \
    _SRC/_Global/Socket/Common.cpp \
    _SRC/_Global/Socket/ClientSocket.cpp \
    _SRC/_Global/VersionCheck/VersionCheck.cpp

HEADERS += \
    _SRC/GameManager.h \
    _SRC/GamePlatform.h \
    _SRC/UserInfo.h \
    _SRC/Game.h \
    \
    _SRC/Game/SocketDefine.h \
    _SRC/Game/GameDefine.h \
    _SRC/Game/Player.h \
    \
    _SRC/_Global/GameModel.h \
    _SRC/_Global/GameModelThread.h \
    _SRC/_Global/GameCommon.h \
    _SRC/_Global/GlobalClass.h \
    _SRC/_Global/Platform/Platform.h \
    _SRC/_Global/HTTP/HTTPDownload.h \
    _SRC/_Global/Sqlite/Sqlite.h \
    _SRC/_Global/Socket/Common.h \
    _SRC/_Global/Socket/ClientSocket.h \
    _SRC/_Global/VersionCheck/VersionCheck.h

OTHER_FILES += \
    android/AndroidManifest.xml \
    android/gradle.properties \
    android/local.properties \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    \
    _SRC/QML/qmldir \
    _SRC/QML.qrc \
    _SRC/Res.qrc \
    _SRC/Updater.qrc \
    _SRC/UpdaterConfig.json \
    _SRC/_Global/Socket/1.Pleafles.txt \
    \
    _ExtraFiles/Config.cfg \
    _ExtraFiles/1.Pleafles.txt

DISTFILES += \
    _SRC/QML/Bear/Bear.qml \
    _SRC/QML/NormalUI.qml \
    _SRC/QML/FightUI.qml \
    _SRC/QML/NetPlay.qml \
    _SRC/QML/Login/Login.qml \
    _SRC/QML/Register/Register.qml \
    \
    _SRC/QML/Game/Pet.qml \
    _SRC/QML/Group/Group.qml \
    _SRC/QML/Group/InGroup.qml \
    \
    _SRC/QML/game.qml \
    _SRC/QML/Global.qml \
    _SRC/QML/Logo.qml \
    _SRC/QML/DebugWindow.qml \
    _SRC/QML/GameJS.js \
    _SRC/QML/GameUI.qml \
    \
    _SRC/QML/GameGlobal/GameData.qml \
    _SRC/QML/GameGlobal/GamePos.qml \
    _SRC/QML/GameGlobal/GameSettings.qml \
    _SRC/QML/GameGlobal/GameResource.qml \
    _SRC/QML/GameGlobal/GameConfig.qml \
    \
    _SRC/QML/_Global/Global.js \
    _SRC/QML/_Global/GameItem.qml \
    _SRC/QML/_Global/MsgBox.qml \
    _SRC/QML/_Global/Button/ImageButton.qml \
    _SRC/QML/_Global/Button/ImageButton2.qml \
    _SRC/QML/_Global/Button/ColorButton.qml \
    _SRC/QML/_Global/Line/Line.qml \
    _SRC/QML/_Global/Popup/Mask.qml \
    _SRC/QML/_Global/Popup/Popup.qml \
    _SRC/QML/_Global/Progress/Progress.qml \
    _SRC/QML/_Global/Particles/Particles1.qml \
    \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/res/values/styles.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    \
    android/src/cn/Leamus/MainActivity.java \
    android/src/cn/Leamus/Module.java \
    QML.dat \
    Res.dat \
    Game.exe \
    PetsD.exe


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

