#ifndef SONG_H
#define SONG_H

#include <QQmlEngine>

class Song
{
    QML_ELEMENT
public:
    Song();
private:
    QString m_name;
    QString m_singer;
    QString m_album;
    QString m_url;
    int m_durarion;
    QList<QString> lurics;
};

#endif // SONG_H
