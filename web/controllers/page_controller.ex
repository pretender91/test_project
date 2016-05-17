defmodule TestProject.PageController do
  use TestProject.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
