module ApplicationHelper

  def flash_class(flash_type)
    case flash_type
    when :error
      "alert-danger"
    when :info
      "alert-info"
    when :notice
      "alert-success"
    when :warning
      "alert-warning"
    else
      "alert-info"
    end
  end

end
