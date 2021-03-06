class Hunt < ActiveRecord::Base
  belongs_to :user
  has_many   :teams

  def locations
    Location.find(master_path)
  end

  def make_teams(number_of_teams)
    number_of_teams.times do |i|
      teams.create(
        team_number: i + 1,
        path: generate_team_path
      )
    end
  end

  def activate(number_of_teams)
    make_teams(number_of_teams)
  end

  def active?
    !teams.empty?
  end

  def deactivate
    teams.destroy_all
  end

  def self.active
    find Team.pluck('DISTINCT hunt_id')
  end

  private

  def generate_team_path
    reversed_path = rand(2) == 1 ? master_path.reverse : master_path
    rand(20).times { reversed_path.rotate! }
    reversed_path
  end
end
