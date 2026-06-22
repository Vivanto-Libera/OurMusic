#ifndef SONGBROKER_H
#define SONGBROKER_H

#include <QObject>
#include <QQmlEngine>
#include <QList>
class Song;

class SongBroker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit SongBroker(QObject *parent = nullptr);
    Song* findSongByUrl(const QString&& url);

private:
    QList<Song*> m_songs;
};

#endif // SONGBROKER_H
