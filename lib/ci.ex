defmodule CI do
  use HTTPoison.Base

  @endpoint "https://api.carbonintensity.org.uk"

  def process_url(url) do
    @endpoint <> url
  end

  def process_request_headers(headers \\ []) do
    ["Accept": "Application/json"] ++ headers
  end

  def process_response_body(body) do
    body
    |> Jason.decode!
    |> extract_data()
  end

  defp extract_data(%{"data" => [%{"from" => from, "intensity" => %{"actual" => actual}}]}), do: %{datetime: from, intensity: actual}

  defp extract_data(response), do: response
end
