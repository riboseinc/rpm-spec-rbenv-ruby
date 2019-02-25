#!/bin/bash

. /usr/local/rpm-specs/setup_env.sh

readonly RUBY_VERSION=$(rpmspec -q --queryformat '%{VERSION}' ./*.spec)

rpm --import https://github.com/riboseinc/yum/raw/master/ribose-packages.pub
curl -L https://github.com/riboseinc/yum/raw/master/ribose.repo > /etc/yum.repos.d/ribose.repo

ln -sf "$PWD" "/usr/local/rpm-specs/rbenv-ruby-$RUBY_VERSION"

# For Ruby support of OpenSSL, readline and zlib extensions:
yum install -y \
	rbenv ruby-build \
	openssl-devel readline-devel zlib-devel

# Skip this error:
# 0x0002
export QA_RPATHS=$[ 0x0002 ]
build_package "rbenv-ruby-$RUBY_VERSION"

# Enable the following lines to test compatibilty with passenger packages.
#
# yum install -y /root/rpmbuild/RPMS/x86_64/*.rpm
# curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
# yum install -y nginx passenger
# exec bash
