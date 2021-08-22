defmodule HTTP do
  @callback get(url) :: {:ok, Response.t() | AsyncResponse.t()} | {:error, Error.t()}
  # @callback get(url, headers) :: {:ok, Response.t() | AsyncResponse.t()} | {:error, Error.t()}

  @type url :: binary
  @type headers :: [{atom, binary}] | [{binary, binary}] | %{binary => binary}
  @type body :: binary | {:form, [{atom, any}]} | {:file, binary}
end
