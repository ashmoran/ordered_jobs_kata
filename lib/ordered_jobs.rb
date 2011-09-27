require 'lstrip-on-steroids'

require 'rgl/adjacency'
require 'rgl/topsort'
require 'rgl/transitiv_closure'
require 'rgl/connected_components'

class JobStructure
  def initialize(job_description)
    @jobs = extract_names(job_description)
  end

  def sequence
    @jobs
  end

  private

  def extract_names(job_description)
    graph = RGL::DirectedAdjacencyGraph.new

    job_description.split("\n").map { |line|
      match = /(\w) => *(\w?)/.match(line)
      to, from = match[1..2]
      graph.add_edge(from, to)
    }

    graph.topsort_iterator.to_a.reject { |job| job == "" }
  end
end