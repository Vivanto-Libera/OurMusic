#include "collectionbroker.h"
#include "song.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include "songbroker.h"

CollectionBroker::CollectionBroker(QObject *parent)
    : QObject{parent}
{
    QFile file("collectiondata.json");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        SongBroker* sb = SongBroker::singleton();

        if (doc.isArray()) {
            QJsonArray collectionArray = doc.array();

            for (const QJsonValue& value : collectionArray) {
                if (value.isObject()) {
                    QJsonObject collectionObj = value.toObject();
                    MusicCollection* collection = new MusicCollection(collectionObj["name"].toString());
                    QJsonArray songs = collectionObj["songs"].toArray();
                    for (const QJsonValue& songObj : songs)
                    {
                        collection->addSong(sb->findSongByUrl(songObj.toObject()["url"].toString()));
                    }
                    m_collections.append(collection);
                }
            }
        }
        file.close();
    }
}

CollectionBroker *CollectionBroker::singleton()
{
    static CollectionBroker instance;
    return &instance;
}

MusicCollection* CollectionBroker::findCollection(int index)
{
    if (index >= 0 && index < m_collections.size()) {
        return m_collections.at(index);
    }
    return nullptr;
}

void CollectionBroker::deleteCollection(int index)
{
    if (index >= 0 && index < m_collections.size()) {
        MusicCollection* collection = m_collections.takeAt(index);
        delete collection;
    }
}

void CollectionBroker::createdNewCollection()
{
    m_collections.append(new MusicCollection("新建歌单"));
}

int CollectionBroker::count()
{
    return m_collections.count();
}
