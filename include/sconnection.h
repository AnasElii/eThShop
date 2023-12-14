#ifndef SCONNECTION_H
#define SCONNECTION_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

#include "configmanager.h"

class SConnection : public QObject
{
    Q_OBJECT
public:
    explicit SConnection(QObject *parent = nullptr);
    ~SConnection();

    void sendRequest(const QString &api);
    void sendRequest(const QString &api, const QJsonObject &data);

    QString getUrl() const;

    void sendMultipartRequest(const QString &api, const QByteArray& data);

signals:
    void getData(QJsonObject data);

private slots:
    void onFinished();

private:
    const QString apiUrl = ConfigManager::instance()->getBasePathIPv4();
    const QString uploadUrl = ConfigManager::instance()->getApisPath();
    const QString m_url = ConfigManager::instance()->getUploadsPath();
    QNetworkReply *m_reply;
    QNetworkAccessManager *m_manager;
};

#endif // SCONNECTION_H
