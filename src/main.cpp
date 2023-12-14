#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlDebuggingEnabler>
#include <QQuickStyle>

#include "fimageuploader.h"
#include "configmanager.h"
#include "oproduct.h"

int main(int argc, char *argv[])
{
    QApplication application(argc, argv);
    QQmlApplicationEngine engine;

    // Register the Config manager class with QML
    engine.rootContext()->setContextProperty("configManager", ConfigManager::instance());

    // Enable Debugging
    QQmlDebuggingEnabler enabler;
    
    // Determine the operating system and set the style accordingly
    if (QSysInfo::productType() == "android")
    {
        // Set the style to Material for Android
        QQuickStyle::setStyle("Material");
    }
    else if (QSysInfo::productType() == "ios" || QSysInfo::productType() == "macos")
    {
        // Set the style to iOS for iOS
        QQuickStyle::setStyle("iOS");
    }
    else
    {
        // Set the style to Fusion for all other platforms
        QQuickStyle::setStyle("Material");
    }

    const QUrl url(u"qrc:/mainLib/interfaces/main.qml"_qs);
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &application, [url](QObject *obj, const QUrl &objUrl)
        {
        if(!obj && objUrl == url)
            QGuiApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return application.exec();
}
