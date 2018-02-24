defmodule KoalaWeb.Quote do
   defstruct [:author, :quote]
end

defmodule KoalaWeb.CubeElem do
   defstruct [:id, :location, :model, :state]
end

defmodule KoalaWeb.Controllers.Helpers do
   require Logger

   def get_cube_table() do
      query = """
         select id, location, model, state
         from cubes
      """

      res = Ecto.Adapters.SQL.query!(Koala.Repo, query)
      cols = Enum.map res.columns, &(String.to_atom(&1))
      Enum.map res.rows, fn(row) ->
         struct(KoalaWeb.CubeElem, Enum.zip(cols, row))
      end
   end
end

