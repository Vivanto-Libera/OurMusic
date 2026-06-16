#include "musiccollection.h"

MusicCollection::MusicCollection(const QString& name, QObject* parent) : QObject(parent), m_name(name)
{
}

QString MusicCollection::name() const
{
    return m_name;
}

void MusicCollection::setName(const QString& name)
{
    if (m_name != name) {
        m_name = name;
        emit nameChanged();
    }
}

void MusicCollection::addSong(Song* song)
{
    m_songs.append(song);
}

void MusicCollection::removeSong(int index)
{
    if (index >= 0 && index < m_songs.size()) {
        m_songs.removeAt(index);
    }
}

QList<Song*> MusicCollection::getAllSongs() const
{
    return m_songs;
}

Song* MusicCollection::getSong(int index) const
{
    if (index >= 0 && index < m_songs.size()) {
        return m_songs.at(index);
    }
    return nullptr;
}
