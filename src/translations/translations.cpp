#include "translations.h"

#include <QLocale>
#include <easylogging++.h>

#include "../settings/settings.h"

namespace translations
{
namespace
{
constexpr auto kSystemLanguage = "system";
constexpr auto kEnglishLanguage = "en";
constexpr auto kJapaneseLanguage = "ja_JP";
constexpr auto kSimplifiedChineseLanguage = "zh_CN";
constexpr auto kTraditionalChineseLanguage = "zh_TW";

QString resolveLanguage( const QString& languageSetting )
{
    if ( languageSetting == kSystemLanguage )
    {
        const auto systemLocale = QLocale::system();
        if ( systemLocale.language() == QLocale::Japanese )
        {
            return kJapaneseLanguage;
        }
        if ( systemLocale.language() == QLocale::Chinese )
        {
            if ( systemLocale.country() == QLocale::Taiwan
                 || systemLocale.country() == QLocale::HongKong
                 || systemLocale.country() == QLocale::Macau )
            {
                return kTraditionalChineseLanguage;
            }
            return kSimplifiedChineseLanguage;
        }
        return kEnglishLanguage;
    }

    return languageSetting;
}
} // namespace

bool isSupportedLanguageSetting( const QString& language )
{
    return language == kEnglishLanguage || language == kJapaneseLanguage
           || language == kSimplifiedChineseLanguage
           || language == kTraditionalChineseLanguage;
}

bool install( QCoreApplication& application, QTranslator& translator )
{
    auto languageSetting = QString::fromStdString(
        settings::getSetting( settings::StringSetting::APPLICATION_language ) );

    if ( languageSetting != kSystemLanguage
         && !isSupportedLanguageSetting( languageSetting ) )
    {
        LOG( WARNING ) << "Unsupported language setting '"
                       << languageSetting.toStdString()
                       << "'. Falling back to the system language.";
        languageSetting = kSystemLanguage;
    }

    const auto language = resolveLanguage( languageSetting );
    if ( languageSetting != language )
    {
        settings::setSetting( settings::StringSetting::APPLICATION_language,
                              language.toStdString() );
    }

    if ( language == kEnglishLanguage )
    {
        return true;
    }

    const auto translationPath
        = QString( ":/i18n/advancedsettings_%1.qm" ).arg( language );
    if ( !translator.load( translationPath ) )
    {
        LOG( WARNING ) << "Could not load translation file '"
                       << translationPath.toStdString()
                       << "'. Falling back to English.";
        return false;
    }

    return application.installTranslator( &translator );
}
} // namespace translations
