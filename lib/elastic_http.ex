
defmodule TestProject.ElasticHTTP do
  use HTTPoison.Base

  defp process_request_headers(headers) do
    headers ++ [{"Content-Type", "application/json"}]
  end

  defp process_headers(headers) do
    []
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  defp process_request_body(body) when is_map(body) do
    Poison.encode!(body)
  end

  defp process_request_body(body), do: body

  defp process_url(url) do
    "#{host}:#{port}/test_project_#{Mix.env}" <> url
  end


  defp host, do: Application.get_env :elasticsearch, :host
  defp port, do: Application.get_env :elasticsearch, :port
end
