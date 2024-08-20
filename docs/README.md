# OONI Probe for Docker

Docker wrapper for OONI Probe, a tool designed to measure internet censorship by testing whether websites and apps are accessible.

- Contribute spare bandwidth to help measure internet censorship
- [Things you should know before running OONI Probe](https://ooni.org/about/risks/)
- For more information visit the [OONI website](https://ooni.org) & [OONI Probe CLI repo](https://github.com/ooni/probe-cli)

## Getting started

Running the Docker image will do the following:

1. Launch the OONI Probe CLI and start tests in [`unattended` mode](https://ooni.org/support/ooni-probe-cli#ooniprobe-run-unattended)
2. After tests complete, the container will `sleep` for 6 hours until the next run (if enabled through [env](#environment-variables))

### Docker Compose

```yaml
services:
  ooniprobe:
    image: aaimio/ooniprobe:latest
    container_name: ooniprobe
    volumes:
      - ./ooniprobe:/config
    environment:
      informed_consent: true
      upload_results: true
      sleep: true
    restart: unless-stopped
```

### Docker CLI

```sh
docker run \
  --name ooniprobe \
  -v ./ooniprobe:/config \
  -e informed_consent=true \
  -e upload_results=true \
  --restart unless-stopped \
  aaimio/ooniprobe:latest
```

## Environment variables

- **`informed_consent`**: Boolean indicating whether you understand [the risks of running a probe](https://ooni.org/about/risks/)
- **`upload_results`**: Boolean indicating whether measurements should be uploaded to the OONI collectors
- **`websites_max_runtime`**: Maximum time in seconds to run website tests for
- **`websites_enabled_category_codes`**: Category codes from the [Citizen Lab test-lists repo](https://github.com/citizenlab/test-lists/blob/master/lists/00-LEGEND-new_category_codes.csv), `null` or `[]`
- **`seconds_between_tests`**: Number of seconds between test runs (default is 21600 seconds = 6 hours)
- **`sleep`**: Boolean indicating whether the Docker container should sleep between test executions
  - If `true`, the container will `sleep` after completing tests, ensuring that it doesn't exit
  - Alternatively, you could use a cron or other type of orchestration to periodically start the container
- **`args`**: Custom arguments appended to `ooniprobe run`, see [OONI Probe CLI](https://ooni.org/support/ooni-probe-cli)

## Custom web connectivity tests

You can run web connectivity tests against custom URLs by creating a `urls.txt` file in the volume, e.g.:

```txt
https://www.facebook.com
https://www.twitter.com
https://www.bbc.com
https://www.cnn.com
https://www.wikileaks.org
https://www.torproject.org
https://www.amnesty.org
https://www.hrw.org
```

- Note that creating this file will result in _only_ web connectivity tests being run
- Also see https://ooni.org/support/ooni-probe-cli#ooniprobe-run-websites

## License

- [OONI Probe for Docker](https://github.com/aaimio/ooniprobe/blob/main/LICENSE)
- [OONI Probe CLI license](https://github.com/ooni/probe-cli/blob/master/LICENSE)
- [OONI.org license](https://github.com/ooni/ooni.org/blob/master/LICENSE)
