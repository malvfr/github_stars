defmodule GithubStars.Tags.Tag do
  @moduledoc """
  Defines the validations and schema definition for the Tag entity
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:repo_id, :name]
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "tags" do
    field :name, :string
    field :repo_id, :integer
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:repo_id, :name])
    |> validate_required(@required_params)
  end

  def changeset(changeset, params) do
    changeset
    |> cast(params, [:repo_id, :name])
    |> validate_required(@required_params)
  end
end
