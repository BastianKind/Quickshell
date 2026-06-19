#pragma once

#include "proxies/manager_proxy.h"
#include "proxies/device_proxy.h"

#include <QObject>
#include <qqmlintegration.h>
#include <QDBusInterface>

class FingerprintManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool verifying READ verifying NOTIFY verifyingChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)

public:
    explicit FingerprintManager(QObject *parent = nullptr);

    bool verifying() const;
    QString status() const;

    Q_INVOKABLE bool startVerification();
    Q_INVOKABLE bool stopVerification();

signals:
    void verificationSucceeded();
    void verificationFailed(QString reason);
    void verifyingChanged();
    void statusChanged(QString message);

private:
    void onVerifyStatus(const QString &result, bool done);
    void setStatus(const QString &status);
    bool m_verifying = false;
    QString m_status;
    NetReactivatedFprintDeviceInterface *fprint;
};