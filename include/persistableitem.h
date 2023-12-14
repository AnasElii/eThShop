#ifndef PERSISTABLEITEM_H
#define PERSISTABLEITEM_H

#include <QObject>

class PersistableItem : public QObject
{
    Q_OBJECT
public:
    explicit PersistableItem(QObject *parent = nullptr);

signals:
};

#endif // PERSISTABLEITEM_H
