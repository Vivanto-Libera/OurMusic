#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QObject>
#include <QList>
#include "song.h"

class PlayList : public QObject
{
    Q_OBJECT
public:
    explicit PlayList(QObject *parent = nullptr);

    void addSong(Song* song);
    void deleteSong(int index);   // 从列表中移除，但不删除 Song 对象
    void clear();                 // 清空列表

private:
    QList<Song*> m_playList;
};

#endif