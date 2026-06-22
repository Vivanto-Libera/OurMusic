#include "songfactory.h"
#include "song.h"
#include <QMediaPlayer>
#include <QMediaMetaData>
#include <QUrl>
#include <QList>
#include <QFileInfo>

SongFactory::SongFactory(QObject *parent)
    : QObject{parent}
{}

Song* SongFactory::buildSong(const QString&& url)
{
    QMediaPlayer player;
    player.setSource(QUrl(url));
    
    QMediaMetaData metaData = player.metaData();
    QString name = metaData.value(QMediaMetaData::Title).toString();
    QString singer = metaData.value(QMediaMetaData::Author).toString();
    QString album = metaData.value(QMediaMetaData::AlbumTitle).toString();
    int duration = metaData.value(QMediaMetaData::Duration).toInt();
    
    if (name.isEmpty()) {
        QFileInfo fileInfo(QUrl(url).toLocalFile());
        name = fileInfo.baseName();
    }
    if (singer.isEmpty()) {
        singer = "Unknown";
    }
    if (album.isEmpty()) {
        album = "Unknown Album";
    }
    
    QList<QString> lyrics;
    
    return new Song(name, singer, album, url, duration / 1000, lyrics);
}