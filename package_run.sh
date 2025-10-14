#!/bin/bash

MACHINE_ARCH=$(uname -m)

if [ "$MACHINE_ARCH" == "aarch64" ]; then
    MACHINE_ARCH="arm64"
    echo "Architecture was aarch64, updated to: $MACHINE_ARCH"
elif [ "$MACHINE_ARCH" == "x86_64" ]; then
    MACHINE_ARCH="x64"
fi

# Check if flutter_to_debian is installed
if ! command -v flutter_to_debian &> /dev/null
then
    echo "Error: flutter_to_debian is not installed."
    echo "Please install it by running the following command:"
    echo "dart pub global activate flutter_to_debian"
    exit 1
fi

flutter clean
flutter build linux --release

./set_app_versions.sh

flutter_to_debian 
mkdir -p dist
#cp -r build/linux/$MACHINE_ARCH/release/debian/* dist/
# flutter_to_debian does not replace x64 default arch with real arch from config file, so we use x64 as an output folder
cp -r build/linux/x64/release/debian/* dist/

echo "DEB package created in dist/"
echo "Preparing RPM package"
# RPM build setup
RPM_BUILD_ROOT="$(pwd)/rpmbuild"

# App details from pubspec.yaml
APP_NAME=$(grep 'name:' pubspec.yaml | awk '{print $2}')
APP_VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
APP_BUILD=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)

# Create RPM build directories
mkdir -p "$RPM_BUILD_ROOT/BUILD"
mkdir -p "$RPM_BUILD_ROOT/RPMS"
mkdir -p "$RPM_BUILD_ROOT/SOURCES"
mkdir -p "$RPM_BUILD_ROOT/SPECS"
mkdir -p "$RPM_BUILD_ROOT/SRPMS"

cp "$APP_NAME.spec" "$RPM_BUILD_ROOT/SPECS/"

# Copy desktop and icon files
sed "s/Icon=app.rayadams.$APP_NAME/Icon=$APP_NAME/" debian/gui/app.rayadams."$APP_NAME".desktop > "$RPM_BUILD_ROOT/SOURCES/app.rayadams.$APP_NAME.desktop"
cp debian/gui/app.rayadams."$APP_NAME".png "$RPM_BUILD_ROOT/SOURCES/"

# Package the application files into a tarball
pushd build/linux/$MACHINE_ARCH/release || exit
tar -czvf "$RPM_BUILD_ROOT/SOURCES/$APP_NAME-$APP_VERSION.tar.gz" bundle
popd || exit

# Build the RPM
rpmbuild -bb \
    --define "_topdir $RPM_BUILD_ROOT" \
    --define "_name $APP_NAME" \
    --define "_version $APP_VERSION" \
    --define "_release $APP_BUILD" \
    "$RPM_BUILD_ROOT/SPECS/$APP_NAME.spec"

# Move the RPM to the dist directory
mkdir -p dist
find "$RPM_BUILD_ROOT/RPMS" -name "*.rpm" -exec mv {} dist/ \;

# Clean up
rm -rf "$RPM_BUILD_ROOT"

echo "RPM package created in dist/"
echo "Preparing TAR archive"

ARCHIVE_NAME="${APP_NAME}-${APP_VERSION}+${APP_BUILD}-${MACHINE_ARCH}.tar.gz"
FULL_ARCHIVE_PATH="dist/${ARCHIVE_NAME}"
SOURCE_DIR="build/linux/${MACHINE_ARCH}/release/bundle"

tar -czvf "$FULL_ARCHIVE_PATH" -C "$SOURCE_DIR" .
echo "TAR archive created in dist/"
