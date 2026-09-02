defmodule ArchmarksWeb.PageController do
  use ArchmarksWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
