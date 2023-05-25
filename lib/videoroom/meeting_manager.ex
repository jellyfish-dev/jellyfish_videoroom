defmodule Videoroom.MeetingManager do
  @moduledoc """
  Module providing functions for interacting with Meetings
  """
  alias Videoroom.Meeting
  alias Videoroom.MeetingSupervisor

  @spec add_peer(binary()) :: {:ok, binary()}
  def add_peer(room_name) do
    child_spec = %{
      id: Meeting,
      start: {Meeting, :start_link, [[name: room_name]]},
      restart: :transient
    }

    case DynamicSupervisor.start_child(MeetingSupervisor, child_spec) do
      {:ok, meeting} ->
        meeting

      {:error, {:already_started, meeting}} ->
        meeting
    end
    |> Meeting.add_peer()
  end
end