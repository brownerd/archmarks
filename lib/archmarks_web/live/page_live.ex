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
             |> Enum.map(fn filename ->
                {:ok, binary} = 
                  :code.priv_dir(:archmarks) 
                  |> Path.join("static/images/archmarks/#{filename}") 
                  |> File.read()

                {_mine_type, width, height, _variant} = ExImageInfo.info(binary)

                {filename, width, height}
             end)

  @total_archmarks Enum.count(@archmarks)

  @archmarks_by_alpha @archmarks |> Enum.group_by(fn {filename, _, _} -> String.at(filename, 6) end)

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
      |> assign(:active_letter, nil)
      |> assign(:search_query, "")
      |> assign(:total_archmarks, @total_archmarks)

    # IO.inspect({"00000-unknown-013.JPG", width, height}, label: ">>> image deets")

    {:ok, socket}
  end

  @impl true
  def handle_event("filter", %{"letter" => "all"}, socket) do
    socket =
      socket
      |> assign(:archmarks, @archmarks)
      |> assign(:active_letter, nil)

    {:noreply, socket}
  end

  def handle_event("filter", %{"letter" => letter}, socket) do
    socket =
      socket
      |> assign(:archmarks, Map.get(@archmarks_by_alpha, letter, []))
      |> assign(:active_letter, letter)

    {:noreply, socket}
  end

  def handle_event("search", %{"query" => query}, socket) do
    socket =
      socket
      |> assign(:archmarks, search_archmarks(String.upcase(query)))
      |> assign(:search_query, query)
      |> assign(:active_letter, nil)

    {:noreply, socket}
  end

  attr :filename, :string, required: true
  attr :width, :string, required: true
  attr :height, :string, required: true

  def archmark(assigns) do
    ~H"""
    <div class="frame">
      <div class="frame-inset">
        <!-- <h1>{@archmark}</h1> -->
        <!-- <img src={"/images/archmarks/#{@archmark}"} alt={"logo for #{@archmark}"} loading="lazy"> -->
        <img 
          src={"/images/archmarks/#{@filename}"}
          alt={"logo for #{@filename}"}
          width={@width}
          height={@height}
          loading="lazy"
        />
      </div>
    </div>
    """
  end

  def filter_archmarks(letter) do
    Map.get(@archmarks_by_alpha, letter, "a")
  end

  def search_archmarks(input) do
    Enum.filter(@archmarks, fn {filename, _, _} -> String.contains?(filename, input) end)
  end
end
