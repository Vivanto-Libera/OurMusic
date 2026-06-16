#ifndef MUSICCOLLECTION_H
#define MUSICCOLLECTION_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QList>
#include <QtQml/qqmlregistration.h>
#include "song.h"

class MusicCollection : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
public:
    MusicCollection(const QString& name, QObject* parent = nullptr);
    QString name() const;
    void setName(const QString& name);
    void addSong(Song* song);
    void removeSong(int index);
    QList<Song*> getAllSongs() const;
    Song* getSong(int index) const;
signals:
    void nameChanged();
private:
    QString m_name;
    QList<Song*> m_songs;
};

#endif // MUSICCOLLECTION_H
