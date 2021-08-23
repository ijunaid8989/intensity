defmodule CI do
  def get(url) do
    headers = process_request_headers()

    process_url(url)
    |> adapter().get(headers)
    |> process_response_body()
  end

  defp process_url(url) do
    endpoint() <> url
  end

  defp process_request_headers() do
    [Accept: "Application/json"]
  end

  defp process_response_body({:ok, %HTTPoison.Response{body: body, status_code: status_code}})
       when status_code in [400, 500] do
    body
    |> Jason.decode!()
    |> extract_error()
  end

  defp process_response_body({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Jason.decode!()
    |> extract_data()
  end

  defp process_response_body({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp extract_error(%{
         "error" => %{
           "code" => code,
           "message" => message
         }
       }) do
    {:error, code, message}
  end

  defp extract_data(%{"data" => [%{"from" => from, "intensity" => %{"actual" => actual}}]}),
    do: %{datetime: from, intensity: actual}

  defp extract_data(response), do: response |> extract_error()

  defp adapter(), do: Application.get_env(:c_i, :http_adapter)

  defp endpoint(), do: "https://api.carbonintensity.org.uk"
end
