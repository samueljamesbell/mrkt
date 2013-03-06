class String
  # Taken from Merb support library - http://rubygems.org/gems/extlib
  def snake_case
    return downcase if self.match(/\A[A-Z]+\z/)
    self.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end
end
