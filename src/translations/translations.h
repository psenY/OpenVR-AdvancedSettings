#pragma once

#include <QCoreApplication>
#include <QString>
#include <QTranslator>

namespace translations
{
bool isSupportedLanguageSetting( const QString& language );

bool install( QCoreApplication& application, QTranslator& translator );
} // namespace translations
