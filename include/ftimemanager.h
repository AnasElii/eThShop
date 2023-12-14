#include <QObject>
#include <QQmlEngine>
#include <QDateTime>
#include <QDebug>

class FTimeManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit FTimeManager(QObject *parent = nullptr);

    Q_INVOKABLE QDateTime getCurrentUtcTime();
    Q_INVOKABLE QString getTimeAgo(QString timestamp);
};
