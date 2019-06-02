namespace :data do

  desc 'Create multiple posts using all users from database'
  task create_posts: :environment do

    require 'faker'

    tags = ['ocean', 'nature', 'earth', 'life', 'water', 'mind', 'stones', 'cars', 'bikes', 'food', 'sea', 'rivers', 'rain', 'wheather']
    users = User.all

    1000.times do |index|

      Post.new do |p|

        p.title = Faker::Book.title + " - #{index}"

        p.body = Faker::Quote.matz

        p.tags_manual = tags.sample(rand(1..4)).join(',')

        p.user = users[rand(0..users.size-1)]

        if p.save
          # add some answers, but not to all of them

          if rand(0..50) < 40

            # add answers

            rand(2..10).times do |index_replay|

              replay = Post.new do |r|
                r.title = "#{p.title}-#{index_replay}"

                r.body = Faker::Quote.matz

                r.tags_manual = nil

                r.user = users[rand(0..users.size-1)]

                r.question_id = p.id

                r.save

              end

            end


          end

        end


      end

    end


  end

end
