#include "oproduct.h"

OProduct::OProduct(QObject *parent)
    : QObject{parent}
{}

OProduct::OProduct(QString id, QString title, double price, int promo, QString city, QDateTime date, QString description, QString category, bool state, QString sellerID, QString sellerName, QString sellerPhone, QString sellerProfileImage, bool isOnline, bool isValidate, bool isBestSeller, bool isFollowed, bool isFavorite, bool isLiked, QObject *parent)
: QObject{parent}
{
    m_id = id;
    m_title = title;
    m_price = price;
    m_promo = promo;
    m_city = city;
    m_date = date;
    m_description = description;
    m_category = category;
    m_state = state;
    m_sellerID = sellerID;
    m_sellerName = sellerName;
    m_sellerPhone = sellerPhone;
    m_sellerProfileImage = sellerProfileImage;
    m_isOnline = isOnline;
    m_isValidate = isValidate;
    m_isBestSeller = isBestSeller;
    m_isFollowed = isFollowed;
    m_isFavorite = isFavorite;
    m_isLiked = isLiked;
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


// Update
bool OProduct::state() const
{
    return m_state;
}
void OProduct::setState(bool newState)
{
    if (m_state == newState)
        return;
    m_state = newState;
    emit stateChanged();
}


QString OProduct::sellerID() const
{
    return m_sellerID;
}
void OProduct::setSellerID(const QString &newSellerID)
{
    if (m_sellerID == newSellerID)
        return;
    m_sellerID = newSellerID;
    emit sellerIDChanged();
}   

QString OProduct::sellerName() const
{
    return m_sellerName;
}
void OProduct::setSellerName(const QString &newSellerName)
{
    if (m_sellerName == newSellerName)
        return;
    m_sellerName = newSellerName;
    emit sellerNameChanged();
}

QString OProduct::sellerPhone() const
{
    return m_sellerPhone;  
}
void OProduct::setSellerPhone(const QString &newSellerPhone)
{
    if (m_sellerPhone == newSellerPhone)
        return;
    m_sellerPhone = newSellerPhone;
    emit sellerPhoneChanged();
}

QString OProduct::sellerProfileImage() const
{
    return m_sellerProfileImage;
}
void OProduct::setSellerProfileImage(const QString &newSellerProfileImage)
{
    if (m_sellerProfileImage == newSellerProfileImage)
        return;
    m_sellerProfileImage = newSellerProfileImage;
    emit sellerProfileImageChanged();
}

bool OProduct::isOnline() const
{
    return m_isOnline; 
}
void OProduct::setIsOnline(bool newIsOnline)
{
    if (m_isOnline == newIsOnline)
        return;
    m_isOnline = newIsOnline;
    emit isOnlineChanged();
}

bool OProduct::isValidate() const
{
    return m_isValidate;
}
void OProduct::setIsValidate(bool newIsValidate)
{
    if (m_isValidate == newIsValidate)
        return;
    m_isValidate = newIsValidate;
    emit isValidateChanged();
}

bool OProduct::isBestSeller() const
{
    return m_isBestSeller;
}
void OProduct::setIsBestSeller(bool newIsBestSeller)
{
    if (m_isBestSeller == newIsBestSeller)
        return;
    m_isBestSeller = newIsBestSeller;
    emit isBestSellerChanged();
}

bool OProduct::isFollowed() const
{
    return m_isFollowed;
}
void OProduct::setIsFollowed(bool newIsFollowed)
{
    if (m_isFollowed == newIsFollowed)
        return;
    m_isFollowed = newIsFollowed;
    emit isFollowedChanged();
}

bool OProduct::isFavorite() const
{
    return m_isFavorite;
}
void OProduct::setIsFavorite(bool newIsFavorite)
{
    if (m_isFavorite == newIsFavorite)
        return;
    m_isFavorite = newIsFavorite;
    emit isFavoriteChanged();
}

bool OProduct::isLiked() const
{
    return m_isLiked;
}
void OProduct::setIsLiked(bool newIsLiked)
{
    if (m_isLiked == newIsLiked)
        return;
    m_isLiked = newIsLiked;
    emit isLikedChanged();
}