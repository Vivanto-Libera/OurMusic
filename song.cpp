#include "song.h"
#include <QDebug>

Song::Song(const QString& name, const QString& singer, const QString& album, const QString& url, int duration)
    : m_name(name), m_singer(singer), m_album(album), m_url(url), m_duration(duration), QObject(nullptr)
{
}

QString Song::name() const
{
    return m_name;
}

QString Song::singer() const
{
    return m_singer;
}

QString Song::album() const
{
    return m_album;
}

QString Song::url() const
{
    return m_url;
}

int Song::duration() const
{
    return m_duration;
}

bool Song::liked() const
{
    return m_liked;
}

void Song::setLiked(bool newLiked)
{
    m_liked = newLiked;
    emit likedChanged();
}
