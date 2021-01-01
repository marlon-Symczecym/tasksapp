defmodule Tasks do
  defstruct id: 0, message: nil, concluded: false, date: nil
  @file_tasks "tasks/tasks.txt"

  @doc """
  Função que faz o cadastro de uma nova tarefa

  ## Parâmetro da função

  - message: corpo da tarefa

  ## Exemplo

      iex> Tasks.register("Tarefa Teste")
      {:ok, "Tarefa cadastrada com sucesso!"}
  """
  def register_task(message) do
    (read() ++
       [
         %__MODULE__{
           id: id_generate(),
           message: message,
           concluded: false,
           date: DateTime.utc_now()
         }
       ])
    |> :erlang.term_to_binary()
    |> write()

    {:ok, "Tarefa cadastrada com sucesso!"}
  end

  @doc """
  Função que marca uma tarefa como concluída

  ## Parâmetros da função

  - id: id da tarefa que deseja marcar como concluída
  """
  def concluded(id) do
    {old_task, new_list} = delete_item(id)

    (new_list ++ [%__MODULE__{old_task | concluded: true}])
    |> :erlang.term_to_binary()
    |> write()

    {:ok, "Tarefa #{id} concluida com sucesso!"}
  end

  @doc """
  Função que mostra as tarefas concluídas
  """
  def show_all_concluded do
    read()
    |> Enum.filter(fn tasks -> tasks.concluded == true end)
  end

  @doc """
  Função que mostra todas as tarefas, tanto as concluídas quanto as não concluídas
  """
  def show_all() do
    cond do
      read() |> Enum.count() > 0 ->
        read()
        |> Enum.map(& &1)

      read() |> Enum.count() == 0 ->
        {:error, "Nao possui tarefas cadastradas!"}
    end
  end

  @doc """
  Função que mostra uma tarefa específica

  ## Parâmetros da função

  - id: id da tarefa que deseja mostrar
  """
  def find_task(id) do
    case read()
         |> Enum.find(&(&1.id == id)) do
      nil ->
        {:error, "Tarefa não encontrada"}

      _ ->
        read()
        |> Enum.find(&(&1.id == id))
    end
  end

  @doc """
  Função que faz atualição do corpo da mensagem em uma tarefa já cadastrada

  ## Parâmetros da função

  - id: id da tarefa que deseja atualizar
  - new_message: novo corpo para tarefa

  ## Exemplo

      iex> Tasksapp.update(0, "Tarefa Atualizada")
      {:error, "Tarefa não encontrada"}
  """
  def update_task(id, new_message) do
    cond do
      find_task(id) == {:error, "Tarefa não encontrada"} ->
        {:error, "Tarefa não encontrada"}

      find_task(id) != {:error, "Tarefa não encontrada"} ->
        {old_task, new_list} = delete_item(id)

        (new_list ++ [%__MODULE__{old_task | message: new_message}])
        |> :erlang.term_to_binary()
        |> write()

        {:ok, "Mensagem da tarefa #{id} atualizada com sucesso!"}
    end
  end

  @doc """
  Função que faz a exclusão de uma tarefa

  ## Parâmetros da função

  - id: id da tarefa que deseja deletar
  """
  def delete_task(id) do
    cond do
      find_task(id) == {:error, "Tarefa não encontrada"} ->
        {:error, "Tarefa não encontrada"}

      find_task(id) != {:error, "Tarefa não encontrada"} ->
        {_old_task, new_list} = delete_item(id)

        new_list
        |> :erlang.term_to_binary()
        |> write()

        {:ok, "Tarefa deletada com sucesso"}
    end
  end

  defp delete_item(id) do
    cond do
      find_task(id) == {:error, "Tarefa não encontrada"} ->
        {:error, "Tarefa não encontrada"}

      find_task(id) != {:error, "Tarefa não encontrada"} ->
        old_task = find_task(id)

        new_list =
          read()
          |> List.delete(old_task)

        {old_task, new_list}
    end
  end

  @doc """
  Função que gera uma id para cada tarefa com base em quantas tarefas estão cadastradas
  """
  def id_generate do
    read()
    |> Enum.count()
  end

  defp write(list_tasks) do
    File.write(@file_tasks, list_tasks)
  end

  defp read() do
    {:ok, tasks} = File.read(@file_tasks)

    tasks
    |> :erlang.binary_to_term()
  end
end
