class NullpoGamesController < ApplicationController
  before_action :require_user_selected

  def show
    @game = current_user.nullpo_game_or_create!
    @total_clicks_all_users = NullpoGame.total_clicks_all_users
    @total_nullpo_count_all_users = NullpoGame.total_nullpo_count_all_users
  end

  def status
    @game = current_user.nullpo_game_or_create!
    
    # 自動クリックの処理
    @game.auto_click!
    
    render json: {
      nullpo_count: @game.formatted_nullpo_count,
      total_clicks: @game.total_clicks,
      click_power: @game.click_power,
      auto_clicks_per_second: @game.formatted_auto_clicks_per_second,
      total_clicks_all_users: NullpoGame.total_clicks_all_users,
      total_nullpo_count_all_users: NullpoGame.total_nullpo_count_all_users,
      success: true
    }
  rescue => e
    render json: { 
      error: e.message,
      success: false
    }, status: :unprocessable_entity
  end

  def click
    @game = current_user.nullpo_game_or_create!
    @game.click!
    
    respond_to do |format|
      format.html { redirect_to nullpo_game_path }
      format.json { 
        render json: { 
          nullpo_count: @game.formatted_nullpo_count,
          total_clicks: @game.total_clicks,
          click_power: @game.click_power,
          auto_clicks_per_second: @game.formatted_auto_clicks_per_second,
          total_clicks_all_users: NullpoGame.total_clicks_all_users,
          total_nullpo_count_all_users: NullpoGame.total_nullpo_count_all_users,
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
    @game = current_user.nullpo_game_or_create!
    @game.update!(
      nullpo_count: 0,
      total_clicks: 0,
      auto_clicks_per_second: 0,
      click_power: 1
    )
    redirect_to nullpo_game_path, notice: 'ゲームをリセットしました！'
  end
end 