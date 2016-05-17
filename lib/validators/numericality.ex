defmodule TestProject.Validators.Numericality do
  use Vex.Validator

  def validate(value, options) when not is_integer(value) do
    unless_skipping(value, options) do
      result false, message(options, "is not a number", value: value)
    end
  end

  def validate(value, options) when is_list(options) do
    unless_skipping(value, options) do
      {lower, upper} = limits = bounds(options)

      {findings, default_message} = case limits do
        {nil, nil} -> raise "Missing numericality vlidation range"
        {same, same} -> {value == same, "must be equal to #{same}"}
        {min, max} -> {min <= value and value <= max, "mast be in range #{min}..#{max}"}
      end

      result findings, message(options, default_message, value: value)
    end
  end

  defp bounds(options) do
    range = Keyword.get(options, :range)
    cond do
      range ->
        min..max= range
        {min, max}
        true -> {nil, nil}
    end
  end

  defp result(true, _), do: :ok
  defp result(false, message), do: {:error, message}
end
