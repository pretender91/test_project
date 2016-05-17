defmodule TestProject.Repo.Schema do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  defmacro schema([do: block]) do
    quote do
      Module.register_attribute(__MODULE__, :struct_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :mapping_fields, accumulate: true)
      Module.put_attribute(__MODULE__, :struct_fields, :id)

      try do
        unquote(block)
      after
        :ok
      end

      Module.eval_quoted __ENV__, [
        unquote(__MODULE__).__mapping__(@mapping_fields),
        unquote(__MODULE__).__defstruct__(@struct_fields),
      ]

    end
  end

  defmacro document_type(name) do
    quote do
      unquote(__MODULE__).__document_type__(__MODULE__, unquote(name))
      def document_type, do: unquote(name)
    end
  end


  defmacro field(name, type \\ :string, opts \\ [null_value: nil]) do
    quote do
      unquote(__MODULE__).__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  def __document_type__(mod, name) do
    put_struct_field(mod, :__document_type__, name)
  end

  def __field__(mod, name, type \\ :string, opts \\ []) do
    put_struct_field(mod, name, opts[:null_value])
    put_mapping_field(mod, name, type,  opts)
  end

  def __defstruct__(struct_fields) do
    quote do
      defstruct unquote(Macro.escape(struct_fields))
    end
  end

  def __mapping__(mapping_fields) do
    map = mapping_fields |> Enum.into(%{}) |> Macro.escape
    quote do
      def __mapping__, do: unquote(map)
    end
  end

  defp put_mapping_field(mod, name, type, _opts) do
    fields = Module.get_attribute(mod, :mapping_fields)

    if List.keyfind(fields, name, 0) do
      raise ArgumentError, "field #{inspect name} is already set on mapping schema"
    end

    Module.put_attribute(mod, :mapping_fields, {name, type})
  end


  defp put_struct_field(mod, name, default_value) do
    fields = Module.get_attribute(mod, :struct_fields)

    if List.keyfind(fields, name, 0) do
      raise ArgumentError, "field #{inspect name} is already set on schema"
    end

    Module.put_attribute(mod, :struct_fields, {name, default_value})
  end
end
