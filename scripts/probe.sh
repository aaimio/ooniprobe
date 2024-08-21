#!/bin/sh

IFS=','

config_file="/config/config.json"
urls_file="/config/urls.txt"
last_run_file="/config/last_run"
probe_dir="/.ooniprobe"
seconds_between_tests=${seconds_between_tests:-21600}

log() {
  echo "[docker/ooniprobe]: $1"
}

enabled_category_codes=$(
  if [ "$websites_enabled_category_codes" = "null" ]; then
    echo "null"
    return
  fi

  JSON_ARRAY=""

  for code in ${websites_enabled_category_codes}; do
    JSON_ARRAY="$JSON_ARRAY\"$code\","
  done

  JSON_ARRAY="${JSON_ARRAY%,}"

  echo "[$JSON_ARRAY]"
)

echo "{
  \"_version\": 1,
  \"_informed_consent\": ${informed_consent:-false},
  \"sharing\": {
    \"upload_results\": ${upload_results:-false}
  },
  \"nettests\": {
    \"websites_max_runtime\": ${websites_max_runtime:-0},
    \"websites_enabled_category_codes\": $enabled_category_codes
  }
}" > $config_file

while true; do
  if [ "$informed_consent" != "true" ]; then
    log 'Set "informed_consent" to "true" to confirm you understand the risks of OONI Probe.'
    exit 1
  fi

  if [ -f "$last_run_file" ]; then
    prev_time=$(cat $last_run_file)
    curr_time=$(date +%s)
    diff_time=$((curr_time - prev_time))

    log "Last run was $diff_time seconds ago."

    if [ $diff_time -lt $seconds_between_tests ]; then
      if [ "$sleep" = "true" ]; then
        sleep_time=$((seconds_between_tests - diff_time))
        
        log "Sleeping for $sleep_time seconds before next run..."
        sleep $sleep_time
      else
        log "Sleep is disabled. Exiting."
        exit 0
      fi
    fi
  fi

  if [ -f "$urls_file" ]; then
    $probe_dir/ooniprobe run websites --input-file="$urls_file" --config="$config_file" $args
  else 
    $probe_dir/ooniprobe run --config="$config_file" ${args:-"unattended"}
  fi

  exit_status=$?
  
  log "Probe exited with status $exit_status"

  if [ "$exit_status" -eq 0 ]; then
    date +%s > $last_run_file # TODO: Update last run time if probe fails?
  fi

  if [ "$sleep" = "true" ]; then
    log "Finished. Sleeping for $seconds_between_tests seconds before next run..."
    sleep $seconds_between_tests
  else
    log "Finished. Sleep is disabled. Exiting."
    exit 0
  fi
done
