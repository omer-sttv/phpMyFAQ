#!/bin/sh
#
# This is the shell script for building:
# 1. a TAR.GZ package;
# 2. a ZIP package
# of phpMyFAQ using what committed into Git.
#
# For creating a package simply run:
#
#   ./git2package.sh
#
# The script will download the source code from branch and
# it will create the 2 packages plus their MD5 hashes.
#
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at http://mozilla.org/MPL/2.0/.
#
# @package phpMyFAQ
# @author Matteo Scaramuccia <matteo@scaramuccia.com>
# @author Thorsten Rinne <thorsten@phpmyfaq.de>
# @author Rene Treffer <treffer+phpmyfaq@measite.de>
# @author David Soria Parra <dsp@php.net>
# @author Florian Anderiasch <florian@phpmyfaq.de>
# @copyright 2008-2020 phpMyFAQ Team
# @license http://www.mozilla.org/MPL/2.0/ Mozilla Public License Version 2.0
# @link https://www.phpmyfaq.de
# @version 2008-09-10

# phpMyFAQ Version
. scripts/version.sh

if [ "x${MD5BIN}" = "x" ]; then
    if which md5 > /dev/null; then
        MD5BIN="$(which md5)"
    else
        MD5BIN="$(which md5sum)"
    fi
fi

# Package Folder
if [ "x${PMF_PACKAGE_FOLDER}" = "x" ]; then
    PMF_PACKAGE_FOLDER="phpmyfaq-${PMF_VERSION}"
fi

cwd=`pwd`

git checkout-index -f -a --prefix=$cwd/build/checkout/${PMF_PACKAGE_FOLDER}/

# Add missing directories
mkdir -p $cwd/build/package/${PMF_PACKAGE_FOLDER}/

cd $cwd/build/checkout/${PMF_PACKAGE_FOLDER}/

# add dependencies
composer install --no-dev --prefer-dist
yarn install
yarn build

# Remove fonts from TCPDF
rm -rf $cwd/build/checkout/${PMF_PACKAGE_FOLDER}/phpmyfaq/src/libs/tecnickcom/tcpdf/fonts

# create md5 hashes for file verification
php scripts/createHashes.php > $cwd/hashes-${PMF_VERSION}.json

# prepare packaging
cd $cwd
mv $cwd/build/checkout/${PMF_PACKAGE_FOLDER}/phpmyfaq $cwd/build/package/${PMF_PACKAGE_FOLDER}

# build packages
tar cfvz ${PMF_PACKAGE_FOLDER}.tar.gz -C $cwd/build/package/${PMF_PACKAGE_FOLDER} phpmyfaq
cd $cwd/build/package/${PMF_PACKAGE_FOLDER}
zip -r $cwd/${PMF_PACKAGE_FOLDER}.zip phpmyfaq
cd $cwd

# md5sum
$MD5BIN "${PMF_PACKAGE_FOLDER}.tar.gz" > "${PMF_PACKAGE_FOLDER}.tar.gz.md5"
$MD5BIN "${PMF_PACKAGE_FOLDER}.zip" > "${PMF_PACKAGE_FOLDER}.zip.md5"

# clean up
rm -rf $cwd/build/checkout/${PMF_PACKAGE_FOLDER}
rm -rf $cwd/build/package/${PMF_PACKAGE_FOLDER}

echo "done.\n";
