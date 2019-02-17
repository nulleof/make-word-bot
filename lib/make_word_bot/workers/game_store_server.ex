defmodule MakeWordBot.GameStoreServer do
  use GenServer, restart: :permanent
  
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_game(chat_id) do
    game = GenServer.call(__MODULE__, {:get, chat_id})
    
    cond do
      game == nil -> nil
    
      Process.alive?(game) -> game
    
      # game is already dead
      true ->
        remove_game(chat_id)
        nil
    end
  end
  
  def stop_game(chat_id) do
    game = get_game(chat_id)
    
    case game do
      nil ->
        Logger.debug("Trying to stop not existed game")
        :ok
        
      pid ->
        send(pid, :end_game)
    end
  end

  def remove_game(chat_id) do
    GenServer.cast(__MODULE__, {:remove, chat_id})
  end

  def start_game(chat_id) do
    game = get_game(chat_id)
  
    case game do
      nil ->
        # spawn new process
        pid = Process.spawn(fn -> MakeWordBot.ProcessGame.start_link(chat_id) end, [])
        GenServer.cast(__MODULE__, {:add, chat_id, pid})
      _ ->
        Logger.debug("Trying to start already existed game")
        :ok
    end
  end
  
  @impl true
  def init(state) do
    {:ok, state}
  end
  
  @impl true
  def handle_call({:get, chat_id}, _from, state) do
    {:reply, Map.get(state, chat_id), state}
  end
  
  @impl true
  def handle_cast({:remove, chat_id}, state) do
    {:noreply, Map.delete(state, chat_id)}
  end
  
  @impl true
  def handle_cast({:add, chat_id, pid}, state) do
    {:noreply, Map.put(state, chat_id, pid)}
  end
end