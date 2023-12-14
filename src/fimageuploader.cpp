#include "fimageuploader.h"

FImageUploader::FImageUploader(QObject *parent) : QObject(parent)
{
    m_connection = new SConnection();
    connect(m_connection, &SConnection::getData, this, &FImageUploader::getData);
}

FImageUploader::~FImageUploader()
{
    m_connection->deleteLater();
}

QString FImageUploader::osName() const
{
    return QSysInfo::productType().toLower();
}

QString FImageUploader::imagePath() const
{
    return m_imagePath;
}

void FImageUploader::setImagePath(const QString &imagePath)
{
    if (m_imagePath == imagePath)
        return;

    m_imagePath = imagePath;
    emit imagePathChanged();
}

void FImageUploader::uploadImage(const QString &imagePath, const QString &userID, const QString &productID)
{
    QFile file;

    if (osName() == "android")
    {
        qDebug() << "Cpp: Android OS Detected";

        // Call the Android Java method to get the file path
        //--> Put On Hold No Upload Images For Android
    }
    else
    {

        QString localFilePath = QUrl(imagePath).toLocalFile();
        file.setFileName(localFilePath);
        if (!file.open(QIODevice::ReadOnly))
        {
            qDebug() << "Cpp: Failed to open file for reading: " << file.errorString();
            return;
        }
    }

    // Construct the multipart/form-data content
    QByteArray boundary = "myboundary";
    QByteArray data = QString("--" + boundary + "\r\n").toUtf8();
    data += "Content-Disposition: form-data; name=\"image\"; filename=\"" + QFileInfo(file).fileName().toUtf8() + "\"\r\n";
    data += "Content-Type: application/octet-stream\r\n\r\n";

    // Read the file data
    QByteArray fileData = file.readAll();

    // Append the file data and boundary to the content
    data += fileData;
    data += "\r\n";
    data += "--" + boundary + "--\r\n";

    QString submit = "";
    QString type = "addImage";

    /// Add the extra fields
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"submit\"\r\n\r\n" + submit.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"type\"\r\n\r\n" + type.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"idUser\"\r\n\r\n" + userID.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"idProduct\"\r\n\r\n" + productID.toUtf8() + "\r\n";
    data += "--" + boundary + "--\r\n";

    // Close the file
    file.close();

    // Create The Connection
    m_connection->sendMultipartRequest("imageManager.php", data);
}

void FImageUploader::uploadImages(const QList<QString> &imagesList, const QString &type, const QString &productID)
{
    QList<QString> imagesPhats;
    QList<QByteArray> fileData;

    if (osName() == "android")
    {
        qDebug() << "Cpp: Android OS Detected";

        // Call the Android Java method to get the file path
        //--> Put On Hold No Upload Images For Android
    }
    else
    {

        for (const QString &imagePath : imagesList)
        {
            QString localFilePath = QUrl(imagePath).toLocalFile();

            // Check if the file exist
            QFile file(localFilePath);
            if (!file.open(QIODevice::ReadOnly))
            {
                qDebug() << "Cpp: Failed to open file for reading: " << file.errorString();
                return;
            }

            // Read the file data
            QByteArray dataFromFile = file.readAll();
            fileData.push_back(dataFromFile);
            file.close();

            imagesPhats.append(localFilePath);
        }
    }

    // Construct the multipart/form-data content
    QByteArray boundary = "myboundary";
    QByteArray data;

    for (int i = 0; i < imagesPhats.length(); i++)
    {

        data += QString("--" + boundary + "\r\n").toUtf8();
        data += "Content-Disposition: form-data; name=\"image" + QString::number(i + 1).toUtf8() + "\"; filename=\"" + QFileInfo(QUrl(imagesList[i]).toLocalFile()).fileName().toUtf8() + "\"\r\n";
        data += "Content-Type: application/octet-stream\r\n\r\n";

        // Append the file data and boundary to the content
        data += fileData[i];
        data += "\r\n";
        data += "--" + boundary + "--\r\n";
    }

    QString submit = "";
    QString listLength = QString::number(imagesList.length());

    /// Add the extra fields
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"submit\"\r\n\r\n" + submit.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"type\"\r\n\r\n" + type.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"listLength\"\r\n\r\n" + listLength.toUtf8() + "\r\n";
    data += "--" + boundary + "\r\n";
    data += "Content-Disposition: form-data; name=\"idProduct\"\r\n\r\n" + productID.toUtf8() + "\r\n";
    data += "--" + boundary + "--\r\n";

    // Create The Connection
    m_connection->sendMultipartRequest("imageManager.php", data);
}

void FImageUploader::getData(QJsonObject data)
{
    QString status = data.value("status").toString();
    QString message = data.value("message").toString();

    qDebug() << "Image upload status: " << status;
    qDebug() << "Image upload message: " << message;

    QString dataString = data.value("data").toString();

    if(status == "success" && dataString != "") {
        // Extract the values from the JSON object
        QString imagePath = data.value("data").toString();
        qDebug() << "Cpp| Image Path" << imagePath;
        
        setImagePath(imagePath);
    }
    else
    {
        // Request failed, handle the error
        qDebug() << "Image upload failed with error: " << message;
    }

}
