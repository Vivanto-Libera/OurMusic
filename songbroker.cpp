#include "songbroker.h"
#include "songfactory.h"
#include "song.h"
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
                    if (!url.isEmpty()) {
                        Song* song = factory.buildSong(std::move(url));
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

Song* SongBroker::findSongByUrl(const QString&& url)
{
    for (Song* song : m_songs) {
        if (song->url() == url) {
            return song;
        }
    }
    return nullptr;
}