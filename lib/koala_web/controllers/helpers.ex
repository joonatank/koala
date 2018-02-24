defmodule KoalaWeb.Quote do
   defstruct [:author, :quote]
end

defmodule KoalaWeb.CubeElem do
   defstruct [:id, :model_file, :state]
end

defmodule KoalaWeb.UseCase do
   defstruct [:id, :name, :script_file]
end

defmodule KoalaWeb.CaseCubes do
   defstruct [:name, :model_file]
end

defmodule KoalaWeb.Controllers.Helpers do
   require Logger

   def get_cubes() do
      query = """
         select id, model_file, state
         from cubes
      """

      res = Ecto.Adapters.SQL.query!(Koala.Repo, query)
      cols = Enum.map res.columns, &(String.to_atom(&1))
      Enum.map res.rows, fn(row) ->
         struct(KoalaWeb.CubeElem, Enum.zip(cols, row))
      end
   end

  def get_cases() do
    query = """
      select id, name, script_file
      from use_cases
    """

    res = Ecto.Adapters.SQL.query!(Koala.Repo, query)
    cols = Enum.map res.columns, &(String.to_atom(&1))
    Enum.map res.rows, fn(row) ->
       struct(KoalaWeb.UseCase, Enum.zip(cols, row))
    end
  end

  def get_case_cubes() do
    query = """
      select name, model_file
      from case_cubes
      join cubes on cubeid=cubes.id
      join use_cases on caseid=use_cases.id;
    """

    res = Ecto.Adapters.SQL.query!(Koala.Repo, query)
    cols = Enum.map res.columns, &(String.to_atom(&1))
    Enum.map res.rows, fn(row) ->
      struct(KoalaWeb.CaseCubes, Enum.zip(cols, row))
    end
  end
end

