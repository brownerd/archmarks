defmodule ArchmarksWeb.PageController do
  use ArchmarksWeb, :controller

  def about(conn, _params) do
    render(conn, :about)
  end
end
