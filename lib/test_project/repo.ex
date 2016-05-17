defmodule TestProject.Repo do

  alias TestProject.ElasticHTTP

  def create_index(module) do
    ElasticHTTP.post("", module_to_elastic(module))
  end

  def refresh_index() do
    ElasticHTTP.post("/_refresh")
  end

  def create(%{__document_type__: type} = document) do
    result = ElasticHTTP.post("/#{type}", document_to_elastic(document))
    |> process_response

    case result do
      {:ok, id} ->
        document = %{document | id: id}
        {:ok, document}
      other -> other
    end
  end

  def update(%{__document_type__: type, id: id} = document) do
    result = ElasticHTTP.post("/#{type}/#{id}", document_to_elastic(document))
    |> process_response

    case result do
     :ok -> {:ok, document}
     other -> other
    end
  end

  def delete(%{__document_type__: type, id: id} = document) do
    ElasticHTTP.delete("/#{type}/#{id}")
    |> process_response

    case result do
     :ok -> {:ok document}
     other -> other
    end
  end

  defp module_to_elastic(module) do
    properties = module.__mapping__
    |> Enum.map(fn({k, v}) ->
     {k, Enum.into(v, %{})}
    end)
    |> Enum.into(%{})
    %{
      "mappings" => %{
        module.document_type => %{
          "properties" => properties
        }
      }
    }
  end

  defp document_to_elastic(%{__struct__: mod} = document) do
    doc = mod.__mapping__
    |> Enum.map(fn({k, _v}) ->
      {k, Map.get(document, k)}
    end)
    |> Enum.into(%{})
  end

  defp process_response(response) do
    case extract_response(response) do
      {:ok, status_code, body} ->
        process_payload(status_code, body)
      {:error, _} -> {:error, nil}
    end
  end

  def extract_response({:ok, response}) do
    with %HTTPoison.Response{body: body, status_code: status_code} <- response,
    do: {:ok, status_code, body}
  end
  def extract_response({:error, _}), do: raise "Noy implemented"

  defp process_payload(201, %{"_id" => id}), do: {:ok, id}
  defp process_payload(200, %{}), do :ok
end
