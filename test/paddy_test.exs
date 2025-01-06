defmodule PaddyTest do
  use ExUnit.Case, async: false
  import Mock

  alias Paddy
  alias GoogleApi.PubSub.V1.Api.Projects

  describe "publish/1" do
    test "must receive params and publish event" do
      version = :v1
      company_id = :rand.uniform(100)
      event_type = "foobar_event"
      payload = %{id: 1, name: "foobar"}
      event_timestamp = ~N[2018-08-01 22:15:07]

      params = %{
        version: version,
        company_id: company_id,
        event_type: event_type,
        event_timestamp: event_timestamp,
        payload: payload
      }

      with_mock Projects,
        pubsub_projects_topics_publish: fn _connection, _project_id, _topic_id, _params -> :ok end do
        Paddy.publish(params)

        assert called(Projects.pubsub_projects_topics_publish(:_, :_, :_, :_))
      end
    end
  end
end