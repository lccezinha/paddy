# Paddy Elixir

This library intent is to create a wrapper and send data to a Google Pub Sub topic.

## Installation

Add the `paddy` lib to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:paddy, github: "ResultadosDigitais/paddy-elixir", tag: "0.1.0"}
  ]
end
```

**Disclaimer**

It will install three dependencies:

 - `google_api_pub_sub` Publish data to Google Pub Sub
 - `goth` Auth with google
 - `mock` (only for test env)

## Configuration

In the application that will use the `paddy` lib, you need to set some configurations that will be used for `paddy`, `google_api_pub_sub` and `goth`.

First you need to create and download your own credentials in Google Cloud Platform [click here for more information](https://cloud.google.com/genomics/docs/how-tos/getting-started).

Once you download your `credentials.json` file you are ready to set all configurations.

### Development/Test environment

- Inside `YOUR_APP_LIB/config` copy or create a new `json` file with the same content of `credentials.json`
- In the `app/config/dev.exs` and `app/config/test.exs` put the code:

```elixir
config :goth,
  json: "#{Path.dirname(__DIR__)}/config/YOUR_CREDENTIALS_FILE.json" |> File.read!()
```

### Production/Staging enviroment

First you need to set the `goth` configuration properly. You can follow the [Goth documentation](https://github.com/peburrows/goth#goth) and config the `goth` lib as you want.

You need to set the `paddy` configuration for `project_id` and `topic_id` that will be used internally to publish data to the given topic.

- In the `YOUR_APP_LIB/config/staging.exs` and `YOUR_APP_LIB/config/prod.exs` put the code:

```elixir
config :paddy,
  project_id: "some-project-id",
  topic_id: "some-topic"
```

### Using

> The lib is only responsible to receive the data and publish it to the previously set project_id/topic_id, the list IS NOT responsible to transform and mount the format, this step must be done by the application that will use `paddy`.

See an example of how to use Paddy in the `iex` console.

```elixir
iex> version = :v1
iex> company_id = :rand.uniform(100)
iex> event_type = "foobar_event"
iex> payload = %{id: 1, name: "foobar"}
iex> event_timestamp = ~N[2018-08-01 22:15:07]
iex> params = %{
  version: :v1,
  company_id: company_id,
  event_type: event_type,
  event_timestamp: event_timestamp,
  payload: payload
}
iex> data = %{
  event_type: "#{:v1}_foobar_event",
  event_identifier: payload[:id],
  event_timestamp: event_timestamp,
  tenant_id: company_id,
  event_family: "SOME_FAMILY",
  payload: payload
}
iex> alias Paddy
iex> Paddy.publish(data)
iex> {:ok,%GoogleApi.PubSub.V1.Model.PublishResponse{messageIds: ["SOME_MESSAGE_ID"]}}
```

### Development

To improve the lib or run the tests locally you also will need to create a credential file and put if inside `config/YOU_CREDENTIALS_FILE.json`, recommended name
for this file is `google-pub-sub-fake-data.json`. If you pick another name, you need to change the path for the file inside `config/test.exs`.
