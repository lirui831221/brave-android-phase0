#!/bin/bash
# Brave Android 构建环境（lecoo）
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export NO_PROXY=localhost,127.0.0.1,deb.debian.org
export no_proxy=localhost,127.0.0.1,deb.debian.org
export JAVA_OPTS="-Xmx10G -Xms1G"
export PATH=/usr/local/bin:$PATH
