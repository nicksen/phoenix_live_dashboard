defmodule Phoenix.LiveDashboard.SocketsPage do
  @moduledoc false
  use Phoenix.LiveDashboard.PageBuilder

  alias Phoenix.LiveDashboard.SystemInfo
  import Phoenix.LiveDashboard.Helpers

  @menu_text "Sockets"

  @impl true
  def render(assigns) do
    ~H"""
    <.live_table
      id="table"
      page={@page}
      title="Sockets"
      row_fetcher={&fetch_sockets/2}
      row_attrs={&row_attrs/1}
    >
      <:col
        field={:port}
        header_attrs={[class: "pl-4"]}
        cell_attrs={[class: "tabular-column-name tabular-column-id pl-4"]}
        :let={socket}
      >
        <%= socket[:port] |> encode_socket() |> String.trim_leading("Socket") %>
      </:col>
      <:col field={:module} sortable={:asc} />
      <:col
        field={:send_oct}
        header={"Sent"}
        header_attrs={[class: "text-right pr-4"]}
        cell_attrs={[class: "tabular-column-bytes pr-4"]}
        sortable={:desc}
        :let={socket}
      >
        <%= format_bytes(socket[:send_oct]) %>
      </:col>
      <:col
        field={:recv_oct}
        header={"Received"}
        header_attrs={[class: "text-right pr-4"]}
        cell_attrs={[class: "tabular-column-bytes pr-4"]}
        sortable={:desc}
        :let={socket}
      >
        <%= format_bytes(socket[:recv_oct]) %>
      </:col>
      <:col field={:local_address} header="Local Address" sortable={:asc} />
      <:col field={:foreign_address} sortable={:asc} />
      <:col field={:state} sortable={:asc} />
      <:col field={:type} sortable={:asc} />
      <:col field={:connected} header="Owner" :let={socket}>
        <%= encode_pid(socket[:connected]) %>
      </:col>
    </.live_table>
    """
  end

  defp fetch_sockets(params, node) do
    %{search: search, sort_by: sort_by, sort_dir: sort_dir, limit: limit} = params

    SystemInfo.fetch_sockets(node, search, sort_by, sort_dir, limit)
  end

  defp row_attrs(socket) do
    [
      {"phx-click", "show_info"},
      {"phx-value-info", encode_socket(socket[:port])},
      {"phx-page-loading", true}
    ]
  end

  @impl true
  def menu_link(_, _) do
    {:ok, @menu_text}
  end
end
