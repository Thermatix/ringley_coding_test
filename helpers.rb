require 'yaml'


def load_yml(file)
  YAML.load(File.open(File.join(File.dirname(__FILE__), file)))
end
