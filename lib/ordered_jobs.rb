require 'lstrip-on-steroids'

require 'rgl/adjacency'
require 'rgl/topsort'
require 'rgl/transitiv_closure'
require 'rgl/connected_components'

class JobStructure
  def initialize(raw_job_description)
    @raw_job_description = raw_job_description
  end

  def sequence
    graph = JobDependencyGraph.new
    JobDescription.new(@raw_job_description).add_dependencies_to(graph)
    graph.sorted_sequence
  end
end

class JobDescription
  def initialize(raw_job_description)
    @raw_job_description = raw_job_description
  end

  def add_dependencies_to(graph)
    dependencies.each do |to, from|
      graph.add_job_dependency(from, to)
    end
  end

  private

  def dependencies
    @raw_job_description.split("\n").map { |line|
      match = /(\w) => *(\w?)/.match(line)
      match[1..2]
    }
  end
end

class JobDependencyGraph
  def initialize
    @graph = RGL::DirectedAdjacencyGraph.new
  end

  def add_job_dependency(from, to)
    raise ArgumentError.new(%Q{Job "#{to}" can't depend on itself}) if to == from
    @graph.add_edge(from, to)
  end

  def sorted_sequence
    raise ArgumentError.new("The job dependencies can't contain cycles") unless @graph.acyclic?
    @graph.topsort_iterator.to_a.reject { |job| job == "" }
  end
end