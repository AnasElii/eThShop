#ifndef IMAGEUPLOADER_H
#define IMAGEUPLOADER_H

#include <QObject>
#include <QQmlEngine>
#include <QHttpMultiPart>
#include <QFile>
#include <QFileInfo>
#include <QSysInfo>
#include <QDebug>

#include "sconnection.h"

class FImageUploader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString imagePath READ imagePath WRITE setImagePath NOTIFY imagePathChanged);
    QML_ELEMENT

public:
    FImageUploader(QObject* parent = nullptr);
    ~FImageUploader();

    QString osName() const;

    QString imagePath() const;
    void setImagePath(const QString& imagePath);

public slots:
    Q_INVOKABLE void uploadImage(const QString& imagePath, const QString& userID = "", const QString& productID = "");
    Q_INVOKABLE void uploadImages(const QList<QString>& imagesList, const QString& type, const QString& productID = "");

private slots:
    void getData(QJsonObject data);

signals:
    void replyExecuted();
    void imagePathChanged();
    

private:
    SConnection* m_connection;
    QString m_imagePath;
};

#endif // IMAGEUPLOADER_H
