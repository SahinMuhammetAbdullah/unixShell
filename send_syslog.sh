#!/bin/bash

# Log dosyalarının yolları
CURRENT_LOG="/var/log/syslog"
PREVIOUS_LOG="/var/log/previous_syslog"

# Önceki log dosyasının var olup olmadığını kontrol et
if [ ! -f "$PREVIOUS_LOG" ]; then
    # Eğer yoksa, mevcut log dosyasını önceki log olarak kopyala
    cp "$CURRENT_LOG" "$PREVIOUS_LOG"
    exit 0
fi

# Mevcut ve önceki log dosyalarındaki satır sayısını hesapla
line_current=$(wc -l < "$CURRENT_LOG")
line_previous=$(wc -l < "$PREVIOUS_LOG")

# Satır farkını hesapla
line_diff=$((line_current - line_previous))

# Eğer yeni satırlar varsa, bunları uzak sunucuya gönder
if [ "$line_diff" -gt 0 ]; then
    tail -n "$line_diff" "$CURRENT_LOG" | nc 10.10.10.11 514
fi

# Bir sonraki karşılaştırma için mevcut log dosyasını önceki log olarak kaydet
cp "$CURRENT_LOG" "$PREVIOUS_LOG"
