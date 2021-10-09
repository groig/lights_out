defmodule LightsOutWeb.LightLive.Index do
  use LightsOutWeb, :live_view
  alias Phoenix.PubSub
  alias LightsOut.LightsState

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(LightsOut.PubSub, "status")

    provinces = LightsState.get_provinces()
    current_province = Map.get(provinces, "CU01")

    socket =
      socket
      |> assign(:provinces, provinces)
      |> assign(:current_province, "CU01")
      |> assign(:current_province_title, current_province.title)
      |> assign(:current_province_count, current_province.count)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lights Out")
    |> assign(:light, nil)
  end

  @impl true
  def handle_event("set_current_province", %{"provincias" => province_id}, socket) do
    # regular validations for current step
    current_province = Map.get(socket.assigns.provinces, province_id)

    socket =
      socket
      |> assign(:current_province, province_id)
      |> assign(:current_province_title, current_province.title)
      |> assign(:current_province_count, current_province.count)

    {:noreply, assign(socket, :current_province, province_id)}
  end

  @impl true
  def handle_event("inc", _params, socket) do
    current_province_id = socket.assigns.current_province
    LightsState.inc_province(current_province_id)
    {:noreply, socket}
  end

  @impl true
  def handle_event("dec", _params, socket) do
    current_province_id = socket.assigns.current_province
    LightsState.dec_province(current_province_id)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:province_update, province}, socket) do
    provinces = socket.assigns.provinces
    to_update = provinces[province.id]
    to_update = %{to_update | count: province.count}
    provinces = Map.put(provinces, province.id, to_update)
    socket = assign(socket, :provinces, provinces)

    p_id = province.id

    socket =
      case socket.assigns.current_province do
        ^p_id -> assign(socket, :current_province_count, province.count)
        _ -> socket
      end

    {:noreply, socket}
  end
end
