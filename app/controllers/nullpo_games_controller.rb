class NullpoGamesController < ApplicationController
  before_action :require_user_selected
  before_action :set_game

  def show
    @game = current_user.nullpo_game || current_user.create_nullpo_game!
  end

  def status
    @game = current_user.nullpo_game || current_user.create_nullpo_game!
    
    # 自動クリックの処理
    @game.auto_click!
    
    render json: {
      nullpo_count: @game.formatted_nullpo_count,
      total_clicks: @game.total_clicks,
      click_power: @game.click_power,
      auto_clicks_per_second: @game.formatted_auto_clicks_per_second,
      success: true
    }
  rescue => e
    render json: { 
      error: e.message,
      success: false
    }, status: :unprocessable_entity
  end

  def click
    @game.click!
    
    respond_to do |format|
      format.html { redirect_to nullpo_game_path }
      format.json { 
        render json: { 
          nullpo_count: @game.formatted_nullpo_count,
          total_clicks: @game.total_clicks,
          click_power: @game.click_power,
          auto_clicks_per_second: @game.formatted_auto_clicks_per_second,
          success: true
        } 
      }
    end
  rescue => e
    respond_to do |format|
      format.html { redirect_to nullpo_game_path, alert: "エラーが発生しました: #{e.message}" }
      format.json { 
        render json: { 
          error: e.message,
          success: false
        }, status: :unprocessable_entity 
      }
    end
  end

  def reset
    @game.update!(
      nullpo_count: 0,
      total_clicks: 0,
      auto_clicks_per_second: 0,
      click_power: 1
    )
    redirect_to nullpo_game_path, notice: 'ゲームをリセットしました！'
  end

  private

  def set_game
    @game = NullpoGame.find_or_create_for_user(current_user)
  end
end 