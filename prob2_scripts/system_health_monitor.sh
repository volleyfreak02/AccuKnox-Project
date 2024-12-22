LOG_FILE="/tmp/system_health.log"

# Thresholds
CPU_THRESHOLD=3  # in percentage
MEMORY_THRESHOLD=30  # in percentage
DISK_THRESHOLD=30  # in percentage
PROCESS_COUNT_THRESHOLD=250  # number of processes

# Function to log messages
log_message() {
    local message=$1
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" >>  $LOG_FILE
}

# Check CPU usage
check_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        log_message "ALERT: High CPU usage detected: ${cpu_usage}%"
    fi
}

check_memory_usage() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        log_message "ALERT: High memory usage detected: ${memory_usage}%"
    fi
}

check_disk_usage() {
    local disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if (( disk_usage > DISK_THRESHOLD )); then
        log_message "ALERT: High disk usage detected: ${disk_usage}%"
    fi
}

check_process_count() {
    local process_count=$(ps aux | wc -l)
    if (( process_count > PROCESS_COUNT_THRESHOLD )); then
        log_message "ALERT: High number of running processes detected: ${process_count}"
    fi
}


main () {

	check_cpu_usage
	check_memory_usage
	check_disk_usage
	check_process_count
}

main
