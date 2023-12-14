#include "ouser.h"

OUser::OUser(QObject *parent)
    : QObject{parent}
{

}

OUser::OUser(int id, QString username, QString email, QString tel, bool role, bool valid, QString imagePath)
{
    this->m_id = id;
    this->m_username = username;
    this->m_email = email;
    this->m_role = role;
    this->m_tel = tel;
    this->m_valid = valid;
    this->m_imagePath = imagePath;
}

OUser::~OUser()
{
}

// ID Getter 
int OUser::id() const
{
    return m_id;
}

// Username Getter and Setter
QString OUser::username() const
{
    return m_username;
}
void OUser::setUsername(const QString &newUsername)
{
    if(m_username == newUsername)
        return;
    
    m_username = newUsername;
}

// Email Getter and Setter
QString OUser::email() const
{
    return m_email;
}
void OUser::setEmail(const QString &newEmail)
{
    if(m_email == newEmail)
        return;

    m_email = newEmail;
}

// Tel Getter and Setter
QString OUser::tel() const
{
    return m_tel;
}
void OUser::setTel(const QString &newTel)
{
    if(m_tel == newTel)
        return;

    m_tel = newTel;
}

// Role Getter and Setter
bool OUser::role() const
{
    return m_role;
}
void OUser::setRole(const bool &newRole)
{
    if(m_role == newRole)
        return;

    m_role = newRole;
}

bool OUser::valid() const
{
    return m_valid;
}

void OUser::setValid(const bool &newValid)
{
    if(m_valid == newValid)
        return;
    
    m_valid = newValid;
    emit validChanged();
}

// Image Path Getter and Setter
QString OUser::imagePath() const
{
    return m_imagePath;
}
void OUser::setImagePath(const QString &newImagePath)
{
    if(m_imagePath == newImagePath)
        return;
    
    m_imagePath = newImagePath;
}
