# Doc: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md

FactoryGirl.define do
  sequence(:asso_name) {|n| "Asso #{n}"}
  sequence(:poll_name) {|n| "Poll #{n}"}
  sequence(:news_title) {|n| "News #{n}"}
  sequence(:login) {|n| "login#{n}"}


  factory :annal do
    name "Final : What's your name?"
    description "Basic questions"
    date "2011-02-08"
  end

  factory :asso, aliases: [:club] do
    name { FactoryGirl.generate(:asso_name) }
    association :owner, factory: :user
  end

  factory :answer do
  end

  factory :classified do
    title "Poudre magique"
    description "Elle vous rendra magique"
    price 135
    location "Au RU"
  end

  factory :comment do
    content "This is a silly comment."
  end

  factory :course do
    name "LE00"
    description "What's your name ? My name is Bond, James Bond."
  end

  factory :news do
    title { FactoryGirl.generate(:news_title) }
    content "What a news!"
    is_moderated true
  end

  factory :user do
    login { FactoryGirl.generate(:login) }
    email { "#{login}@utt.fr" }
    password { SecureRandom.base64 }
  end

  factory :poll do
    name { FactoryGirl.generate(:poll_name) }

    factory :poll_with_answers do
      after_create do |poll|
        FactoryGirl.create_list(:answer, 3, poll: poll, content: "Answer #{n}")
      end
    end
  end

  factory :preference do
    locale     'fr'
    quote_type 'all'
  end

  factory :timesheet do
    start_at { Time.now }
    end_at { Time.now + 2.hours }
    category 'CM'
  end

  factory :vote do
  end
end

