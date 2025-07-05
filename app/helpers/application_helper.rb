module ApplicationHelper
  def format_duration(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    seconds = seconds % 60

    if hours > 0
      "#{hours}時間#{minutes}分#{seconds}秒"
    elsif minutes > 0
      "#{minutes}分#{seconds}秒"
    else
      "#{seconds}秒"
    end
  end

  def format_duration_short(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60

    if hours > 0
      "#{hours}時間#{minutes}分"
    else
      "#{minutes}分"
    end
  end

  # 並び替えリンクを生成するヘルパー
  def sortable_link(column, title, current_sort, current_order)
    # 現在の並び替えカラムと同じ場合は、順序を反転
    if current_sort == column
      new_order = current_order == "asc" ? "desc" : "asc"
      css_class = "sortable-link active"
      # 並び替えのアイコンを追加
      if current_order == "asc"
        icon = '<i class="fas fa-sort-up ms-1"></i>'
      else
        icon = '<i class="fas fa-sort-down ms-1"></i>'
      end
    else
      new_order = "asc"
      css_class = "sortable-link"
      icon = '<i class="fas fa-sort ms-1 text-muted"></i>'
    end

    link_to raw("#{title} #{icon}"),
            users_path(sort_by: column, order: new_order),
            class: css_class,
            style: "text-decoration: none; color: inherit;"
  end
end
