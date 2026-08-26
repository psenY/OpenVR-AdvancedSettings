# Localization

The application uses Qt's standard source-text translation workflow. English
is the source language, with Japanese, Traditional Chinese, and Simplified
Chinese translations. QML strings use `qsTr()`, and C++ strings use `tr()`.
Qt Linguist TS files are compiled and embedded in the executable by qmake.

On first launch, the application maps the system locale to one of the four
supported languages and persists that concrete locale code. Later language
changes are also persisted and take effect after restarting the application.

## Updating translations

1. Mark new user-visible QML text with `qsTr()` and user-visible C++ text with
   `tr()`.
2. Update the TS files from the repository root:

   ```text
   lupdate advancedSettings.pro
   ```

3. Translate new entries with Qt Linguist.
4. Validate and compile the translations:

   ```text
   lrelease advancedSettings.pro
   ```

The normal application build also runs `lrelease` and embeds the generated QM
files under `/i18n` in the Qt resource system.

SteamVR action names use a separate localization table in
`src/package_files/action_manifest.json`. Keep its languages synchronized with
the Qt translations.

## Adding a language

Add the language's TS file to `TRANSLATIONS` in `advancedSettings.pro`, add its
stable locale code to `src/translations/translations.cpp`, and expose the same
code in the language selector in `src/res/qml/SettingsPage.qml`. Locale codes
are persisted in the existing application settings file.

Keep localization changes limited to translation markers, translation files,
and the localization infrastructure so that upstream changes can continue to
be merged or rebased with minimal conflict.
