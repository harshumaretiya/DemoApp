# frozen_string_literal: true

class StatusReflex < ApplicationReflex

  def change
    todo = Todo.find(element.dataset[:id])
    todo.update(status: element.dataset[:status])
  end
end
