class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show update destroy ]

  
  def index
    @templates = Template.includes(:questoes).all

    render json: @templates.map { |template|
      template.as_json(include: :questoes)
    }
  end

  
  def show
    render json: @template.as_json(include: :questoes)
  end

  
  def create
    @template = Template.new(template_params)

    if @template.save
      render json: @template, status: :created, location: @template
    else
      render json: @template.errors, status: :unprocessable_content
    end
  end

  
  def update
    if @template.update(template_params)
      render json: @template
    else
      render json: @template.errors, status: :unprocessable_content
    end
  end

  
  def destroy
    @template.destroy!
  end

  private
    
    def set_template
      @template = Template.find(params.expect(:id))
    end

    
    def template_params
      params.expect(template: [ :nome, :descricao, :user_id ])
    end
end
