#ifndef FAUTHMANAGER_H
#define FAUTHMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>

#include "sconnection.h"

class FAuthManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)
    Q_PROPERTY(QString status READ status WRITE setStatus NOTIFY statusChanged)
    QML_ELEMENT
public:
    explicit FAuthManager(QObject *parent = nullptr);
    ~FAuthManager();

    Q_INVOKABLE bool isOnline();
    Q_INVOKABLE void login(const QString &username, const QString &password);
    Q_INVOKABLE void singup(const QString &username, const QString &email, const QString &tel, const QString &password);
    Q_INVOKABLE void setRole();
    Q_INVOKABLE void logout();


    QString id() const;

    QString username() const;
    void setUsername(const QString &newUsername);

    QString password() const;
    void setPassword(const QString &newPassword);

    QString status() const;
    void setStatus(const QString &newStatus);

signals:
    void usernameChanged();
    void passwordChanged();
    void statusChanged();

private slots:
    void getData(QJsonObject data);

private:
    QString m_id;
    QString m_username;
    QString m_password;
    QString m_status;
    SConnection *m_connection;
};

#endif // FAUTHMANAGER_H
