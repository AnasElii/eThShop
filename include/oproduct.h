#ifndef OPRODUCT_H
#define OPRODUCT_H

#include <QObject>
#include <QQmlEngine>

class OProduct : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY idChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(double price READ price WRITE setPrice NOTIFY priceChanged)
    Q_PROPERTY(int promo READ promo WRITE setPromo NOTIFY promoChanged)
    Q_PROPERTY(QString city READ city WRITE setCity NOTIFY cityChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QString category READ category WRITE setCategory NOTIFY categoryChanged)
    Q_PROPERTY(bool state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QString sellerID READ sellerID WRITE setSellerID NOTIFY sellerIDChanged)
    Q_PROPERTY(QString sellerName READ sellerName WRITE setSellerName NOTIFY sellerNameChanged)
    Q_PROPERTY(QString sellerPhone READ sellerPhone WRITE setSellerPhone NOTIFY sellerPhoneChanged)
    Q_PROPERTY(QString sellerProfileImage READ sellerProfileImage WRITE setSellerProfileImage NOTIFY sellerProfileImageChanged)
    Q_PROPERTY(bool isOnline READ isOnline WRITE setIsOnline NOTIFY isOnlineChanged)
    Q_PROPERTY(bool isValidate READ isValidate WRITE setIsValidate NOTIFY isValidateChanged)
    Q_PROPERTY(bool isBestSeller READ isBestSeller WRITE setIsBestSeller NOTIFY isBestSellerChanged)
    Q_PROPERTY(bool isFollowed READ isFollowed WRITE setIsFollowed NOTIFY isFollowedChanged)
    Q_PROPERTY(bool isFavorite READ isFavorite WRITE setIsFavorite NOTIFY isFavoriteChanged)
    Q_PROPERTY(bool isLiked READ isLiked WRITE setIsLiked NOTIFY isLikedChanged)

    QML_ELEMENT
public:
    explicit OProduct(QObject *parent = nullptr);

    OProduct(QString id, QString title, double price, int promo, QString city, QDateTime date, QString description, QString category, bool state, QString sellerID, QString sellerName, QString sellerPhone, QString sellerProfileImage, bool isOnline, bool isValidate, bool isBestSeller, bool isFollowed, bool isFavorite, bool isLiked, QObject *parent = nullptr);

    // product(const product &) = delete;
    // product(product &&) = delete;
    // product &operator=(const product &) = delete;
    // product &operator=(product &&) = delete;
    QString id() const;

    QString title() const;
    void setTitle(const QString &newTitle);

    double price() const;
    void setPrice(double newPrice);

    int promo() const;
    void setPromo(int newPromo);

    QString city() const;
    void setCity(const QString &newCity);

    QDateTime date() const;
    void setDate(const QDateTime &newDate);

    QString description() const;
    void setDescription(const QString &newDescription);


    QString category() const;
    void setCategory(const QString &newCategory);

signals:
    
    void idChanged();
    void titleChanged();
    void priceChanged();
    void promoChanged();
    void cityChanged();
    void dateChanged();
    void descriptionChanged();
    void categoryChanged();

private:
    QString m_id;
    QString m_title;
    double m_price;
    int m_promo;
    QString m_city;
    QDateTime m_date;
    QString m_description;
    QString m_category;
};

#endif // OPRODUCT_H
