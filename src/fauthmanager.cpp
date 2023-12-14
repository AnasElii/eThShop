#include "fauthmanager.h"

FAuthManager::FAuthManager(QObject *parent)
    : QObject{parent}
{
    m_connection = new SConnection();
    QObject::connect(m_connection, &SConnection::getData, this, &FAuthManager::getData);
}

FAuthManager::~FAuthManager()
{
    m_connection->deleteLater();
}

bool FAuthManager::isOnline()
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";

    QObject::connect(m_connection, &SConnection::getData, this, [=](QJsonObject data){
        QString status = data["status"].toString();
        if(status == "success")
            return true;
        else
            return false;
    });
    m_connection->sendRequest("index.php", jsonData);

    return false;
}

void FAuthManager::login(const QString &username, const QString &password)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["username"] = username;
    jsonData["password"] = password;

    // Create the connection
    m_connection->sendRequest("login.php", jsonData);
}

void FAuthManager::singup(const QString &username, const QString &email, const QString &tel, const QString &password)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "register";
    jsonData["username"] = username;
    jsonData["email"] = email;
    jsonData["tel"] = tel;
    jsonData["password"] = password;

    // Create the connection
    m_connection->sendRequest("register.php", jsonData);
}

void FAuthManager::setRole()
{
     // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "role";
    jsonData["username"] = m_username;
    jsonData["role"] = 1;

    // Create the connection
    m_connection->sendRequest("register.php", jsonData);
}

void FAuthManager::logout()
{
    m_connection = new SConnection();
    m_connection->sendRequest("logout.php");
    setUsername("");
    setPassword("");
    setStatus("");
}

QString FAuthManager::id() const
{
    return m_id;
}

QString FAuthManager::username() const
{
    return m_username;
}

void FAuthManager::setUsername(const QString &newUsername)
{
    if (m_username == newUsername)
        return;

    m_username = newUsername;
    emit usernameChanged();
    
}

QString FAuthManager::password() const
{
    return m_password;
}

void FAuthManager::setPassword(const QString &newPassword)
{
    if (m_password == newPassword)
        return;

    m_password = newPassword;
    emit passwordChanged();
}

QString FAuthManager::status() const
{
    return m_status;
}

void FAuthManager::setStatus(const QString &newStatus)
{
    // if(m_status == newStatus)
    //     return;
    
    m_status = newStatus;
    emit statusChanged();
}

void FAuthManager::getData(QJsonObject data)
{   
    QString status = data["type"].toString() + " : " + data["status"].toString();
    setUsername(data["username"].toString());

    if( data["type"].toString() == "login" || data["type"].toString() == "register"){
        m_id = data["id"].toString();
    }
    
    setStatus(status);
}
