class User < ActiveRecord::Base
  has_secure_password
  has_many :created_decks, class_name: "Deck", foreign_key: :creator_id
  has_many :rounds, foreign_key: :player_id
  has_many :played_decks, through: :rounds, source: :deck
  has_many :guesses, through: :rounds
  validates :username, :email, presence: true, uniqueness: true

  def rounds_played
    self.rounds.select{|round| round.complete?}.length
  end

  def percent_correct_on_first_try
    "#{(self.rounds.reduce(0){|sum, round| sum + round.correct_on_first_try.count} / self.rounds.reduce(0){|sum, round| sum + round.cards.length}.to_f * 100).round}%"
  end
end
