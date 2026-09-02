defmodule ArchmarksWeb.PageLive do
  use ArchmarksWeb, :live_view
  use Phoenix.Component

  @archmarks :archmarks
             |> :code.priv_dir()
             |> Path.join("static/images/archmarks")
             |> File.ls!()
             |> Enum.reject(&(&1 == ".DS_Store"))
             |> Enum.map(&String.upcase/1)
             |> Enum.sort()
             |> Enum.reverse()

  @archmarks_by_alpha @archmarks
             # |> Enum.map(fn <<_counter::binary-size(6), rest::binary>> -> rest  end)
             |> Enum.group_by(&String.at(&1, 6))

  @archmarks_alpha_keys @archmarks_by_alpha
            |> Map.keys()
            |> Enum.sort()
    

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:archmarks, @archmarks)
      |> assign(:alpha_groups, @archmarks_by_alpha)
      |> assign(:alpha_keys, @archmarks_alpha_keys)

      IO.inspect(@archmarks_alpha_keys, label: ">>> ")

    {:ok, socket}
  end

  def archmark(assigns) do
    ~H"""
    <div class="frame">
      <div class="frame-inset">
        <!-- <h1>{@archmark}</h1> -->
        <img src={"/images/archmarks/#{@archmark}"} alt={"logo for #{@archmark}"} loading="lazy">
      </div>
    </div>
    """
  end

  def filter_archmarks(letter) do
    Map.get(@archmarks_by_alpha, letter, "a")
  end

  def search_archmarks(input) do
    Enum.filter(@archmarks, &String.contains?(&1, input))
  end
end
