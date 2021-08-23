# Hello


 - Install erlang 23.0 and elixir 1.12.1, set the global or local options
 - mix deps.get from root of the project
 - mix ecto.setup / mix ecto.create && mix ecto.migrate
 - mix test for test suite
 - iex -S mix for running application.



One thing which I didnt do is handle internet disconnection downtime but its own downtime is being handled correctly.

I tried to add tests as possible but mostly working in GenServer its not obvious to test them but the main logic.

- CI.Maintainer is the one to handle downtime
- Worker is the one to do what is required. I used a dynamic supervisor for this

- iex -S mix
-  to start a worker to fetch intensity values do this

`CI.Intensity.Supervisor.start_child(CI.Intensity.Worker, %{})`

as state is not very important here.


The part which I didnt do.

For that, I would use a queue such as Oban or similar to keep the failed requests, as If internet would be down? Oban would not work with the remote Database as well.

So I would create a GenServer, to do pop and push to the state, with failed requests, 

Once the internet is back,(to check internet I would make a ping manager , to google.com) I would fetch all the failed requests from that GenServers state, and then make HTTP calls for it. Its easy :)

I am sorry that I didnt add that part , I tried to manage my time as much as possible, this is where I got to. Thanks.