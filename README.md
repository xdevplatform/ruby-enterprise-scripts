# ruby-enterprise-scripts
Sample Ruby scripts for making request to the Twitter Enterprise APIs. These are intended to be simple and easy-to-use scripts for anyone familiar with Ruby and may be helpful building blocks for buidling your own custom code to integrate with the APIs.

## Supported APIs
This list of APIs are currently supported by this collection of scripts:
1. [PowerTrack](#powertrack) - Filter realtime Tweets
    * [Visit documentation](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/powertrack-api)
2. [Decahose](#decahose) - Sample realtime Tweets
    * [Visit documentation](https://developer.twitter.com/en/docs/tweets/sample-realtime/overview/decahose)
3. [Historical PowerTrack](#historical-powertrack) - Get batch historical Tweets
    * [Visit documentation](https://developer.twitter.com/en/docs/tweets/batch-historical/overview)
4. [Search API](#search-api) - 30-Day and Full-Archve products to Search for Tweets
    * [Visit documentation](https://developer.twitter.com/en/docs/tweets/search/overview/enterprise)

## Authorization and Authentication
These scripts are part of our paid, Enterprise tier of API offerings. In order to make use of the scripts, you must have authorization to access the Enterprise APIs as part of a "trial" or ongoing contractual basis. If you have access to the [Gnip Console](console.gnip.com) and one or more of the APIs listed above, then you have the correct level of access.

Use `basic authentication` to make requests to the APIs encompassed by this script repository. Use the username and password that you currently use to login to your Gnip Console (console.gnip.com). The scripts provided suggest setting your username and password as environment variables, but allow for variable assignment of your creds and account details directly in the script itself.

## Configuration
Each script requires you to input some basic information about your account and the API endpoint. For example, the account-level details  required are (found at the top of the script):
```
username = "name@example.com"
password = "your-password"
account_name = "CompanyName" # cannot contain spaces
```
There's also the notion of a `stream_label` or `endpoint_label` depending on the the API. This will be set by your account representative when your account is created and is normally `prod` or `dev`. Here's an example below using the PowerTrack API:
```
stream_label = "prod"
```
## PowerTrack
This streaming API enables you to filter the full Twitter firehose in realtime.
### Add a rule
Before you connect to the stream, you should add one more rules. Here's how:
1. Set your account-level details (via environment or direct variables) and assign your `stream_label` value (defaults to `prod`) in the `add_rule.rb` file.
2. Add your rule to the `rule_value` variable in the script.
3. Run:
```
$ ruby add_rule.rb
```
### List rules
To ensure you have rules on your stream, make a get request to list all rules on your stream: Run:
```
$ ruby list_rules.rb
```
### Connect to the stream
Make a get request to the stream endpoint to begin streaming Tweets. Run:
```
$ ruby get_stream.rb
```
### Delete rules
Here's how to delete a rule from your stream:
1. Find the rule ID of the rule you want to delete (included in response from list_rules.rb)
2. Add the rule ID to the array of rule_ids in the script
3. Run:
```
$ ruby delete_rule.rb
```

## Decahose
The only method supported with the Decahose API is a GET request to connect to the stream endpoint. Run:
```
$ ruby get_decahose.rb
```

## Historical PowerTrack
This is a job-based API that provides filtered access to the entire archive of publicly available Tweets.
### Create a job
### Get job status
### Accept a job
### Reject a job
### Get results for a job
### List active jobs

## Search API
The Search API is a RESTful API that supports one query (up to 2048 characters) per request and paginates through the full request to deliver all matched Tweets. There are two levels of available archive access – 30-Day or Full-Archive – and it has two endpoints: 1) Search endpoint (retrieve Tweet payloads) 2) Counts endpoint (retrieves volume associated with your query)
### Search request (data)
1. Set your account-level details (via environment or direct variables) and assign your `endpoint_label` value (defaults to `prod`) in the `search_request.rb` file.
2. Set the `archive` variable to your correct product access ('30Day' or 'fullarchive')
3. Enter your Search parameters (example provided in script):
```
rule = "from:twitterdev OR @twitterdev"
from_date = "201803010000"
to_date = "201803312359"
max_results = 500 
```
4. Run:
```
$ ruby search_request.rb
```
### Counts request (volume)
1. Set your account-level details (via environment or direct variables) and assign your `endpoint_label` value (defaults to `prod`) in the `counts_request.rb` file.
2. Set the `archive` variable to your correct product access ('30Day' or 'fullarchive')
3. Enter your Search counts parameters (example provided in script):
```
rule = "from:twitterdev OR @twitterdev"
from_date = "201803010000"
to_date = "201803312359"
bucket = "day"
```
4. Run:
```
$ ruby counts_request.rb
```
