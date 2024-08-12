# OONI Probe for Docker

Docker wrapper for OONI Probe, a tool designed to measure internet censorship by testing whether websites and/or apps are accessible.

- For more information visit the [OONI website](https://ooni.org) & [OONI Probe CLI repo](https://github.com/ooni/probe-cli).
- [Things you should know before running OONI Probe](https://ooni.org/about/risks/)

## Getting started

### Docker Compose

```yaml
services:
  ooniprobe:
    image: aaimio/ooniprobe:latest
    container_name: ooniprobe
    volumes:
      - ./ooniprobe:/config
    environment:
      informed_consent: false # Change this to true
      upload_results: false
      websites_max_runtime: 0
      websites_enabled_category_codes: null
      sleep: true
    restart: unless-stopped
```

### Docker CLI

```sh
docker run -d \
  --name ooniprobe \
  -v source=./ooniprobe,destination=/config \
  -e informed_consent=false \ # Change this to true
  -e upload_results=false \
  -e websites_max_runtime=0 \
  -e websites_enabled_category_codes=null \
  -e sleep=true \
  --restart unless-stopped \
  aaimio/ooniprobe:latest
```

### Tests against custom URLs

Run web connectivity tests on a custom URL list by creating a urls.txt file in the mounted volume.

For example:

**`urls.txt`**

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

- See https://ooni.org/support/ooni-probe-cli#ooniprobe-run-websites

### Environment Variables

| Variable                          | Description                                                                                                                                                                                                                                                                                                                                                   | Accepted values                                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `informed_consent`                | Boolean indicating whether you understand [the risks of running a probe](https://ooni.org/about/risks/).                                                                                                                                                                                                                                                      | `true`, `false`                                                |
| `upload_results`                  | Boolean indicating whether measurement results should be uploaded to the OONI collectors.                                                                                                                                                                                                                                                                     | `true`, `false`                                                |
| `websites_max_runtime`            | Maximum time in seconds to run website tests for.                                                                                                                                                                                                                                                                                                             | `number`                                                       |
| `websites_enabled_category_codes` | List indicating the allowed category codes to be used when running the websites test. If the value is set to `null` or an empty list (`[]`), all category codes are allowed. For a list of supported category codes, refer to the [Citizen Lab test-lists repo](https://github.com/citizenlab/test-lists/blob/master/lists/00-LEGEND-new_category_codes.csv). | e.g., `HUMN,ANON`, `null`, or an empty list (`[]`)             |
| `sleep`                           | Boolean indicating whether the Docker container should remain active and sleep between test executions. <br> - If set to `true`, the container will `sleep` after completing tests, ensuring that it doesn't exit. <br> - Alternatively, you could use a cron job to periodically start the container.                                                        | `true`, `false`                                                |
| `args`                            | Custom arguments appended to `ooniprobe run`, see [OONI Probe CLI](https://ooni.org/support/ooni-probe-cli). The default value is [`unattended`](https://ooni.org/support/ooni-probe-cli#ooniprobe-run-unattended).                                                                                                                                           | e.g. `ooniprobe run` command (e.g. `unattended` or `websites`) |

## License

- [OONI Probe for Docker](https://github.com/aaimio/ooniprobe/blob/main/LICENSE)
- [OONI Probe CLI license](https://github.com/ooni/probe-cli/blob/master/LICENSE)
- [OONI.org license](https://github.com/ooni/ooni.org/blob/master/LICENSE)
