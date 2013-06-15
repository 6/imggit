module ApplicationHelper
  def body_classes
    [
      controller_name,
      "#{controller_name}-#{action_name}".gsub("_", "-")
    ].join(" ")
  end
end
