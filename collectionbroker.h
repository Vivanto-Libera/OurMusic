#ifndef COLLECTIONBROKER_H
#define COLLECTIONBROKER_H

#include <QObject>
#include <QQmlEngine>
class MusicCollection;

class CollectionBroker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit CollectionBroker(QObject *parent = nullptr);
    MusicCollection* findCollection(int index);
    void deleteCollection(int index);
    void createdNewCollection();

private:
    QList<MusicCollection*> m_collections;
};

#endif // COLLECTIONBROKER_H
