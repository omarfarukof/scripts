#! /bin/bash
if [ -z "$1" ]; then
    IMP_DIR="."
else
    IMP_DIR=$1
fi

echo " Imporing GPG Secret key from ${IMP_DIR}/private.pgp"
gpg --import ${IMP_DIR}/private.pgp

echo " Imporing GPG Public key from ${IMP_DIR}/public.pgp"
gpg --import ${IMP_DIR}/public.pgp