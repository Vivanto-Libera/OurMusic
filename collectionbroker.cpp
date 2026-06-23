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
    SongBroker* sb = SongBroker::singleton();
    MusicCollection* allMusic = new MusicCollection("全部音乐");
    MusicCollection* likedMusic = new MusicCollection("我喜欢的音乐");
    QList<Song*> allSongs = sb->getAllSongs();
    for (const auto& song : allSongs)
    {
        allMusic->addSong(song->url());
        if (song->liked())
        {
            likedMusic->addSong(song->url());
        }
    }
    m_collections.append(allMusic);
    m_collections.append(likedMusic);

    QFile file("collectiondata.json");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);

        if (doc.isArray()) {
            QJsonArray collectionArray = doc.array();

            for (const QJsonValue& value : collectionArray) {
                if (value.isObject()) {
                    QJsonObject collectionObj = value.toObject();
                    MusicCollection* collection = new MusicCollection(collectionObj["name"].toString());
                    QJsonArray songs = collectionObj["songs"].toArray();
                    for (const QJsonValue& songVal : songs)
                    {
                        QJsonObject songObj = songVal.toObject();
                        collection->addSong(songObj["url"].toString());
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

void CollectionBroker::save()
{
    QFile file("collectiondata.json");
    if (file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        QJsonArray arr;
        for (int i = 2; i < m_collections.count(); i++)
        {
            MusicCollection *collection = m_collections.at(i);
            QJsonObject obj;
            obj["name"] = collection->name();
            QJsonArray songs;
            for (const auto& song : collection->getAllSongs())
            {
                QJsonObject songUrl;
                songUrl["url"] = song;
                songs.append(songUrl);
            }
            obj["songs"] = songs;
            arr.append(obj);
        }
        QJsonDocument doc(arr);
        QByteArray data = doc.toJson();
        file.write(data);
    }
}

void CollectionBroker::reloadLikedMusic()
{
    SongBroker* sb = SongBroker::singleton();
    MusicCollection* likedMusic = m_collections.at(1);
    likedMusic->clear();
    QList<Song*> allSongs = sb->getAllSongs();
    for (const auto& song : allSongs)
    {
        if (sb->findSongByUrl(song->url())->liked())
        {
            likedMusic->addSong(song->url());
        }
    }
}

void CollectionBroker::reloadAllMusic()
{
    SongBroker* sb = SongBroker::singleton();
    MusicCollection* allMusic = m_collections.at(0);
    allMusic->clear();
    QList<Song*> allSongs = sb->getAllSongs();
    for (const auto& song : allSongs)
    {
        allMusic->addSong(song->url());
    }
}
