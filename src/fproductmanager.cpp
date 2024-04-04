#include "fproductmanager.h"

FProductManager::FProductManager(QObject *parent) : QObject(parent) {}

QDateTime FProductManager::getCurrentUtcTime() {
    return QDateTime::currentDateTimeUtc();
}

QString FProductManager::getTimeAgo(QString timestamp) {
    // Convert Time Stamp
    QDateTime timeStampDate = QDateTime::fromString(timestamp, "yyyy-MM-dd hh:mm:ss");
    
    // Get GMT + 0 Time
    QDateTime now = QDateTime::currentDateTime();
    int offset = now.offsetFromUtc() * 1000;
    QDateTime gmtTime = now.addMSecs(-offset);

    // Retirn Final Result
    qint64 timeDifference =  timeStampDate.toUTC().secsTo(gmtTime) * 1000;

    int seconds = qFloor(timeDifference / 1000); // difference in seconds
    int minutes = qFloor(seconds / 60); // difference in minutes
    int hours = qFloor(minutes / 60); // difference in hours
    int days = qFloor(hours / 24); // difference in days
    int weeks = qFloor(days / 7); // difference in weeks
    int months = qFloor(days / 30); // difference in months
    int years = qFloor(days / 365); // difference in years

    if (seconds < 60) {
        return "Just now";
    } else if (minutes < 60) {
        return QString::number(minutes) + " minutes ago";
    } else if (hours < 24) {
        return QString::number(hours) + " hours ago";
    } else if (days < 7) {
        return QString::number(days) + " days ago";
    } else if (weeks < 4) {
        return QString::number(weeks) + " weeks ago";
    } else if (months < 12) {
        return QString::number(months) + " months ago";
    } else {
        return QString::number(years) + " years ago";
    }
}