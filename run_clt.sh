#!/bin/bash
# 固定使用 CLT Python 启动班级管理系统（后台 PATH 会解析到无 flask 的 Homebrew Python）
cd "$(dirname "$0")"
exec /Library/Developer/CommandLineTools/usr/bin/python3 app.py --port 5800
