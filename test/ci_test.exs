defmodule CITest do
  use ExUnit.Case, async: true

  alias CarbonIntensity.HTTP.Mock

  import Mox

  setup :verify_on_exit!

  @url "https://api.carbonintensity.org.uk"

  test "it should return a custom error" do
    reason = :nxdomain

    Mock
    |> expect(:get, fn _url, _ ->
      {:error, %HTTPoison.Error{reason: :nxdomain}}
    end)

    assert {:error, ^reason} = CI.get("url")
  end

  test "it should return 400 error" do
    body =
      "{\r\n\"error\": {\r\n  \"code\": \"400 Bad Request\",\r\n  \"message\": \"Please enter a valid date in ISO8601 format 'YYYY-MM-DD' i.e. .../intensity/date/2017-08-25\"\r\n  }\r\n}"

    status_code = "400 Bad Request"

    Mock
    |> expect(:get, fn @url <> "/intensity/date/2017-08-258", [Accept: "Application/json"] ->
      {:ok, %HTTPoison.Response{body: body, status_code: 400}}
    end)

    assert {:error, ^status_code, _} = CI.get("/intensity/date/2017-08-258")
  end

  test "it should return a valid intensity data" do
    body =
      "{ \r\n  \"data\":[{ \r\n    \"from\": \"2021-08-22T14:30Z\",\r\n    \"to\": \"2021-08-22T15:00Z\",\r\n    \"intensity\": {\r\n      \"forecast\": 184,\r\n      \"actual\": 193,\r\n      \"index\": \"moderate\"\r\n    }\r\n  }]\r\n}"

    Mock
    |> expect(:get, fn @url <> "/intensity/2021-08-22T15:00Z", [Accept: "Application/json"] ->
      {:ok, %HTTPoison.Response{body: body, status_code: 200}}
    end)

    assert %{datetime: "2021-08-22T14:30Z", intensity: 193} =
             CI.get("/intensity/2021-08-22T15:00Z")
  end
end
