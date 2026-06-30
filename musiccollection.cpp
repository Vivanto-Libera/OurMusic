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

void MusicCollection::addSong(QString song)
{
    if (!m_songs.contains(song)) {
        m_songs.append(song);
    }
}

void MusicCollection::removeSong(int index)
{
    if (index >= 0 && index < m_songs.size()) {
        m_songs.removeAt(index);
    }
}

void MusicCollection::removeSongByUrl(QString url)
{
    for (int i = 0; i < m_songs.size(); ++i) {
        if (m_songs[i] == url) {
            m_songs.removeAt(i);
            break;
        }
    }
}

QList<QString> MusicCollection::getAllSongs() const
{
    return m_songs;
}

QString MusicCollection::getSong(int index) const
{
    if (index >= 0 && index < m_songs.size()) {
        return m_songs.at(index);
    }
    return "";
}

int MusicCollection::count() const
{
    return m_songs.count();
}

void MusicCollection::clear()
{
    m_songs.clear();
}