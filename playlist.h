#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QObject>
#include <QList>
#include <QQmlEngine>
#include "song.h"

class PlayList : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit PlayList(QObject *parent = nullptr);

    Q_INVOKABLE void addSong(Song* song);
    Q_INVOKABLE void deleteSong(int index);   // 从列表中移除，但不删除 Song 对象
    Q_INVOKABLE void clear();                 // 清空列表
    Q_INVOKABLE Song* getSong(int index);
    Q_INVOKABLE int count();

private:
    QList<Song*> m_playList;
};

#endif
