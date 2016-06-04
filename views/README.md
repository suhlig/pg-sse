# `pg-sse` - Relays Database Updates to an SSE stream

Listens to a [Postgres channel](https://www.postgresql.org/docs/current/static/sql-listen.html) and distributes any messages to HTTP clients via [server-sent events](https://www.w3.org/TR/eventsource/) (SSE).

The channel could be filled e.g. from a database trigger, as demonstrated in [Brent Tubbs'](https://github.com/btubbs) [Postgres + React TodoMVC Example](https://github.com/btubbs/todopy-pg/blob/master/todos/migrations/0002-add-todos-table/forward.sql). A new DB record would then trigger a notification to be sent to the channel, which is picked up by the [`pg_listen.rb`](lib/pg_listen.rb) process, which posts it via HTTP to [`sse_server.rb`](lib/sse_server.rb), which broadcasts it via SSE to all connected clients.

This is partially based on code in this [gist](https://gist.github.com/mig-hub/5633280).

# Getting Started

```
$ bundle install
$ PORT=4567 DB_URL=postgres:///mydb SSE_URL=http://localhost:4567 foreman start
$ open http://localhost:4567/
```

Just listen in with `curl`:

```
$ curl -s -H "Accept: text/event-stream" http://localhost:4567/stream
```

# Deployment

Just like the [front end](https://github.com/suhlig/HDM-Haushaltsbuch), I deploy this one to [Bluemix](http://bluemix.net) with a simple `cf push`. Have a look at the [`manifest.yml`](https://github.com/suhlig/pg-sse/blob/master/manifest.yml) for details. Heroku should be similar.

## Domains

```
cf create-domain <org> <domain>.eu-gb.mybluemix.net
```

To keep things simple, it is best to choose the same domain as where the main web app was deployed to.

## Configuration

The URL to the SSE stream is required by both the listener and the front end. The `SSE_URL` is set accordingly for both. Look at the `manifest.yml` of the [listener](https://github.com/suhlig/pg-sse/blob/master/manifest.yml) and the [front end](https://github.com/suhlig/HDM-Haushaltsbuch/blob/master/manifest.yml).

## Contributing

Please see [CONTRIBUTING.md](https://github.com/suhlig/pg-sse/blob/master/CONTRIBUTING.md).

# License

`pg-sse` is Copyright© 2016 Steffen Uhlig. It is free software, and may be redistributed under the terms specified in the [LICENSE](https://github.com/suhlig/pg-sse/blob/master/LICENSE) file.
