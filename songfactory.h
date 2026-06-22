#ifndef SONGFACTORY_H
#define SONGFACTORY_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
class Song;

class SongFactory : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit SongFactory(QObject *parent = nullptr);
    Song* buildSong(const QString&& url);
};

#endif // SONGFACTORY_H
