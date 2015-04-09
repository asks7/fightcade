#!/bin/sh

unset http_proxy
unset https_proxy

echo ${all_proxy}

proxychains curl ipinfo.io

