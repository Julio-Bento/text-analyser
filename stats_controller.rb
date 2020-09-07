require_relative 'stats_worker'
require_relative 'stats'

class StatsController
  # Get html and local strings and return a Stat Object
  def get_stats(html, locale)
    locale = locale.substring(0, 2)

    # TODO: Test if local exists

    worker = StatsWorker.new(html, locale)


    p @stats = worker.compute_stats
  end
end

stats_controller = StatsController.new

html = File.readlines("./text.html").join

stats_controller.get_stats(html, "fr")

