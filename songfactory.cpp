#include "songfactory.h"
#include "song.h"
#include <QMediaPlayer>
#include <QMediaMetaData>
#include <QUrl>
#include <QList>
#include <QFileInfo>
#include <QEventLoop>
#include <QTimer>

SongFactory::SongFactory(QObject *parent)
    : QObject{parent}
{}

Song* SongFactory::buildSong(const QString& url)
{
    QMediaPlayer player;
    player.setSource(QUrl(url));
    
    QEventLoop loop;
    QTimer timer;
    timer.setSingleShot(true);
    timer.setInterval(3000);
    
    QObject::connect(&timer, &QTimer::timeout, &loop, &QEventLoop::quit);
    QObject::connect(&player, &QMediaPlayer::mediaStatusChanged, [&](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::LoadedMedia || 
            status == QMediaPlayer::InvalidMedia || 
            status == QMediaPlayer::EndOfMedia) {
            loop.quit();
        }
    });
    
    timer.start();
    loop.exec();
    
    QMediaMetaData metaData = player.metaData();
    QString name = metaData.value(QMediaMetaData::Title).toString();
    QStringList singerList = metaData.value(QMediaMetaData::Author).toStringList();
    QString album = metaData.value(QMediaMetaData::AlbumTitle).toString();
    int duration = metaData.value(QMediaMetaData::Duration).toInt();
    QString singer;

    if (name.isEmpty()) {
        name = "Unknown";
    }
    if (singerList.isEmpty()) {
        singer = "Unknown";
    }
    else
    {
        singer = singerList.at(0);
    }
    if (album.isEmpty()) {
        album = "Unknown Album";
    }
    
    return new Song(name, singer, album, url, duration / 1000);
}
