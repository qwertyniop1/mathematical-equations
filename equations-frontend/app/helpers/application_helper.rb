module ApplicationHelper
  def full_title(page_title)
    base_title = 'Equations Solver'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def active_link(path)
    current_page?(path) ? 'active' : ''
  end

  def trim_float(number)
    integer, float = number.to_i, number.to_f
    integer == float ? integer : float
  end
end
