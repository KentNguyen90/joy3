#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git dialog
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys

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

## Thông báo hoàn tất và lấy thông tin cấu hình
echo "Thiết lập gần hoàn tất."

# Lấy thông tin từ người dùng
echo "Setup CCminer for RIG NAME: "
read device_name < /dev/tty

# Kiểm tra nếu $device_name rỗng, sử dụng giá trị mặc định
if [ -z "$device_name" ]; then
    device_name="PHONE-XX" 
fi

echo "Enter POOL ADDRESS: " 
read pool_address < /dev/tty

# Kiểm tra nếu $pool_address rỗng, sử dụng giá trị mặc định
if [ -z "$pool_address" ]; then
    pool_address="stratum+tcp://cn.vipor.net:5040" 
fi

echo "Enter WALLET ADDRESS: " 
read wallet_address < /dev/tty

# Kiểm tra nếu $wallet_address rỗng, sử dụng giá trị mặc định
if [ -z "$wallet_address" ]; then
    wallet_address="RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa" 
fi

# Tạo nội dung config.json mới
config_content="{
    \"pools\": 
        [{
            \"name\": \"AUTO-VERUS\",
            \"url\": \"$pool_address\",
            \"timeout\": 180,
            \"disabled\": 0
        }],
    \"user\": \"$wallet_address.$device_name\",
    \"pass\": \"x\",
    \"algo\": \"verus\",
    \"threads\": 8,
    \"cpu-priority\": 1,
    \"cpu-affinity\": -1,
    \"retry-pause\": 10
}"

# Cập nhật config.json
rm ~/ccminer/config.json
echo "$config_content" > ~/ccminer/config.json
echo "config.json was updated."

# Thông báo cuối cùng
echo "Sau khi cài đặt xong khởi động lại máy để đào ổn định hơn."