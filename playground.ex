IO.puts(":foo === bar => #{:foo === :bar}\n")

IO.puts("is_atom(:foo_bar) => #{is_atom(:foo_bar)}\n")

IO.puts("is_boolean(1) => #{is_boolean(1)}")
IO.puts("is_boolean(nil) => #{is_boolean(nil)}")

IO.puts(":true === true => #{true === true}\n")

IO.write(":crypto.strong_rand_bytes 3 => ")
IO.inspect(:crypto.strong_rand_bytes(3))

name = "Erick"
IO.puts("\nHello " <> name <> "\n")

#### Lists ####

list = [3.14, :pie, "Apple"]

# Prepending (fast)
["π" | list]
["π", 3.14, :pie, "Apple"]

# Appending (slow)
list ++ ["Cherry"]
[3.14, :pie, "Apple", "Cherry"]

# List concatenation
list = [1, 2] ++ [3, 4, 1]
IO.inspect(list)

[head | tail] = [3.14, :pie, "Apple"]

# Map
nsx = %{make: "Honda/Acura", model: "NSX-R"}
new_nsx = Map.put(nsx, :year, 2002)
best_nsx = %{new_nsx | year: 1992}

IO.inspect(nsx)
IO.inspect(new_nsx)
IO.inspect(best_nsx)

Enum.map([1, 2, 3], fn number -> number + 3 end)
Enum.map([1, 2, 3], &(&1 + 3))

defmodule Adding do
  def plus_three(number), do: number + 3
end

Enum.map([1, 2, 3], fn number -> Adding.plus_three(number) end)
Enum.map([1, 2, 3], &Adding.plus_three(&1))

added = Enum.map([1, 2, 3], &Adding.plus_three/1)
IO.inspect(added)

# [1, 2, 3]
list = [1, 2, 3]

# [1, 2, 3]
[1, 2, 3] = list

# (MatchError) no match of right hand side value: [1, 2, 3]
# [] = list

# (MatchError) no match of right hand side value: [1, 2, 3]
#    (stdlib 5.1.1) erl_eval.erl:498: :erl_eval.expr/6
#    iex:11: (file)
# [123] = list

# Tuples
# {:ok, "Successful!"}
{:ok, _value} = {:ok, "Successful!"}

# "Successful!"
# value

# 1
x = 1

# (MatchError) no match of right hand side value: 2
# ^x = 2

# {2, 1}
{_x, ^x} = {2, 1}

# 2
# x

# (MatchError) no match of right hand side value: {:error}
# {:ok, value} = {:error}

key = "hello"

# %{"hello" => "world"}
%{^key => _value} = %{"hello" => "world"}

# (MatchError) no match of right hand side value: %{hello: "world"}
# %{^key => value} = %{:hello => "world"}

# "Not an Int"
unless is_integer("hello") do
  "Not an Int"
end

if String.valid?("Hello") do
  "Valid string!"
else
  "Invalid string."
end

case {:ok, "Hello World"} do
  {:ok, result} -> result
  {:error} -> "Uh oh!"
  _ -> "Catch all"
end

# case/2 relies on pattern matching:
pie = 3.14

# pin operator on switch case statement
case "cherry pie" do
  ^pie -> "Not so tasty"
  pie -> "I bet #{pie} is tasty"
end

# lambas can also be written with ->
sum = fn a, b -> a + b end
IO.puts(sum.(3, 3))

# Pattern matching with a lambda
handle_result = fn
  {:ok, _result} -> IO.puts("Handling result...")
  {:ok, _} -> IO.puts("This would be never run as previous will be matched beforehand.")
  {:error} -> IO.puts("An error has occurred!")
end

some_result = 1
handle_result.({:ok, some_result})

# Recursion with pattern matching
defmodule Length do
  def of([]), do: 0
  def of([_ | tail]), do: 1 + of(tail)
end

IO.puts(Length.of([]))
IO.puts(Length.of([1, 2, 3]))

# Pattern matching arguments
defmodule Greeter1 do
  def hello(%{name: person_name}) do
    IO.puts("Hello, " <> person_name)
  end
end

fred = %{
  name: "Fred",
  age: "95",
  favorite_color: "Taupe"
}

Greeter1.hello(fred)

# Pattern matching arguments with refence to the whole argument
defmodule Greeter2 do
  def hello(%{name: person_name} = person) do
    IO.puts("Hello, #{person_name}")
    IO.inspect(person)
  end
end

Greeter2.hello(fred)

defmodule Greeter3 do
  def hello(names) when is_list(names) do
    names = Enum.join(names, ", ")

    hello(names)
  end

  def hello(name) when is_binary(name) do
    IO.puts(phrase() <> name)
  end

  defp phrase, do: "Hello, "
end

Greeter3.hello(["Sean", "Steve"])

# Default arguments
defmodule Greeter4 do
  def hello(name, language_code \\ "en") do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

Greeter4.hello("Sean", "en")
Greeter4.hello("Sean")
Greeter4.hello("Sean", "es")

# did not understand
defmodule Greeter5 do
  def hello(names, language_code \\ "en")

  def hello(names, language_code) when is_list(names) do
    names = Enum.join(names, ", ")

    hello(names, language_code)
  end

  def hello(name, language_code) when is_binary(name) do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end

Greeter5.hello(["Sean", "Steve"])
Greeter5.hello(["Sean", "Steve"], "es")

# pipe operator
"Elixir rocks" |> String.split()
"Elixir rocks" |> String.upcase() |> String.split()
"elixir" |> String.ends_with?("ixir")

# Module nesting
defmodule Example.Greetings do
  def morning(name) do
    "Good morning #{name}."
  end

  def evening(name) do
    "Good night #{name}."
  end
end

# Module attributes are a constant
defmodule Example do
  @greeting "Hello"

  def greeting(name) do
    ~s(#{@greeting} #{name}.)
  end
end

# Structs
defmodule Example.User do
  defstruct name: "Sean", roles: []
end

# Updating a map
steve = %{name: "Steve"}
IO.inspect(steve)

steve = %{steve | name: "Sean"}
IO.inspect(steve)

# Structs cannot be accessed from a "root" module, it only works from within another module

defmodule Sayings.Greetings do
  def basic(name), do: "Hi, #{name}"
end

defmodule Main do
  @moduledoc """
  This module is great at X
  """

  @doc """
  Frobnicates the given string.
  """

  # By default all functions and macros are imported but we can filter them using the :only and :except options.
  import Example.Greetings, only: [morning: 1]
  # import List, except: [morning: 1]

  defmodule ImportMessage do
    alias Sayings.Greetings, as: Hi

    def print_message(name), do: Hi.basic(name)
  end

  def main do
    steve = %Example.User{name: "Josh"}
    IO.inspect(steve)

    IO.inspect(%Example.User{})
    # %Example.User<name: "Sean", roles: [], ...>

    IO.inspect(%Example.User{name: "Steve"})
    # %Example.User<name: "Steve", roles: [], ...>

    IO.inspect(%Example.User{name: "Steve", roles: [:manager]})
    # %Example.User<name: "Steve", roles: [:manager]>

    IO.puts(morning("Erick"))
  end
end

# Call main method from Main module
Main.main()

# Require only allows macros to be used rather than functions
# defmodule Example do
#   require SuperMacros

#   SuperMacros.do_stuff()
# end

# Note: quote, alias, use, require are macros related to metaprogramming.
