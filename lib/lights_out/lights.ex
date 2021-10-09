defmodule LightsOut.LightsState do
  use GenServer
  alias Phoenix.PubSub

  @doc false
  def start_link(_opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        "CU01" => %{title: "Pinar del Río", count: 0},
        "CU15" => %{title: "Artemisa", count: 0},
        "CU03" => %{title: "La Habana", count: 0},
        "CU16" => %{title: "Mayabeque", count: 0},
        "CU04" => %{title: "Matanzas", count: 0},
        "CU05" => %{title: "Villa Clara", count: 0},
        "CU06" => %{title: "Cienfuegos", count: 0},
        "CU07" => %{title: "Sancti Spíritus", count: 0},
        "CU08" => %{title: "Ciego de Ávila", count: 0},
        "CU09" => %{title: "Camagüey", count: 0},
        "CU10" => %{title: "Las Tunas", count: 0},
        "CU11" => %{title: "Holguín", count: 0},
        "CU12" => %{title: "Granma", count: 0},
        "CU13" => %{title: "Santiago de Cuba", count: 0},
        "CU14" => %{title: "Guantánamo", count: 0},
        "CU99" => %{title: "Isla de la Juventud", count: 0}
      },
      name: __MODULE__
    )
  end

  @impl true
  def init(provinces) do
    {:ok, provinces}
  end

  @impl true
  def handle_call(:get_provinces, _from, provinces) do
    {:reply, provinces, provinces}
  end

  @impl true
  def handle_cast({:inc, province_id}, provinces) do
    current_province = provinces[province_id]
    new_count = current_province.count + 1
    current_province = %{current_province | count: new_count}
    provinces = Map.put(provinces, province_id, current_province)

    PubSub.broadcast(
      LightsOut.PubSub,
      "status",
      {:province_update, %{id: province_id, count: new_count}}
    )

    {:noreply, provinces}
  end

  @impl true
  def handle_cast({:dec, province_id}, provinces) do
    current_province = provinces[province_id]

    new_count =
      case current_province.count do
        0 -> 0
        _ -> current_province.count - 1
      end

    current_province = %{current_province | count: new_count}
    provinces = Map.put(provinces, province_id, current_province)

    PubSub.broadcast(
      LightsOut.PubSub,
      "status",
      {:province_update, %{id: province_id, count: new_count}}
    )

    {:noreply, provinces}
  end

  def get_provinces() do
    GenServer.call(__MODULE__, :get_provinces)
  end

  def inc_province(province_id) do
    GenServer.cast(__MODULE__, {:inc, province_id})
  end

  def dec_province(province_id) do
    GenServer.cast(__MODULE__, {:dec, province_id})
  end
end
