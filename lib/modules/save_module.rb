module SaveModule
  def save_result (str, path)
    create_file(path) unless File.exist?(path)
    file = File.open(path, 'a+')
    file.puts str
    file.puts '-'*31
  end

  def create_file (path)
    str = 'NAME'.center(10) + ' | ' + 'HINTS'.center(5) + ' | ' + 'ATTEMPTS'.center(8) + ' |'
    file = File.open(path, 'w')
    file.puts str
    file.puts '-'*31
  end
end