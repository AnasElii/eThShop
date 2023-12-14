#include "fusermanager.h"

FUserManager::FUserManager(QObject *parent)
    : QObject{parent}
{
    m_connection = new SConnection();
}

FUserManager::~FUserManager()
{
    m_connection->deleteLater();
}

void FUserManager::fetchUserData(const int &id)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "fetchUserData";
    jsonData["id"] = id;

    // Create the connection
    QObject::connect(m_connection, &SConnection::getData, this, &FUserManager::getData);
    m_connection->sendRequest("userManager.php", jsonData);
}

OUser *FUserManager::getuserData()
{
    return m_user;
}

void FUserManager::updateImagePath(const QString& newPath)
{
    if(m_user->imagePath() == newPath)
		return;

    m_user->setImagePath(newPath);
}

QUrl FUserManager::getImageUrl()
{
    if (m_user == nullptr)
    {
        return QUrl("qrc:/mainLib/images/Profile_Pic_Circle.png");

    } else {
        if (m_user->imagePath() == "")
            return QUrl("qrc:/mainLib/images/Profile_Pic_Circle.png");

        return QUrl(m_connection->getUrl() + m_user->imagePath());
    }

}

void FUserManager::copyToClipboard(const QString &text)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(text);
}

void FUserManager::updateUser(const QString &feild, const QString &data)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "updateUser";
    jsonData["id"] = m_user->id();
    jsonData["feild"] = feild;
    jsonData["data"] = data;

    
    // Create the connection
    QObject::connect(m_connection, &SConnection::getData, [=](QJsonObject data)
    {
        QString status = data["status"].toString();
        if(status == "success")
        {
            QString updatedData = data["data"].toString();
            QString updatedFeild = data["feild"].toString();
            emit userUpdated(updatedData, updatedFeild);
        }else{
           qDebug() << data["message"].toString() << " ";
        }
    });
    m_connection->sendRequest("userManager.php", jsonData);
}

void FUserManager::isFollowed(const int &id)
{
    // Check if the seller followed
}

void FUserManager::updateUser(const QString &feild, const QString &data, const QString oldPassword)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "updateUser";
    jsonData["id"] = m_user->id();
    jsonData["feild"] = feild;
    jsonData["data"] = data;
    jsonData["oldPassword"] = oldPassword;
    
    
    // Create the connection
    QObject::connect(m_connection, &SConnection::getData, [=](QJsonObject data)
    {
        QString status = data["status"].toString();
        if(status == "success")
        {
            QString updatedData = data["data"].toString();
            QString updatedFeild = data["feild"].toString();
            emit userUpdated(updatedData, updatedFeild);
        }else{
           qDebug() << data["message"].toString() << " ";
        }
    });
    m_connection->sendRequest("userManager.php", jsonData);
}

int FUserManager::productCount() const
{
    return m_productNumber;
}

void FUserManager::setProductCount(const int &newProductCount)
{
    if(m_productNumber == newProductCount)
        return;

    m_productNumber = newProductCount;
    emit productCountChange();
}

void FUserManager::getProductNumber(const int &id)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "productCount";
    jsonData["id"] = id;

    // Create the connection
    QObject::connect(m_connection, &SConnection::getData, [=](QJsonObject data)
    {
        QString productNumber = data["data"].toString();
        m_productNumber = productNumber.toInt();
        emit productCountChange();
    });
    m_connection->sendRequest("userManager.php", jsonData);

}

void FUserManager::getData(QJsonObject data)
{   
    QJsonObject jsonData = data["data"][0].toObject();

    int userID = jsonData["id"].toInt();
    QString userName = jsonData["username"].toString();
    QString userEmail = jsonData["email"].toString();
    QString userTel = jsonData["tel"].toString();
    bool userRole = jsonData["role"].toInt();
    bool userValid = jsonData["valid"].toInt();
    QString imagePath = jsonData["imagePath"].toString();
    m_productNumber = jsonData["productNumber"].toObject()["count"].toInt();
    
    m_user = new OUser(userID, userName, userEmail, userTel, userRole, userValid, imagePath);
    emit userChanged();

}
