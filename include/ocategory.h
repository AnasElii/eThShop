#ifndef OCATEGORY_H
#define OCATEGORY_H

#include <QObject>
#include <QQmlEngine>

class OCategory : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id WRITE setID NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    QML_ELEMENT
public:
    explicit OCategory(QObject *parent = nullptr);
    explicit OCategory(int id, QString name, QString path);
    ~OCategory();

    int id() const;
    void setID(const int &newID);
    
    QString name() const;
    void setName( const QString &newUsername );

    QString path() const;
    void setPath( const QString &newEmail );

   

signals:
    void idChanged();
    void nameChanged();
    void pathChanged();
    

private:
    int m_id;
    QString m_name;
    QString m_path;
};

#endif // OCATEGORY_H
