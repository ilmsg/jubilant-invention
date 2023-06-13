defmodule WeatherSensor do
  @moduledoc false

  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    interval = Application.get_env(:weather_sensor, :interval)
    emqtt_opts = Application.get_env(:weather_sensor, :emqtt)
    report_topic = "reports/#{emqtt_opts[:clientid]}/temperature"
    {:ok, pid} = :emqtt.start_link(emqtt_opts)
    st = %{
      interval: interval,
      timer: nil,
      report_topic: report_topic,
      pid: pid
    }

    {:ok, set_timer(st), {:continue, :start_emqtt}}
  end

  defp handle_publish(["commands", _, "set_interval"], %{payload: payload}, st) do
    new_st = %{st | interval: String.to_integer(payload)}
    {:noreply, set_timer(new_st)}
  end

  defp handle_publish(_, _, st) do
    {:noreply, st}
  end

  defp parse_topic(%{topic: topic}) do
    String.split(topic, "/", trim: true)
  end

  defp set_timer(st) do
    if st.timer do
      Process.cancel_timer(st.timer)
    end
    timer = Process.send_after(self(), :tick, st.interval)
    %{st | timer: timer }
  end

  defp report_temperature(pid, topic) do
    temperature = 10.0 + 2.0 * :rand.normal()
    message = {System.system_time(:milliseconds), temperature}
    payload = :erlang.term_to_binary(message)
    :emqtt.publish(pid, topic, payload)
  end
end
