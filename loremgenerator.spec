%define _name loremgenerator
%define _version 1.0.1
%define _release 4
%define debug_package %{nil}

Name: %{_name}
Version: %{_version}
Release: %{_release}
Summary: Lorem Ipsum Generator
License: MIT
Group: Applications/Utilities


Source0: %{_name}-%{_version}.tar.gz
Source1: app.rayadams.loremgenerator.desktop
Source2: app.rayadams.loremgenerator.png

Requires: gtk3, libstdc++

%description
Lorem Ipsum Generator

%prep
%setup -q -n bundle

%build
# This section is intentionally left blank as we are packaging a pre-compiled Flutter application.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps
mkdir -p %{buildroot}/opt/%{_name}

# Copy the application files
cp -r ./* %{buildroot}/opt/%{_name}/

# Create a symlink in /usr/bin
ln -s /opt/%{_name}/%{_name} %{buildroot}/usr/bin/%{_name}

# Copy the desktop file
install -m 644 %{SOURCE1} %{buildroot}/usr/share/applications/%{_name}.desktop

# Copy the application icon
install -m 644 %{SOURCE2} %{buildroot}/usr/share/icons/hicolor/256x256/apps/%{_name}.png

%files
/usr/bin/%{_name}
/opt/%{_name}
/usr/share/applications/%{_name}.desktop
/usr/share/icons/hicolor/256x256/apps/%{_name}.png

%changelog
* Sun Oct 12 2025 Konstantin Adamov <xrayadamo@gmail.com>
- Initial RPM release
