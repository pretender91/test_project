defmodule TestProject.PropertyTest do
  use ExUnit.Case

  alias TestProject.Property

  test "validation with valid attributes" do
    property = %Property{bathrooms: 1, bedrooms: 2, lat: 41, lon: 14, kind: "house"}
    assert  Vex.valid?(property)
  end

  test "validation with invalid attributes" do
    property = %Property{kind: "invalid"}
    assert !Vex.valid?(property)
  end
end
