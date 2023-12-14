#ifndef FUSERMANAGER_H
#define FUSERMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QClipboard>
#include <QtGui/QGuiApplication>

#include "sconnection.h"
#include "ouser.h"

class FUserManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int productCount READ productCount WRITE setProductCount NOTIFY productCountChange)
    QML_ELEMENT
public:
    explicit FUserManager(QObject *parent = nullptr);
    ~FUserManager();

    Q_INVOKABLE void fetchUserData(const int &id);
    Q_INVOKABLE OUser* getuserData();
    Q_INVOKABLE QUrl getImageUrl();
    Q_INVOKABLE void updateImagePath( const QString &newPath );
    Q_INVOKABLE void copyToClipboard(const QString &text);
    Q_INVOKABLE void updateUser( const QString &feild, const QString &data, const QString oldPassword );
    Q_INVOKABLE void updateUser( const QString &feild, const QString &data);
    Q_INVOKABLE void isFollowed( const int &id );

    int productCount() const;
    void setProductCount( const int &newProductCount );

signals:
    void userChanged();
    void productCountChange();
    void userUpdated( const QString &feild, const QString &data );

private slots:
    void getData(QJsonObject data);

private:
    void getProductNumber( const int &id );

private:
    SConnection *m_connection;
    OUser *m_user;
    int m_productNumber;
};

#endif // FUSERMANAGER_H
