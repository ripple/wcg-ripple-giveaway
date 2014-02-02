module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    link_to title, {:sort_col => column, :sort_dir => direction}
  end
end
