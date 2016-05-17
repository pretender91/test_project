defmodule TestProject.Property do
  use TestProject.Web, :model

  schema do
    document_type "property"
    field :bathrooms, type: :integer
    field :bedrooms, type: :integer
    field :description, type: :string
    field :serviced, type: :boolean
    field :lat, type: :integer
    field :lon, type: :integer
    field :kind, type: :string
  end


  validates :bathrooms, presence: true,
                        numericality: [range: 0..100]
  validates :bedrooms,  presence: true,
                        numericality: [range: 0..100]
  validates :lat,       presence: true,
                        numericality: [range: -90..90]
  validates :lon,       presence: true,
                        numericality: [range: -180..180]
  validates :kind,      presence: true,
                        inclusion: ["room", "house", "apartment"]
end
