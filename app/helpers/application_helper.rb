# frozen_string_literal: true

module ApplicationHelper
  def row_background_color(item)
    if item.archived
      "group-row-acvhived"
    elsif item.remark
      "group-row-remark"
    else
      ""
    end
  end
end
