class SkillsController < ApplicationController
  def new
    @skill = Skill.new(name: params[:name])
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      redirect_to buttons_path
    else
      render 'new'
    end
  end

  private
  def skill_params
    params.require(:skill).permit(:name)
  end
end
