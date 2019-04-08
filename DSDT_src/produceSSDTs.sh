#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
test -d patched && rm -rf patched ; mkdir patched

rm -f srcs/RehabMan/OS-X-Clover-Laptop-Config/Build/SSDT-IALL.aml

pushd srcs/acidanthera/
rm -f ssdt_data.dsl
cp -f /System/Library/Extensions/IOPlatformPluginFamily.kext/Contents/PlugIns/X86PlatformPlugin.kext/Contents/Resources/Mac-937CB26E2E02BB01.plist .
patch -Np0 -i 800mhz.diff
./CPUFriend/ResourceConverter/ResourceConverter.sh --acpi Mac-937CB26E2E02BB01.plist
popd

make build/SSDT-IALL.aml -C srcs/RehabMan/OS-X-Clover-Laptop-Config
mv -v srcs/RehabMan/OS-X-Clover-Laptop-Config/Build/SSDT-IALL.aml patched/
iasl -vw 2095 -vw 2008 -vw 4089 -vi -vs -p patched/SSDT-CPUF.aml srcs/acidanthera/ssdt_data.dsl