#include "playlist.h"
#include <QRandomGenerator>

PlayList::PlayList(QObject *parent)
    : QObject(parent), m_currentIndex(-1), m_playMode(0)
{
}

void PlayList::addSong(const QString& name, const QString& url)
{
    SongInfo info;
    info.name = name;
    info.url = url;
    m_playList.append(info);
    emit countChanged(m_playList.count());
    emit songAdded(name, url);
}

void PlayList::deleteSong(int index)
{
    if (index >= 0 && index < m_playList.size()) {
        m_playList.removeAt(index);
        if (index == m_currentIndex) {
            m_currentIndex = -1;
            emit currentIndexChanged(m_currentIndex);
        } else if (index < m_currentIndex) {
            m_currentIndex--;
            emit currentIndexChanged(m_currentIndex);
        }
        emit countChanged(m_playList.count());
        emit songRemoved(index);
    }
}

void PlayList::clear()
{
    m_playList.clear();
    m_currentIndex = -1;
    emit countChanged(0);
    emit currentIndexChanged(-1);
    emit listCleared();
}

QString PlayList::getUrl(int index)
{
    if (index >= 0 && index < m_playList.size()) {
        return m_playList.at(index).url;
    }
    return QString();
}

QString PlayList::getName(int index)
{
    if (index >= 0 && index < m_playList.size()) {
        return m_playList.at(index).name;
    }
    return QString();
}

int PlayList::count() const
{
    return m_playList.count();
}

void PlayList::setSongs(const QList<QString>& names, const QList<QString>& urls)
{
    m_playList.clear();
    int size = qMin(names.size(), urls.size());
    for (int i = 0; i < size; ++i) {
        SongInfo info;
        info.name = names.at(i);
        info.url = urls.at(i);
        m_playList.append(info);
    }
    m_currentIndex = -1;
    emit countChanged(m_playList.count());
    emit currentIndexChanged(-1);
}

int PlayList::nextIndex()
{
    if (m_playList.isEmpty())
        return -1;
    
    int newIndex = m_currentIndex + 1;
    
    switch (m_playMode) {
    case 0:
        if (newIndex >= m_playList.size()) {
            newIndex = 0;
        }
        break;
    case 1:
        newIndex = m_currentIndex;
        break;
    case 2:
        newIndex = QRandomGenerator::global()->bounded(m_playList.size());
        break;
    }
    
    return newIndex;
}

int PlayList::previousIndex()
{
    if (m_playList.isEmpty())
        return -1;
    
    int newIndex = m_currentIndex - 1;
    
    switch (m_playMode) {
    case 0:
        if (newIndex < 0) {
            newIndex = m_playList.size() - 1;
        }
        break;
    case 1:
        newIndex = m_currentIndex;
        break;
    case 2:
        newIndex = QRandomGenerator::global()->bounded(m_playList.size());
        break;
    }
    
    return newIndex;
}

int PlayList::currentIndex() const
{
    return m_currentIndex;
}

void PlayList::setCurrentIndex(int index)
{
    if (index >= -1 && index < m_playList.size() && index != m_currentIndex) {
        m_currentIndex = index;
        emit currentIndexChanged(m_currentIndex);
    }
}

int PlayList::playMode() const
{
    return m_playMode;
}

void PlayList::setPlayMode(int mode)
{
    if (mode >= 0 && mode <= 2 && mode != m_playMode) {
        m_playMode = mode;
        emit playModeChanged(m_playMode);
    }
}
