#include "playlist.h"

PlayList::PlayList(QObject *parent)
    : QObject(parent)
{
}

void PlayList::addSong(Song* song)
{
    if (song) {
        m_playList.append(song);
    }
}

void PlayList::deleteSong(int index)
{
    if (index >= 0 && index < m_playList.size()) {
        m_playList.removeAt(index);
    }
}

void PlayList::clear()
{
    m_playList.clear();
}

Song *PlayList::getSong(int index)
{
    return m_playList.at(index);
}

int PlayList::count()
{
    return m_playList.count();
}
