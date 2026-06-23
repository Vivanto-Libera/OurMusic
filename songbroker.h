#ifndef SONGBROKER_H
#define SONGBROKER_H

#include <QObject>
#include <QQmlEngine>
#include <QList>
#include "song.h"

class SongBroker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit SongBroker(QObject *parent = nullptr);
    Q_INVOKABLE static SongBroker* singleton();
    Q_INVOKABLE void addSong(QString url);
    Q_INVOKABLE Song* findSongByUrl(QString url);
    Q_INVOKABLE QList<Song*> getAllSongs();
    Q_INVOKABLE void setSongLiked(QString url, bool liked);
    Q_INVOKABLE void save();

private:
    QList<Song*> m_songs;
};

#endif // SONGBROKER_H
