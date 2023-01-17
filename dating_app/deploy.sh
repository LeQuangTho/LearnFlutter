#!/bin/bash

pubspec_version=$(cat ./pubspec.yaml | grep "version:.*" | head -1 | xargs)

old_marketing_version=$(cat ./ios/Runner.xcodeproj/project.pbxproj | grep "MARKETING_VERSION.*\;" | head -1 | xargs)
old_project_version=$(cat ./ios/Runner.xcodeproj/project.pbxproj | grep "CURRENT_PROJECT_VERSION.*\;"  | head -1 | xargs)

android_old_version_name=$(cat ./android/local.properties | grep "flutter\.versionName=.*" | head -1 | xargs)
android_old_version_code=$(cat ./android/local.properties | grep "flutter\.versionCode=.*"  | head -1 | xargs)

# Get old_project_version and old_marketing_version

echo "pubspec version:"
echo "   " $pubspec_version
echo ""

echo "IOS version:"
echo "   " $old_marketing_version
echo "   " $old_project_version
echo ""

echo "Android version:"
echo "   " $android_old_version_name
echo "   " $android_old_version_code
echo ""

# Take the marketing_version string
read -p "Enter the new  MARKETING_VERSION: " marketing_version

# Take the project_version string
read -p "Enter the new CURRENT_PROJECT_VERSION: " project_version


if [[ $marketing_version != "" && $project_version != "" ]]; then

sed -i -p -e "s/$pubspec_version/version: $marketing_version\+$project_version/gi" ./pubspec.yaml
rm ./pubspec.yaml-p

sed -i -p -e "s/$old_marketing_version/MARKETING_VERSION = $marketing_version;/gi" ./ios/Runner.xcodeproj/project.pbxproj
sed -i -p -e "s/$old_project_version/CURRENT_PROJECT_VERSION = $project_version;/gi" ./ios/Runner.xcodeproj/project.pbxproj
rm ./ios/Runner.xcodeproj/project.pbxproj-p

sed -i -p -e "s/$android_old_version_name/flutter.versionName=$marketing_version/gi" ./android/local.properties
sed -i -p -e "s/$android_old_version_code/flutter.versionCode=$project_version/gi" ./android/local.properties
rm ./android/local.properties-p
rm ./android/*local.properties

fi

echo "Building for android..."
flutter build apk && flutter build appbundle
cp ./build/app/outputs/flutter-apk/app-release.apk ./build/app/outputs/flutter-apk/app-release-$marketing_version-$project_version.apk
open ./build/app/outputs/flutter-apk/

echo "Build for ios"
flutter build ipa && open ./build/ios/archive/Runner.xcarchive
