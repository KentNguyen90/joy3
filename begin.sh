#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/KentNguyen90/ccminer.git
cd ccminer
chmod +x build.sh configure.sh autogen.sh start.sh

# Thêm phần nhập liệu
echo "Nhập address wallet:"
read wallet
echo "Nhập pool 'stratum+tcp://...' (để trống để sử dụng pool mặc định của VIPOR):"
read pool
if [ -z "$pool" ]; then
  pool="stratum+tcp://cn.vipor.net:5040"
fi
echo "Nhập tên máy:"
read name

# Cập nhật config.json
sed -i "s|RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa|$wallet|g" config.json
sed -i "s|stratum+tcp://cn.vipor.net:5040|$pool|g" config.json
sed -i "s|PHONE-xx|$name|g" config.json

if [ ! -f ~/.bashrc ]; then
  echo "~/ccminer/start.sh" > ~/.bashrc
else
  if ! grep -Fxq "~/ccminer/start.sh" ~/.bashrc; then
    echo "~/ccminer/start.sh" >> ~/.bashrc
  fi
fi

CXX=clang++ CC=clang ./build.sh

echo "Thiết lập gần hoàn tất."
echo "Để cấu hình lại, nhập lệnh \"nano ~/ccminer/config.json\""
echo "Sau khi cài đặt xong khởi động lại máy để đào ổn định hơn."
