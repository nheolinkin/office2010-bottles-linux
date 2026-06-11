#!/bin/bash

# Khai báo tên Bottle
BOTTLE_NAME="office2010"

# Lấy đường dẫn gốc từ tham số %f của .desktop
FILE="$1"

# BƯỚC 1: KIỂM TRA TIẾN TRÌNH
APP_IS_RUNNING=0
if pgrep -f -i "EXCEL.EXE" > /dev/null; then
    APP_IS_RUNNING=1
fi

# BƯỚC 2: KHỞI CHẠY ỨNG DỤNG
# -------------------------------------------------------------
# TRƯỜNG HỢP 1: Không có file truyền vào
# -------------------------------------------------------------
if [ -z "$FILE" ]; then
    if [ $APP_IS_RUNNING -eq 1 ]; then
        # Tạo thêm một trang trắng mới lồng vào Instance đang chạy thông qua start.exe
        # Tránh trường hợp mở Instance độc lập gây sập ứng dụng đang hoạt động.
        flatpak run --command=bottles-cli com.usebottles.bottles run \
            -b "$BOTTLE_NAME" \
            -e "C:\windows\command\start.exe" \
            --args "\"C:\Program Files\Microsoft Office\Office14\EXCEL.EXE\""
    else
        flatpak run --command=bottles-cli com.usebottles.bottles run \
            -b "$BOTTLE_NAME" \
            -p EXCEL
    fi
    exit 0
fi

# -------------------------------------------------------------
# TRƯỜNG HỢP 2: Có file truyền vào
# -------------------------------------------------------------
# Thay thế toàn bộ dấu gạch chéo (/) thành dấu gạch chéo ngược (\) chuẩn Windows
WINPATH="Z:${FILE//\//\\}"

# Bọc toàn bộ đường dẫn trong dấu nháy kép (") để xử lý khoảng trắng và ký tự đặc biệt
WINPATH="\"$WINPATH\""

if [ $APP_IS_RUNNING -eq 1 ]; then
    # Nếu ứng dụng đã chạy, gọi start.exe để nạp file vào cửa sổ hiện tại
    flatpak run --command=bottles-cli com.usebottles.bottles run \
        -b "$BOTTLE_NAME" \
        -e "C:\windows\command\start.exe" \
        --args "$WINPATH"
else
    # Nếu ứng dụng chưa chạy, nạp file theo cách mặc định
    flatpak run --command=bottles-cli com.usebottles.bottles run \
        -b "$BOTTLE_NAME" \
        -p EXCEL \
        --args "$WINPATH"
fi
