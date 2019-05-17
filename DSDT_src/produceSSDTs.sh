#!/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"
test -d patched && rm -rf patched ; mkdir patched

rm -f srcs/RehabMan/OS-X-Clover-Laptop-Config/Build/SSDT-IALL.aml

make build/SSDT-IALL.aml -C srcs/RehabMan/OS-X-Clover-Laptop-Config
mv -v srcs/RehabMan/OS-X-Clover-Laptop-Config/Build/SSDT-IALL.aml patched/