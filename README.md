# pagerduty-notifier-action
Github action that pushes a notification to PagerDuty on a Pull Request

Here is an example of how you would setup the action in your own repository under `.github/workflows/notifier.yml`.
```yaml
name: Notify PagerDuty on Pull Request
on: [pull_request]
jobs:
  pd_notify:
    name: notification
    runs-on: ubuntu-latest
    steps:
      - name: pagerduty-notifier
        id: pd-notifier
        uses: lmasaya/pagerduty-notifier-action@v1
        env:
          PAGERDUTY_API_TOKEN: ${{ secrets.PAGERDUTY_API_TOKEN }}
          PAGERDUTY_ROUTING_KEY: ${{ secrets.PAGERDUTY_ROUTING_KEY }}
          PAGERDUTY_SEVERITY: 'warning'
          PAGERDUTY_SOURCE: ${{ github.repository }}
          PAGERDUTY_SUMMARY: ${{ github.actor }} created Pull Request on ${{ github.repository }}
```

You must pass the following environment variables to generate the alert. All fields are required for now.

| Environment variable  | Purpose                                             |
|:---------------------:|-----------------------------------------------------|
| PAGERDUTY_API_TOKEN   | Team or user token to access PagerDuty API          |
| PAGERDUTY_ROUTING_KEY | Key of PagerDuty service to route alert to team     |
| PAGERDUTY_SEVERITY    | Severity of the alert generated                     |
| PAGERDUTY_SOURCE      | Repository or source you want to see in description |
| PAGERDUTY_SUMMARY     | Summary to show on PagerDuty alert                  |

You should store the PAGERDUTY_API_TOKEN and PAGERDUTY_ROUTING_KEY as secrets of your repository or organization. See Github documentation on [creating and storing secrets](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets).

Instead of building the Dockerfile in the Github Action repository, the action runs a pre-built docker container built with the Dockerfile. You are welcome to fork and have the action build the container on run, but this will make running the action slower.
