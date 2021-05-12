class PitchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'wefunder'

  def perform(task, params)
    puts "Perform task: #{task} #{params}"
    case task
    when 'generate_image'
        Pitch.generate_image params
    else
        puts "Unknown task #{task}"
    end
  end
end