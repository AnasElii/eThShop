#include "ocategory.h"

OCategory::OCategory(QObject *parent)
    : QObject{parent}
{

}

OCategory::OCategory(int id, QString name, QString path)
{
    this->m_id = id;
    this->m_name = name;
    this->m_path = path;
}

OCategory::~OCategory()
{
}

// ID Getter 
int OCategory::id() const
{
    return m_id;
}

void OCategory::setID(const int &newID)
{
    if(m_id == newID)
        return;
    
    m_id = newID;
}

// Name Getter and Setter
QString OCategory::name() const
{
    return m_name;
}
void OCategory::setName(const QString &newName)
{
    if(m_name == newName)
        return;
    
    m_name = newName;
}

// path Getter and Setter
QString OCategory::path() const
{
    return m_path;
}
void OCategory::setPath(const QString &newPath)
{
    if(m_path == newPath)
        return;

    m_path = newPath;
}
