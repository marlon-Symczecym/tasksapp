defmodule Tasksapp do
  @moduledoc """
  Modulo Tasksapp fica a centralização de todas as funcções para se fazer na aplicação de gerenciador de tarefas

  Função mais utilizada `Tasksapp.register/1`
  """

  defp start do
    File.mkdir("tasks")
    File.write("tasks/tasks.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Função que faz o cadastro de uma nova tarefa, fazendo chamada a função `Tasks.register_task/1`
  """
  def register(message) do
    case File.exists?("tasks/tasks.txt") do
      true ->
        Tasks.register_task(message)

      false ->
        start()
        Tasks.register_task(message)
    end
  end

  @doc """
  Função que faz atualição do corpo da mensagem em uma tarefa já cadastrada, fazendo chamada a função `Tasks.update_task/2`
  """
  def update(id, new_message) do
    Tasks.update_task(id, new_message)
  end

  @doc """
  Função que marca uma tarefa como concluída, fazendo chamada a função `Tasks.concluded/1`
  """
  def conclude(id) do
    Tasks.concluded(id)
  end

  @doc """
  Função que faz a exclusão de uma tarefa, fazendo chamada a função `Tasks.delete_task/1`
  """
  def delete(id) do
    Tasks.delete_task(id)
  end

  @doc """
  Função que mostra todas as tarefas, fazendo chamada a função `Tasks.show_all/0`
  """
  def show_all do
    Tasks.show_all()
  end

  @doc """
  Função que mostra uma tarefa específica, fazendo chamada a função `Tasks.find_task/1`
  """
  def show_task(id) do
    Tasks.find_task(id)
  end

  @doc """
  Função que mostra as tarefas concluídas, fazendo chamada a função `Tasks.show_all_concluded/0`
  """
  def show_concluded do
    Tasks.show_all_concluded()
  end
end
