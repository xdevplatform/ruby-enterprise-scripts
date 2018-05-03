# ruby-enterprise-scripts
Sample Ruby scripts for using the Twitter Enterprise APIs. These are intended to be simple and easy to use scripts for anyone familiar with Ruby to make requests to the different APIs.

## Supported APIs
This list of APIs are currently supported by this collection of scripts:
1. [PowerTrack](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/powertrack-api) (Filter realtime Tweets)
2. [Decahose](https://developer.twitter.com/en/docs/tweets/sample-realtime/overview/decahose) (Sample realtime Tweets)
3. [Historical PowerTrack](https://developer.twitter.com/en/docs/tweets/batch-historical/overview) (Get batch historical Tweets)
4. [Search API](https://developer.twitter.com/en/docs/tweets/search/overview/enterprise) (both 30-Day and Full-Archve products)

## Authorization and Authentication
These scripts are part of our paid, Enterprise tier of API offerings. In order to make use of the scripts, you must have authorization to access the Enterprise APIs as part of a "trial" or ongoing contractual basis. If you have access to the [Gnip Console](console.gnip.com) and one or more of the APIs listed above, then you have the correct level of access.

You will need to use `basic authentication` to authenticate requests with the APIs encompassed by this script repository. Simply use our `username` and `password` that you currently use to login to your Gnip Console (console.gnip.com). The scripts provided suggest using environment variables, but allow for variable assignment of your creds and account details directly in the script itself.

## Getting Started
Each script requires you to input some basic information about your account and the API itself. For example, the account-level details are required:
```
account_name = "CompanyName" # cannot contains spaces
username = "name@example.com"
password = "your-password"
