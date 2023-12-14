#ifndef OUSER_H
#define OUSER_H

#include <QObject>
#include <QQmlEngine>

class OUser : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY idChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString email READ email WRITE setEmail NOTIFY emailChanged)
    Q_PROPERTY(QString tel READ tel WRITE setTel NOTIFY telChanged)
    Q_PROPERTY(bool role READ role WRITE setRole NOTIFY roleChanged)
    Q_PROPERTY(bool valid READ valid WRITE setRole NOTIFY validChanged)
    Q_PROPERTY(QString imagePath READ imagePath WRITE setImagePath NOTIFY imagePathChanged)
    QML_ELEMENT
public:
    explicit OUser(QObject *parent = nullptr);
    explicit OUser(int id, QString username, QString email, QString tel, bool role, bool valid, QString imagePath);
    ~OUser();

    int id() const;

    QString username() const;
    void setUsername( const QString &newUsername );

    QString email() const;
    void setEmail( const QString &newEmail );

    QString tel() const;
    void setTel( const QString &newtel );

    bool role() const;
    void setRole( const bool &newRole );

    bool valid() const;
    void setValid( const bool &newValid );

    QString imagePath() const;
    void setImagePath( const QString &newImagePath );

signals:
    void idChanged();
    void usernameChanged();
    void emailChanged();
    void telChanged();
    void roleChanged();
    void validChanged();
    void imagePathChanged();

private:
    int m_id;
    QString m_username;
    QString m_email;
    QString m_tel;
    bool m_role;
    bool m_valid;
    QString m_imagePath;
};

#endif // OUSER_H
