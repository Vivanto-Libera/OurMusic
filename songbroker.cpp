#include "songbroker.h"
#include "songfactory.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>

SongBroker::SongBroker(QObject *parent)
    : QObject{parent}
{
    QFile file("songdata.json");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QByteArray data = file.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        
        if (doc.isArray()) {
            QJsonArray array = doc.array();
            SongFactory factory;
            
            for (const QJsonValue& value : array) {
                if (value.isObject()) {
                    QJsonObject obj = value.toObject();
                    QString url = obj["url"].toString();
                    bool liked = obj["liked"].toBool();
                    if (!url.isEmpty()) {
                        Song* song = factory.buildSong(std::move(url));
                        song->setLiked(liked);
                        if (song) {
                            m_songs.append(song);
                        }
                    }
                }
            }
        }
        file.close();
    }
}

SongBroker *SongBroker::singleton()
{
    static SongBroker instance;
    return &instance;
}

Song* SongBroker::findSongByUrl(QString url)
{
    for (Song* song : m_songs) {
        if (song->url() == url) {
            return song;
        }
    }
    return nullptr;
}

QList<Song *> SongBroker::getAllSongs()
{
    return m_songs;
}
