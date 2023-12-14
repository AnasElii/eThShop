// configmanager.h
#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QObject>
#include <QSettings>

class ConfigManager : public QObject
{
    Q_OBJECT

public:
    static ConfigManager *instance();

    Q_INVOKABLE QString getServerIPv4();
    Q_INVOKABLE QString getServerIPv6();
    Q_INVOKABLE QString getBasePathIPv4();
    Q_INVOKABLE QString getApisPath();
    Q_INVOKABLE QString getUploadsPath();
    Q_INVOKABLE QString getPhpAccessToken();
    Q_INVOKABLE QString getGoogleCloudApiKey();

private: 
    ConfigManager(QObject *parent = nullptr);
    static ConfigManager *m_instance;
};

#endif // CONFIGMANAGER_H