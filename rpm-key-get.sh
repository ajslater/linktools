#!/bin/sh
KEY_TMP=/tmp/RPM.KEYS
gpg --list-keys
gpg --recv-keys $*
gpg --export --armor $* > $KEY_TMP
sudo rpm --import $KEY_TMP
rm $KEY_TMP
