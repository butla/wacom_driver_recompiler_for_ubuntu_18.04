echo "================"
echo "Unloading the old module first (no problem if it fails)"
echo "================"
sudo rmmod wacom

set -e

(
echo ====================
echo Building input wacom
echo ====================
cd input-wacom-0.47.0
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"
)

(
echo ====================
echo Building xf86 input wacom
echo ====================
cd xf86-input-wacom-0.40.0
set -- --prefix="/usr" --libdir="$(readlink -e $(ls -d /usr/lib*/xorg/modules/input/../../../ | head -n1))"
if test -x ./autogen.sh; then ./autogen.sh "$@"; else ./configure "$@"; fi && make && sudo make install || echo "Build Failed"
)

echo "================"
echo "Loading the new module"
echo "================"
sudo insmod input-wacom-0.47.0/4.5/wacom.ko
