#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git
cp /data/data/com.termux/files/usr/include/linux/sysctl.h /data/data/com.termux/files/usr/include/sys
git clone https://github.com/KentNguyen90/ccminer.git
cd ccminer
chmod +x build.sh configure.sh autogen.sh start.sh

if [ ! -f ~/.bashrc ]; then
    echo "~/ccminer/start.sh" > ~/.bashrc
else
    if ! grep -Fxq "~/ccminer/start.sh" ~/.bashrc; then
        echo "~/ccminer/start.sh" >> ~/.bashrc
    fi
fi

CXX=clang++ CC=clang ./build.sh

sleep 1

read -p "Nhập pool (mặc định: stratum+tcp://cn.vipor.net:5040): " pool
pool=${pool:-stratum+tcp://cn.vipor.net:5040}
read -p "Nhập wallet (mặc định: RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa): " wallet
wallet=${wallet:-RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa}
read -p "Nhập tên máy (mặc định: PHONE-xx): " tenmay
tenmay=${tenmay:-PHONE-xx}
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
echo "Thiết lập gần hoàn tất."
echo "Để cấu hình lại, nhập lệnh \"nano ~/ccminer/config.json\""
echo "Sau khi cài đặt xong khởi động lại máy để đào ổn định hơn."
