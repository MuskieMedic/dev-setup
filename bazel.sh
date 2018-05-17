#!/usr/bin/env bash

# Exit on error
set -e

sudo -v

JAVA_CHECK="$(java -version 2>&1)"
if [[ "$JAVA_CHECK" == *"Java(TM) SE Runtime Environment"* ]]; then
  echo -n "Installing BazelBuild ..."
else
  # Installing JAVA(Default is JAVA8)
  sudo add-apt-repository ppa:webupd8team/java -y > /dev/null 2>&1
  sudo apt-get update > /dev/null
  sudo apt-get -y install oracle-java8-installer > /dev/null
fi

# Adding Bazel distribution URI as a package source
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list > /dev/null
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - > /dev/null 2>&1

# Update packages and Installs Bazel latest version
sudo apt-get update > /dev/null
sudo apt-get install bazel -y > /dev/null

# Verify and exit installation
BAZEL_CHECK="$(bazel version)"
if [[ "$BAZEL_CHECK" == *"Build label"* ]]; then
   echo -e "\\033[0;32m[OK]"
   echo -e "\\033[0m"
   exit 0
else
   echo -e "\\033[0;31m[FAILED]"
   echo -e "\\033[0m"
   exit 1
fi