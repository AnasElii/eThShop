#include "configmanager.h"

ConfigManager::ConfigManager(QObject *parent) : QObject(parent)
{
}

ConfigManager *ConfigManager::m_instance = nullptr;
ConfigManager *ConfigManager::instance(){
    if(!m_instance)
        m_instance = new ConfigManager();

    return m_instance;
}

QString ConfigManager::getServerIPv4()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Server/IPv4").toString();
}

QString ConfigManager::getBasePathIPv4()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Paths/BasePathIPv4").toString();
}

QString ConfigManager::getApisPath()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Paths/ApisPath").toString();
}

QString ConfigManager::getUploadsPath(){
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Paths/UploadsPath").toString();
}

QString ConfigManager::getServerIPv6()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Server/IPv6").toString();
}

QString ConfigManager::getPhpAccessToken()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("Php/AccessToken").toString();
}

QString ConfigManager::getGoogleCloudApiKey()
{
    QSettings settings("config.ini", QSettings::IniFormat);
    return settings.value("GoogleCloud/ApiKey").toString();
}
