#include "sconnection.h"


SConnection::SConnection(QObject *parent)
    : QObject{parent}, m_reply(nullptr)
{
    m_manager = new QNetworkAccessManager(this);
}

SConnection::~SConnection()
{
    m_reply->deleteLater();
    m_manager->deleteLater();
}

void SConnection::sendRequest(const QString &api)
{
    // Create Url
    QUrl url(apiUrl + api);

    // Create Request
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json"); // Set the Content-Type to application/json

    // Create JSON data
    QJsonObject jsonData;
    jsonData["submit"] = "";

    // Convert the JSON data to QByteArray
    QJsonDocument jsonDocument(jsonData);
    QByteArray postDataByteArray = jsonDocument.toJson(QJsonDocument::Compact);

    // Make the POST request with the data
    m_reply = m_manager->post(request, postDataByteArray);

    // Connect Signals
    bool ok = false;
    ok = QObject::connect(m_reply, &QNetworkReply::finished,[&](){
        if(m_reply->error() == QNetworkReply::NoError){
//            qDebug() << "Server:" << m_reply->readAll();
        }
    });
}

void SConnection::sendRequest(const QString &api, const QJsonObject &data)
{
    // Create Url
    QUrl url(apiUrl + api);

    // Create Request
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json"); // Set the Content-Type to application/json

    // Convert the JSON data to QByteArray
    QJsonDocument jsonDocument(data);
    QByteArray postDataByteArray = jsonDocument.toJson(QJsonDocument::Compact);

    // Make the POST request with the data
    m_reply = m_manager->post(request, postDataByteArray);

    // Connect Signals
    QObject::connect(m_reply, &QNetworkReply::finished, this, &SConnection::onFinished);
}

QString SConnection::getUrl() const
{
    return m_url;
}

void SConnection::sendMultipartRequest(const QString &api, const QByteArray& data){
    // Create Url
    QUrl url(apiUrl + api);

    QNetworkRequest request(url);
    // request.setRawHeader("Content-Disposition", "form-data; name=\"image\"; filename=\"" + QFileInfo(file).fileName().toUtf8() + "\"");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "multipart/form-data; boundary=myboundary");

    // Send the POST request with the constructed data
    m_reply = m_manager->post(request, data);

    // Connect Signals
    QObject::connect(m_reply, &QNetworkReply::finished, this, &SConnection::onFinished);
}


void SConnection::onFinished()
{
    if (m_reply->error() == QNetworkReply::NoError)
    {
        QByteArray responseData = m_reply->readAll();

        // Get the response as JSON
        QJsonDocument responseJson = QJsonDocument::fromJson(responseData);
        if (!responseJson.isNull())
        {
            if (responseJson.isObject())
            {
                QJsonObject jsonObj = responseJson.object();

                // Extract the values from the JSON object
                QString status = jsonObj.value("status").toString();
                QString type = jsonObj.value("type").toString();
                QString message = jsonObj.value("message").toString();

                // Display the extracted values (you can use qDebug or show them in your UI)
                qDebug() << "Cpp| _Status: " << status << " _Type: " << type << " _Message: " << message;


                // qDebug() << "================= Response from server:";
                // for (auto it = responseJsonObject.constBegin(); it != responseJsonObject.constEnd(); ++it)
                //     qDebug() << it.key() << ":" << it.value().toString();
                // qDebug() << "=================";
                

                emit getData(jsonObj);
            }
        }
        else
        {
           qDebug() << "JSON data is not an object.";
        }
    }
    else
    {
        qDebug() << "Network Error: " << m_reply->errorString();
    }
}
