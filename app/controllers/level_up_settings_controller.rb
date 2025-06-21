class LevelUpSettingsController < ApplicationController
  before_action :require_user_selected
  before_action :set_level_up_setting, only: [:show, :edit, :update, :destroy]

  def index
    @level_up_settings = LevelUpSetting.all.order(:created_at)
  end

  def show
  end

  def new
    @level_up_setting = LevelUpSetting.new
  end

  def create
    @level_up_setting = LevelUpSetting.new(level_up_setting_params)
    
    if @level_up_setting.save
      redirect_to level_up_settings_path, notice: 'レベルアップ設定を作成しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @level_up_setting.update(level_up_setting_params)
      redirect_to level_up_settings_path, notice: 'レベルアップ設定を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    name = @level_up_setting.name
    @level_up_setting.destroy
    redirect_to level_up_settings_path, notice: "#{name}を削除しました。"
  end

  def toggle_enabled
    @level_up_setting = LevelUpSetting.find(params[:id])
    @level_up_setting.update!(enabled: !@level_up_setting.enabled)
    
    redirect_to level_up_settings_path, 
                notice: "#{@level_up_setting.name}を#{@level_up_setting.enabled ? '有効' : '無効'}にしました。"
  end

  private

  def set_level_up_setting
    @level_up_setting = LevelUpSetting.find(params[:id])
  end

  def level_up_setting_params
    params.require(:level_up_setting).permit(:name, :description, :hours_per_level, :achievements_per_level, :enabled)
  end
end 