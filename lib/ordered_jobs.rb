require 'lstrip-on-steroids'

require 'rgl/adjacency'
require 'rgl/topsort'
require 'rgl/transitiv_closure'
require 'rgl/connected_components'

class JobStructure
  def initialize(raw_job_description)
    @job_description = JobDescription.new(raw_job_description)
  end

  def sequence
    graph = RGL::DirectedAdjacencyGraph.new
    @job_description.each do |to, from|
      raise ArgumentError.new(%Q{Job "#{to}" can't depend on itself}) if to == from
      graph.add_edge(from, to)
    end
    raise ArgumentError.new("The job dependencies can't contain cycles") unless graph.acyclic?
    graph.topsort_iterator.to_a.reject { |job| job == "" }
  end
end

class JobDescription
  def initialize(raw_job_description)
    @raw_job_description = raw_job_description
  end

  def each(&block)
    dependencies.each(&block)
  end

  def dependencies
    @raw_job_description.split("\n").map { |line|
      match = /(\w) => *(\w?)/.match(line)
      match[1..2]
    }
  end
end
