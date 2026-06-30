#ifndef MUSICCOLLECTION_H
#define MUSICCOLLECTION_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QList>
#include <QtQml/qqmlregistration.h>

class MusicCollection : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
public:
    MusicCollection(const QString& name, QObject* parent = nullptr);
    QString name() const;
    void setName(const QString& name);
    Q_INVOKABLE void addSong(QString song);
    Q_INVOKABLE void removeSong(int index);
    Q_INVOKABLE void removeSongByUrl(QString url);
    Q_INVOKABLE QList<QString> getAllSongs() const;
    Q_INVOKABLE QString getSong(int index) const;
    Q_INVOKABLE int count() const;
    void clear();
signals:
    void nameChanged();
private:
    QString m_name;
    QList<QString> m_songs;
};

#endif // MUSICCOLLECTION_H