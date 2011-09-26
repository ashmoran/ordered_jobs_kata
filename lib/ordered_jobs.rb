require 'lstrip-on-steroids'

class JobStructure
  def initialize(job_description)
    @jobs = extract_names(job_description)
  end

  def sequence
    @jobs
  end

  private

  def extract_names(job_description)
    job_description.split("\n").map { |line|
      match = /(\w) => /.match(line)
      match[1] if match
    }
  end
end