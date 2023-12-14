#include "oproduct.h"

OProduct::OProduct(QObject *parent)
    : QObject{parent}
{}

OProduct::OProduct(QString id, QString title, double price, int promo, QString city, QDateTime date, QString description, QString category, bool state, QString sellerID, QString sellerName, QString sellerPhone, QString sellerProfileImage, bool isOnline, bool isValidate, bool isBestSeller, bool isFollowed, bool isFavorite, bool isLiked, QObject *parent = nullptr);
: QObject{parent}
{
    
}

QString OProduct::id() const
{
    return m_id;
}

QString OProduct::title() const
{
    return m_title;
}

void OProduct::setTitle(const QString &newTitle)
{
    if (m_title == newTitle)
        return;
    m_title = newTitle;
    emit titleChanged();
}

double OProduct::price() const
{
    return m_price;
}

void OProduct::setPrice(double newPrice)
{
    if (qFuzzyCompare(m_price, newPrice))
        return;
    m_price = newPrice;
    emit priceChanged();
}

int OProduct::promo() const
{
    return m_promo;
}

void OProduct::setPromo(int newPromo)
{
    if (m_promo == newPromo)
        return;
    m_promo = newPromo;
    emit promoChanged();
}

QString OProduct::city() const
{
    return m_city;
}

void OProduct::setCity(const QString &newCity)
{
    if (m_city == newCity)
        return;
    m_city = newCity;
    emit cityChanged();
}

QDateTime OProduct::date() const
{
    return m_date;
}

void OProduct::setDate(const QDateTime &newDate)
{
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}

QString OProduct::description() const
{
    return m_description;
}

void OProduct::setDescription(const QString &newDescription)
{
    if (m_description == newDescription)
        return;
    m_description = newDescription;
    emit descriptionChanged();
}


QString OProduct::category() const
{
    return m_category;
}

void OProduct::setCategory(const QString &newCategory)
{
    if (m_category == newCategory)
        return;
    m_category = newCategory;
    emit categoryChanged();
}
