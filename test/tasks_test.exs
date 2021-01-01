defmodule TaskTest do
  use ExUnit.Case
  doctest Task

  setup do
    File.mkdir("tasks")
    File.write("tasks/tasks.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm_rf("tasks")
    end)
  end

  test "deve retornar estrutura do modulo" do
    assert(
      %Tasks{id: 0, message: "Mensagem teste", concluded: false, date: DateTime.utc_now()}.message ==
        "Mensagem teste"
    )
  end

  test "deve cadastrar uma tarefa" do
    assert Tasks.register_task("Fazer TDD") == {:ok, "Tarefa cadastrada com sucesso!"}
  end

  test "deve contar quantas tasks tem gerando um id" do
    assert Tasks.id_generate() == 0
  end

  test "deve retornar tarefas concluidas" do
    Tasks.register_task("Estudar JavaScript")
    Tasks.register_task("Fazer Cafe")

    assert Tasks.show_all_concluded() == []
  end

  test "deve retornar a lista inteira de tarefas" do
    Tasks.register_task("Fazer TDD 1")
    Tasks.register_task("Estudar JavaScript")
    Tasks.register_task("Fazer Cafe")

    assert Tasks.show_all() |> Enum.count() == 3
  end

  test "deve retornar que nao possui nenhuma tarefa cadastrada" do
    assert Tasks.show_all() == {:error, "Nao possui tarefas cadastradas!"}
  end

  test "deve retornar que a tarefa nao foi encontrada" do
    assert Tasks.find_task(1) == {:error, "Tarefa não encontrada"}
  end

  test "deve deletar um item da lista" do
    Tasks.register_task("Fazer TDD 1")
    Tasks.register_task("Estudar JavaScript")
    Tasks.register_task("Fazer Cafe")

    assert Tasks.delete_task(1) == {:ok, "Tarefa deletada com sucesso"}
  end

  test "marcar uma tarefa como concluida" do
    Tasks.register_task("Fazer TDD 1")
    Tasks.register_task("Estudar JavaScript")

    assert Tasks.concluded(1) == {:ok, "Tarefa 1 concluida com sucesso!"}
    assert Tasks.show_all_concluded() |> Enum.count() == 1
  end

  test "deve retornar uma tarefa com mensagem atualizada" do
    Tasks.register_task("Fazer TDD 1")

    assert Tasks.update_task(0, "TDD deve ser feito") ==
             {:ok, "Mensagem da tarefa 0 atualizada com sucesso!"}
  end
end
