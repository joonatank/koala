defmodule KoalaWeb.SqlController do
   use KoalaWeb, :controller
   import KoalaWeb.Controllers.Helpers
   require Logger

   def index(conn, _params) do
      render conn, "index.html"
   end

   def show(conn, params) do
      #{:ok, conn: put_req_header(conn, "accept", "application/json")}
      Logger.debug("params = #{inspect(params)}")
      # ID as a parameter
      # TODO need to handle ID
      # if it's present we should only retrieve one row from the table
      table = get_cubes()

      if (params["id"] != nil) do
         id = elem(Integer.parse(params["id"]), 0)
         Logger.debug("id = #{inspect(id)}")
         t = Enum.at(table, id)
         Logger.debug("table = #{inspect(t)}")
      end

      Logger.debug("table length = #{inspect(length(table))}")
      Logger.debug("table = #{inspect(table)}")
      enc = Poison.encode!(table)
      Logger.debug("encoded = #{(enc)}")

      conn
      |> put_status(:ok)
      |> put_resp_content_type("application/json")
      |> send_resp(200, enc)
   end

   def modify(conn, _params) do
      # TODO parse message, find an object from table by id and modify it
   end

   def delete(conn, _params) do
      # TODO parse message, find the ID from it and delete that ID from the table

      conn
      |> put_status(:ok)
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "bar")
   end

   def create(conn, _params) do
      {:ok, data, _conn_details} = Plug.Conn.read_body(conn)
      #{:ok, conn: put_req_header(conn, "accept", "application/json")}
      Logger.debug(inspect(data))
      cube = Poison.decode!(~s| #{data}|, as: %KoalaWeb.CubeElem{})
      Logger.debug("id = #{cube.id}")
      Logger.debug(inspect(cube))

      nextIDq = """
         select count(*) from cubes
      """

      insertQ = """
         insert into cubes
         values ($1, $2, $3)
      """

      res = Ecto.Adapters.SQL.query!(Koala.Repo, nextIDq)
      cols = Enum.map res.columns, &(String.to_atom(&1))
      n_ids = List.first(List.first(res.rows))
      Logger.debug("ids = #{inspect(n_ids)}")

      # Add to SQL table
      # we ignore the ID and always add a new object
      res = Ecto.Adapters.SQL.query!(Koala.Repo, insertQ, [n_ids, cube.model_file, cube.state])

      conn
      |> put_status(:ok)
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "bar")
   end
end
