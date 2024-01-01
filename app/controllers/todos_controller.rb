class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    @todos = Todo.all
    render json: @todos
  end

  def show
    render json: @todo
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render json: @todo, status: :created, location: @todo
      '''
      status: :created はRailsのレスポンスでHTTPステータスコードを 201 Created に設定し、新しいリソースがサーバー上で正常に作成されたことを示す。
      location: @todo はHTTPレスポンスヘッダーの Location を設定し、新しく作成されたリソースのURI（[例]/todos/1）を指定する。これにより、クライアントは新しいリソースの場所を知ることができる。
      '''
    else
      render json: @todo.errors, status: :unprocessable_entity
      '''
      status: :unprocessable_entity はHTTPレスポンスのステータスコードを 422 Unprocessable Entity に設定する。リクエストは理解されたものの、処理できない内容（たとえばバリデーションエラーなど）があることを示す。
      '''
    end
  end

  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
  end

  private

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end