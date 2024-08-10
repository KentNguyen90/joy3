#!/bin/sh

# Cập nhật và cài đặt các gói cần thiết
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
# Yêu cầu người dùng nhập các thông tin cần thiết
pool=$(dialog --inputbox "Nhập pool (mặc định: stratum+tcp://cn.vipor.net:5040):" 10 60 "stratum+tcp://cn.vipor.net:5040" 3>&1 1>&2 2>&3 3>&-)
wallet=$(dialog --inputbox "Nhập ví wallet (mặc định: RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa):" 10 60 "RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa" 3>&1 1>&2 2>&3 3>&-)
tenmay=$(dialog --inputbox "Nhập tên máy (mặc định: PHONE-xx):" 10 60 "PHONE-xx" 3>&1 1>&2 2>&3 3>&-)

# Tạo file config.json với thông tin người dùng đã nhập
cat > ~/ccminer/config.json << EOF
{
    "pools": 
        [{
            "name": "AUTO-VERUS",
            "url": "$pool",
            "timeout": 180,
            "disabled": 0
        }],
    "user": "$wallet.$tenmay",
    "pass": "x",
    "algo": "verus",
    "threads": 8,
    "cpu-priority": 1,
    "cpu-affinity": -1,
    "retry-pause": 10
}
EOF

# Thông báo hoàn tất
echo "Thiết lập gần hoàn tất."
echo "Để cấu hình lại, nhập lệnh \"nano ~/ccminer/config.json\""
echo "Sau khi cài đặt xong khởi động lại máy để đào ổn định hơn 1."