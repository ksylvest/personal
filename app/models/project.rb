class Project
  attr_reader :name
  attr_reader :icon
  attr_reader :description
  attr_reader :url

  def self.all
    @all ||= YAML.load_file(Rails.root.join("config/projects.yml")).map do |config|
      Project.new(config["name"], config["icon"], config["description"], config["url"])
    end
  end

  def initialize(name, icon, description, url)
    @name = name
    @icon = icon
    @description = description
    @url = url
  end
end
