defmodule TasksappTest do
  use ExUnit.Case
  doctest Tasksapp

  setup do
    File.mkdir("tasks")
    File.write("tasks/tasks.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm_rf("tasks")
    end)
  end

  test "deve cadastrar uma tarefa" do
    assert Tasksapp.register("Fazer TDD") == {:ok, "Tarefa cadastrada com sucesso!"}
  end

  test "deve invocar o case false da condição e criar a pasta e arquivos" do
    File.rm_rf("tasks/tasks.txt")
    assert Tasksapp.register("Fazer TDD") == {:ok, "Tarefa cadastrada com sucesso!"}
  end

  test "deve retornar tarefas concluidas" do
    Tasksapp.register("Estudar JavaScript")
    Tasksapp.register("Fazer Cafe")

    assert Tasksapp.show_concluded() == []
  end

  test "deve retornar a lista inteira de tarefas" do
    Tasksapp.register("Fazer TDD 1")
    Tasksapp.register("Estudar JavaScript")
    Tasksapp.register("Fazer Cafe")

    assert Tasksapp.show_all() |> Enum.count() == 3
  end

  test "deve retornar que nao possui nenhuma tarefa cadastrada" do
    assert Tasksapp.show_all() == {:error, "Nao possui tarefas cadastradas!"}
  end

  test "deve retornar que a tarefa nao foi encontrada" do
    assert Tasksapp.show_task(1) == {:error, "Tarefa não encontrada"}
  end

  test "deve deletar um item da lista" do
    Tasksapp.register("Fazer TDD 1")
    Tasksapp.register("Estudar JavaScript")
    Tasksapp.register("Fazer Cafe")

    assert Tasksapp.delete(1) == {:ok, "Tarefa deletada com sucesso"}
  end

  test "marcar uma tarefa como concluida" do
    Tasksapp.register("Fazer TDD 1")
    Tasksapp.register("Estudar JavaScript")

    assert Tasksapp.conclude(1) == {:ok, "Tarefa 1 concluida com sucesso!"}
    assert Tasksapp.show_concluded() |> Enum.count() == 1
  end

  test "deve retornar uma tarefa com mensagem atualizada" do
    Tasksapp.register("Fazer TDD 1")

    assert Tasksapp.update(0, "TDD deve ser feito") ==
             {:ok, "Mensagem da tarefa 0 atualizada com sucesso!"}
  end
end
