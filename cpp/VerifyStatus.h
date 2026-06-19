#pragma once

#include <QtCore/qstring.h>
enum class VerifyStatus
{
    Match,
    NoMatch,
    RetryScan,
    SwipeTooShort,
    FingerNotCentered,
    RemoveAndRetry,
    TooFast,
    Disconnected,
    UnknownError,
    Unknown
};
static VerifyStatus parseStatus(const QString &status)
{
    if (status == "verify-match")
        return VerifyStatus::Match;

    if (status == "verify-no-match")
        return VerifyStatus::NoMatch;

    if (status == "verify-retry-scan")
        return VerifyStatus::RetryScan;

    if (status == "verify-swipe-too-short")
        return VerifyStatus::SwipeTooShort;

    if (status == "verify-finger-not-centered")
        return VerifyStatus::FingerNotCentered;

    if (status == "verify-remove-and-retry")
        return VerifyStatus::RemoveAndRetry;

    if (status == "verify-too-fast")
        return VerifyStatus::TooFast;

    if (status == "verify-disconnected")
        return VerifyStatus::Disconnected;

    if (status == "verify-unknown-error")
        return VerifyStatus::UnknownError;

    return VerifyStatus::Unknown;
}