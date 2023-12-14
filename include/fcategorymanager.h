#ifndef FCATEGORYMANAGER_H
#define FCATEGORYMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

#include "sconnection.h"
#include "ocategory.h"

class FCategoryManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    FCategoryManager(QObject* parent = nullptr);
    ~FCategoryManager();

    QString osName() const; 

    Q_INVOKABLE void fetchCategories(); 
    Q_INVOKABLE QList<OCategory*> getCategories();
    Q_INVOKABLE void manageProductCategory(const QString& categoryID, const QString& productID);
    Q_INVOKABLE void manageProductCategory(const QString& productCategoryID, const QString& categoryID, const QString& productID);

private slots:
    void getData(QJsonObject data);

signals:

private:
    SConnection *m_connection;
    QList<OCategory*> m_categories;
};

#endif // FCATEGORYMANAGER_H
