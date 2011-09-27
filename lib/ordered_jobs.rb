require 'lstrip-on-steroids'

require 'rgl/adjacency'
require 'rgl/topsort'
require 'rgl/transitiv_closure'
require 'rgl/connected_components'

class JobStructure
  def initialize(job_description)
    @dependencies = extract_dependencies(job_description)
  end

  def sequence
    graph = RGL::DirectedAdjacencyGraph.new
    @dependencies.each do |to, from|
      graph.add_edge(from, to)
    end
    graph.topsort_iterator.to_a.reject { |job| job == "" }
  end

  private

  def extract_dependencies(job_description)
    job_description.split("\n").inject([ ]) { |dependencies, line|
      match = /(\w) => *(\w?)/.match(line)
      to, from = match[1..2]
      raise ArgumentError.new(%Q{Job "#{to}" can't depend on itself}) if to == from
      dependencies << [to, from]
    }
  end
end