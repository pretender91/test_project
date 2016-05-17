defmodule TestProject.NumericalityTest do
  use ExUnit.Case

  test "keyword list, provided range validation with min and max" do
    assert  Vex.valid?([component: 12], component: [numericality: [range: 0..100]])
    assert  !Vex.valid?([component: 12], component: [numericality: [range: 13..100]])
    assert !Vex.valid?([component: "12"], component: [numericality: [range: 0..100]])
  end


end
