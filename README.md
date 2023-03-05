# tfnphp-dockerfiles

Dockerfiles for Gitlab-CE CI Integration based on Debian Bullseye. This Docker Image contains multiple software for testing php and nodejs-code under different plattforms (linux/amd64, linux/386, linux/arm/v7, linux/arm64, arm64v8 - for the beginning)

## Overview

A set of images with different PHP-CLI Version 8.2.3 and different tools like PHPUnit, Composer, NodeJS, Gulp, etc. for automated testing web-applications. This images could be used with Gitlab-CE (and other CI-solutions). Different PHP Versions are stored inside specific git branches (php-82 and php-81).

## Included Software

#### Compiled in PHP modules:
bz2, calendar, Core, ctype, curl, date, dom, exif, fileinfo, filter, ftp, gd, hash, iconv, imap, intl, json, libxml, mbstring, mysqli, mysqlnd, opcache, openssl, pcre, PDO, pdo_mysql, pdo_sqlite, Phar, posix, readline, Reflection, session, shmop, SimpleXML, sodium, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib

#### PHP-Extensions:
- [Xdebug](https://xdebug.org)
- [Composer](https://getcomposer.org)
- [PHPUnit](https://phpunit.de)
- [phpcs](https://github.com/squizlabs/PHP_CodeSniffer)
- [phpmd](https://phpmd.org)
- [phpcpd](https://github.com/sebastianbergmann/phpcpd)

#### NodeJS:

- [NodeJS 16.x](https://nodejs.org/en/)
- [gulp](https://gulpjs.com)

## Development

This images are currently under heavy development. Features could be added and removed on every update.

--
##### License-Information:

Copyright Jens Dutzi 2023 / Stand: 05.03.2023 18:45 / Dockerfiles are licensed under [MIT License](http://opensource.org/licenses/mit-license.php)
