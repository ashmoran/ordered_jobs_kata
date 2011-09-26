class JobStructure
  def initialize(job_description)
    @job = extract_name(job_description)
  end

  def sequence
    [ @job ].compact
  end

  private

  def extract_name(job_description)
    match = /(\w) => /.match(job_description)
    match[1] if match
  end
end