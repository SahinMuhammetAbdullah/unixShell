#!/bin/bash

# Log dosyalarının ve hedef log dosyasının yolu
LOG_DIR="/var/log"
OUTPUT_LOG_FILE="/var/log/combined_logs.log"

# Belirli log dosyaları
LOG_FILES=(
    "auth.log"
    "syslog"
    "kern.log"
    "daemon.log"
    "messages"
)

# Temizleme işlemi: Hedef dosyayı sıfırla
> "$OUTPUT_LOG_FILE"

# Log dosyalarını işleme
for LOG_FILE in "${LOG_FILES[@]}"; do
    if [ -f "$LOG_DIR/$LOG_FILE" ]; then
        echo "Processing $LOG_FILE" >> "$OUTPUT_LOG_FILE"
        echo "===================" >> "$OUTPUT_LOG_FILE"

        # Log dosyasını oku ve türüne göre etiketle
        while IFS= read -r LINE; do
            TIMESTAMP=$(echo "$LINE" | awk '{print $1 " " $2 " " $3}')
            MESSAGE=$(echo "$LINE" | sed 's/^[^ ]\+ [^ ]\+ [^ ]\+ //')
            
            # Etiketleme: log türüne göre
            case "$LOG_FILE" in
                auth.log)
                    TYPE="AUTH"
                    ;;
                syslog)
                    TYPE="SYSLOG"
                    ;;
                kern.log)
                    TYPE="KERNEL"
                    ;;
                daemon.log)
                    TYPE="DAEMON"
                    ;;
                messages)
                    TYPE="MESSAGE"
                    ;;
                *)
                    TYPE="UNKNOWN"
                    ;;
            esac

            # Yazma işlemi
            echo "$TIMESTAMP [$TYPE] $MESSAGE" >> "$OUTPUT_LOG_FILE"
        done < "$LOG_DIR/$LOG_FILE"

        echo "" >> "$OUTPUT_LOG_FILE"
    else
        echo "Log file $LOG_DIR/$LOG_FILE does not exist." >> "$OUTPUT_LOG_FILE"
    fi
done