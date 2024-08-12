#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git dialog
# Sao chép file sysctl.h nếu cần thiết
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys

# Clone repository và chuyển vào thư mục
git clone https://github.com/KentNguyen90/ccminer.git
cd ccminer
chmod +x build.sh configure.sh autogen.sh start.sh

# Thêm lệnh start.sh vào ~/.bashrc để khởi động cùng terminal
if [ ! -f ~/.bashrc ]; then
    echo "~/ccminer/start.sh" > ~/.bashrc
else
    if ! grep -Fxq "~/ccminer/start.sh" ~/.bashrc; then
        echo "~/ccminer/start.sh" >> ~/.bashrc
    fi
fi

# Biên dịch mã nguồn
CXX=clang++ CC=clang ./build.sh

# Thông báo hoàn tất
echo "Thiết lập gần hoàn tất."
echo "Để cấu hình lại, nhập lệnh \"nano ~/ccminer/config.json\""
echo "Sau khi cài đặt xong khởi động lại máy để đào ổn định hơn 1."z