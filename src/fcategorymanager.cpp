#include "fcategorymanager.h"

FCategoryManager::FCategoryManager(QObject *parent) : QObject(parent)
{
    m_connection = new SConnection();
    QObject::connect(m_connection, &SConnection::getData, this, &FCategoryManager::getData);

}

FCategoryManager::~FCategoryManager()
{
    m_connection->deleteLater();
}

QString FCategoryManager::osName() const
{
    return QSysInfo::productType().toLower();
}

void FCategoryManager::fetchCategories(){
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "Hello MTF's";
    jsonData["type"] = "fetchCategories";

    // Create The Connection
    m_connection->sendRequest("categoryManager.php", jsonData);
}

QList<OCategory *> FCategoryManager::getCategories()
{
    return m_categories;
}

void FCategoryManager::manageProductCategory(const QString &categoryID, const QString &productID)
{
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "addProductCategory";
    jsonData["idCategory"] = categoryID;
    jsonData["idProduct"] = productID;

    // Create The Connection
    m_connection->sendRequest("categoryManager.php", jsonData);
}

void FCategoryManager::manageProductCategory(const QString& productCategoryID, const QString& categoryID, const QString& productID){
    // Json data
    QJsonObject jsonData;
    jsonData["submit"] = "";
    jsonData["type"] = "updateProductCategory";
    jsonData["idProductCategory"] = productCategoryID;
    jsonData["idCategory"] = categoryID;
    jsonData["idProduct"] = productID;

    // Create The Connection
    m_connection->sendRequest("categoryManager.php", jsonData);

}

void FCategoryManager::getData(QJsonObject data)
{   
    QString status = data["status"].toString();
    if(status == "success")
    {
        if(data["data"].isArray()){
            // Clear the list
            m_categories.clear();

            // Add the new data
            for(int i = 0; i < data["data"].toArray().size(); i++){
                QJsonObject jsonData = data["data"][i].toObject();
                OCategory* category = new OCategory(jsonData["id"].toInt(), jsonData["name"].toString(), jsonData["path"].toString());
                m_categories.append(category);
            }
        }
        
    
    }else{
        qDebug() << "Server:" << data["message"].toString();
    }
}
