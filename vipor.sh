#!/bin/sh
# Lấy thông tin từ người dùng
echo "Setup CCminer for RIG NAME: "
read device_name < /dev/tty

# Kiểm tra nếu $device_name rỗng, sử dụng giá trị mặc định
if [ -z "$device_name" ]; then
    device_name="PHONE-XX" 
fi


# Tạo nội dung config.json mới
config_content="{
    \"pools\": 
        [{
            \"name\": \"AUTO-VERUS\",
            \"url\": \"stratum+tcp://cn.vipor.net:5040\",
            \"timeout\": 180,
            \"disabled\": 0
        }],
    \"user\": \"RRssVi5MDs5MUAkbtBWbCTfcRy8qbua4Fa.$device_name\",
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