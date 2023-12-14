#include <QObject>
#include <QQmlEngine>
#include <QDateTime>
#include <QDebug>

class FProductManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit FProductManager(QObject *parent = nullptr);

    Q_INVOKABLE QDateTime getCurrentUtcTime();
    Q_INVOKABLE QString getTimeAgo(QString timestamp);
};
