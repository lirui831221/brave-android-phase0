#!/bin/bash
# Chromium Android 种源方案（绕过代理对 googlesource 大 pack 的断流）
# 适用场景：构建机走 Clash 类代理时，git clone/fetch googlesource 超过 ~500MB 必断
# 前提：有一台能直连 googlesource 的海外 VPS（本例 us-api，43.159.131.113）

set -e

CHROMIUM_TAG="155.0.8059.16"
SEED_DIR="/home/lecoo/chromium-seed"
WORK_DIR="/home/lecoo/brave-android"

# ===== 第 1 步：海外 VPS 上浅克隆种源 =====
# ssh us-api 上执行：
#   mkdir -p /root/chromium-seed && cd /root/chromium-seed
#   git clone --bare --depth 1 --branch $CHROMIUM_TAG https://chromium.googlesource.com/chromium/src.git src.git
#   git rev-parse HEAD   # 记录 SHA，与 github.com/chromium/chromium 同 tag 比对校验

# ===== 第 2 步：VPS -> 构建机传输（Tailscale 内网，tar 流）=====
# VPS 生成密钥并加入构建机 authorized_keys 后：
#   cd /root/chromium-seed && tar cf - src.git | \
#     ssh -i ~/.ssh/id_ed25519_lecoo lecoo@100.64.0.15 "mkdir -p $SEED_DIR && tar xf - -C $SEED_DIR"

# ===== 第 3 步：构建机用 alternates 接入种源（秒级，不重复下载）=====
if [ ! -d "$WORK_DIR/src/.git" ]; then
    mkdir -p "$WORK_DIR/src"
    cd "$WORK_DIR/src"
    git init -q
    git remote add origin https://chromium.googlesource.com/chromium/src.git
    echo "$SEED_DIR/src.git/objects" > .git/objects/info/alternates
    git fetch --no-tags --depth=1 origin refs/tags/$CHROMIUM_TAG:refs/tags/$CHROMIUM_TAG
    git checkout -q -B main $CHROMIUM_TAG
    git reset --hard $CHROMIUM_TAG
fi

echo "种源接入完成："
cd "$WORK_DIR/src" && git log --oneline -1
