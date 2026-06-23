#ifndef SONG_H
#define SONG_H

#include <QtQml/qqmlregistration.h>
#include <QString>
#include <QList>
#include <QObject>

class Song :public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString singer READ singer CONSTANT)
    Q_PROPERTY(QString album READ album CONSTANT)
    Q_PROPERTY(QString url READ url CONSTANT)
    Q_PROPERTY(int duration READ duration CONSTANT)
    Q_PROPERTY(bool liked READ liked WRITE setLiked NOTIFY likedChanged)
public:
    Song() = default;
    Song(const QString& name, const QString& singer, const QString& album, const QString& url, int duration);
    QString name() const;
    QString singer() const;
    QString album() const;
    QString url() const;
    int duration() const;
    bool liked() const;
    void setLiked(bool newLiked);
signals:
    void likedChanged();
private:
    QString m_name = "Name";
    QString m_singer = "Singer";
    QString m_album = "Album";
    QString m_url;
    int m_duration = 0;
    bool m_liked = false;
};

#endif // SONG_H
