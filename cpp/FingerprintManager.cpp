#include "FingerprintManager.h"

#include "proxies/manager_proxy.h"
#include "proxies/device_proxy.h"
#include "VerifyStatus.h"

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDebug>

FingerprintManager::FingerprintManager(QObject *parent)
    : QObject(parent)
{
    qDebug() << "Created Fingerprint manager";
    NetReactivatedFprintManagerInterface managerProxy("net.reactivated.Fprint", "/net/reactivated/Fprint/Manager", QDBusConnection::systemBus(), nullptr);
    auto reply = managerProxy.GetDefaultDevice();
    reply.waitForFinished();
    if (reply.isError())
    {
        qWarning() << "error getting default device: " << reply.error();
        return;
    }
    auto device = reply.value();
    fprint = new NetReactivatedFprintDeviceInterface("net.reactivated.Fprint", device.path(), QDBusConnection::systemBus(), nullptr);
}

void FingerprintManager::setStatus(const QString &status)
{
    qDebug() << "status changed:" << status;
    if (m_status == status)
        return;

    m_status = status;
    emit statusChanged(status);
}

QString FingerprintManager::status() const
{
    return m_status;
}

bool FingerprintManager::verifying() const
{
    return m_verifying;
}

bool FingerprintManager::startVerification()
{
    qDebug() << "Starting fingerprint verification";

    // claim
    // verifyStart
    auto claim = fprint->Claim("");
    claim.waitForFinished();
    if (!claim.isValid())
    {
        qWarning() << "couldn't claim device: " << claim.error().message();
        if (claim.error().message() == "net.reactivated.Fprint.Error.AlreadyInUse")
        {
        }
        return false;
    }
    auto verifyStart = fprint->VerifyStart("any");
    verifyStart.waitForFinished();
    if (!verifyStart.isValid())
    {
        qWarning() << "couldn't start verification: " << verifyStart.error();
        return false;
    }
    qDebug() << "Verification started successfully";
    m_verifying = true;
    emit verifyingChanged();
    connect(
        fprint,
        &NetReactivatedFprintDeviceInterface::VerifyStatus,
        this,
        &FingerprintManager::onVerifyStatus);
    return true;
}

void FingerprintManager::onVerifyStatus(const QString &result, bool done)
{
    qDebug() << "received verify status change: " << result;
    qDebug() << "done: " << done;
    VerifyStatus status = parseStatus(result);
    switch (status)
    {

    // verify-match: The verification succeeded, Device.VerifyStop should now be called.
    case VerifyStatus::Match:
        stopVerification();
        emit verificationSucceeded();
        emit setStatus("Success");
        break;

    // verify-no-match: The verification did not match, Device.VerifyStop should now be called.
    case VerifyStatus::NoMatch:
        stopVerification();
        emit verificationFailed("Fingerprint did not match");
        break;

    // verify-retry-scan: The user should retry scanning their finger, the verification is still ongoing.
    case VerifyStatus::RetryScan:
        emit setStatus("Try again");
        break;

    // verify-swipe-too-short: The user's swipe was too short. The user should retry scanning their finger, the verification is still ongoing.
    case VerifyStatus::SwipeTooShort:
        emit setStatus("Swipe too short");
        break;

    // verify-finger-not-centered: The user's finger was not centered on the reader. The user should retry scanning their finger, the verification is still ongoing.
    case VerifyStatus::FingerNotCentered:
        emit setStatus("Finger not centered");
        break;

    // verify-remove-and-retry: The user should remove their finger from the reader and retry scanning their finger, the verification is still ongoing.
    case VerifyStatus::RemoveAndRetry:
        emit setStatus("Remove finger and try again");
        break;

    // verify-too-fast: The user's swipe or touch was too fast. The user should retry scanning their finger, the verification is still ongoing.
    case VerifyStatus::TooFast:
        emit setStatus("Too fast");
        break;

    // verify-disconnected: The device was disconnected during the verification, no other actions should be taken, and you shouldn't use the device any more.
    case VerifyStatus::Disconnected:
        stopVerification();
        emit setStatus("The sensor was disconnected");
        emit verificationFailed("Fingerprint reader disconnected");
        break;

    // verify-unknown-error: An unknown error occurred (usually a driver problem), Device.VerifyStop should now be called.
    case VerifyStatus::UnknownError:
        stopVerification();
        emit setStatus("An Unknown error occurred with Fprint");
        emit verificationFailed("Fingerprint error");
        break;

    case VerifyStatus::Unknown:
        emit setStatus("Fprint returned an unknown status (" + result + ")");
        qWarning() << "Unknown verify status:" << result;
        break;
    }
}

bool FingerprintManager::stopVerification()
{

    auto stop = fprint->VerifyStop();
    stop.waitForFinished();
    if (!stop.isValid())
    {
        return false;
    }

    auto release = fprint->Release();
    release.waitForFinished();
    if (!release.isValid())
    {
        return false;
    }

    m_verifying = false;
    emit verifyingChanged();
    return true;
}