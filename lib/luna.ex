defmodule Luna do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: Luna.Slack.Supervisor]])
    ]
    opts = [strategy: :one_for_one, name: Luna.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
