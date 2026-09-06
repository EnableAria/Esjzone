$YAML = Get-Content pubspec.yaml
$APP_NAME = ($YAML | Select-String '^name:') -replace '^name:\s*', ''
$VERSION = ($YAML | Select-String '^version:') -replace 'version:\s*', '' -replace '\+.*', ''

$OUTPUT_DIR = "build\app\outputs\flutter-apk"
$RENAMED_DIR = "$OUTPUT_DIR\release"

$CHECK = [char]0x2713
$SKIP = [char]0x0078

Write-Host "========================================"
Write-Host "APK Rename"
Write-Host "App: $APP_NAME"
Write-Host "Version: $VERSION"
Write-Host "Output: $((Resolve-Path $RENAMED_DIR).Path)"

if (-not (Test-Path $OUTPUT_DIR)) {
    Write-Host "Error: APK output directory not found: $OUTPUT_DIR" -ForegroundColor Red
    exit 1
}

if (Test-Path $RENAMED_DIR) {
    Remove-Item "$RENAMED_DIR\$APP_NAME-v*.apk" -Force -ErrorAction SilentlyContinue
    Write-Host "$CHECK Cleaned old APK files" -ForegroundColor Green
}

New-Item -ItemType Directory -Path $RENAMED_DIR -Force | Out-Null

$MAP = @{
    "app-arm64-v8a-release.apk" = "$APP_NAME-v$VERSION-v8a.apk"
    "app-armeabi-v7a-release.apk" = "$APP_NAME-v$VERSION-v7a.apk"
    "app-x86_64-release.apk" = "$APP_NAME-v$VERSION-x64.apk"
    "app-x86-release.apk" = "$APP_NAME-v$VERSION-x86.apk"
    "app-release.apk" = "$APP_NAME-v$VERSION-release.apk"
    "app-debug.apk" = "$APP_NAME-v$VERSION-debug.apk"
}

Get-ChildItem "$OUTPUT_DIR\*.apk" | ForEach-Object {
    $OLD_NAME = $_.Name
    if ($MAP.ContainsKey($OLD_NAME)) {
        $NEW_NAME = $MAP[$OLD_NAME]
        Write-Host "$CHECK Rename $NEW_NAME `t<-`t $OLD_NAME" -ForegroundColor Green
        Copy-Item $_.FullName "$RENAMED_DIR\$NEW_NAME"
    } else {
        Write-Host "$SKIP Skip $OLD_NAME" -ForegroundColor Red
    }
}

Write-Host "$CHECK APK rename completed" -ForegroundColor Green