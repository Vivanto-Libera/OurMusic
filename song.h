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
    Q_PROPERTY(QList<QString> lyrics READ lyrics CONSTANT)
public:
    Song() = default;
    Song(const QString& name, const QString& singer, const QString& album, const QString& url, int duration, const QList<QString>& lyrics);
    QString name() const;
    QString singer() const;
    QString album() const;
    QString url() const;
    int duration() const;
    QList<QString> lyrics() const;
private:
    QString m_name = "Name";
    QString m_singer = "Singer";
    QString m_album = "Album";
    QString m_url;
    int m_duration = 0;
    QList<QString> m_lyrics;
};

#endif // SONG_H
