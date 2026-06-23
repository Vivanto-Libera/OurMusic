#ifndef COLLECTIONBROKER_H
#define COLLECTIONBROKER_H

#include <QObject>
#include <QQmlEngine>
#include "musiccollection.h"

class CollectionBroker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit CollectionBroker(QObject *parent = nullptr);
    Q_INVOKABLE static CollectionBroker* singleton();
    Q_INVOKABLE MusicCollection* findCollection(int index);
    Q_INVOKABLE void deleteCollection(int index);
    Q_INVOKABLE void createdNewCollection();
    Q_INVOKABLE int count();
    Q_INVOKABLE void save();
    Q_INVOKABLE void reloadLikedMusic();

private:
    QList<MusicCollection*> m_collections;
};

#endif // COLLECTIONBROKER_H
