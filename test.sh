#!/bin/sh
yes | pkg update && pkg upgrade
yes | pkg install libjansson build-essential clang binutils git

# Yêu cầu người dùng nhập các thông tin cần thiết
read -p "Nhập địa chỉ pool (mặc định: stratum+tcp://cn.vipor.net:5040): " pool
pool=${pool:-stratum+tcp://cn.vipor.net:5040}

read -p "Nhập địa chỉ ví wallet (mặc định: RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa): " wallet
wallet=${wallet:-RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa}

read -p "Nhập tên máy (mặc định: PHONE-xx): " machine_name
machine_name=${machine_name:-PHONE-xx}

# Clone repository và chuyển vào thư mục
git clone https://github.com/KentNguyen90/ccminer.git
cd ccminer

# Cập nhật file config.json với thông tin đã nhập
cat <<EOL > config.json
{
    "pools":
        [{
            "name": "AUTO-VERUS",
            "url": "$pool",
            "timeout": 180,
            "disabled": 0
        }],
    "user": "$wallet.$machine_name",
    "pass": "x",
    "algo": "verus",
    "threads": 8,
    "cpu-priority": 1,
    "cpu-affinity": -1,
    "retry-pause": 10
}
EOL

chmod +x build.sh configure.sh autogen.sh start.sh

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
