#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QObject>
#include <QList>
#include <QQmlEngine>
#include <QString>

struct SongInfo {
    QString name;
    QString url;
};

class PlayList : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int playMode READ playMode WRITE setPlayMode NOTIFY playModeChanged)
    
public:
    explicit PlayList(QObject *parent = nullptr);

    Q_INVOKABLE void addSong(const QString& name, const QString& url);
    Q_INVOKABLE void deleteSong(int index);
    Q_INVOKABLE void clear();
    Q_INVOKABLE QString getUrl(int index);
    Q_INVOKABLE QString getName(int index);
    Q_INVOKABLE int count() const;
    Q_INVOKABLE void setSongs(const QList<QString>& names, const QList<QString>& urls);
    
    Q_INVOKABLE int nextIndex();
    Q_INVOKABLE int previousIndex();
    
    int currentIndex() const;
    void setCurrentIndex(int index);
    
    int playMode() const;
    void setPlayMode(int mode);

signals:
    void currentIndexChanged(int index);
    void playModeChanged(int mode);
    void countChanged(int count);
    void songAdded(const QString& name, const QString& url);
    void songRemoved(int index);
    void listCleared();

private:
    QList<SongInfo> m_playList;
    int m_currentIndex;
    int m_playMode;
};

#endif
