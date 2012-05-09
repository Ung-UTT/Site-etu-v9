# Doc: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md

FactoryGirl.define do
  factory :annal do
    semester 'P'
    year 2012
    kind 'F'
    course
    documents { [ create(:document) ] }
  end

  factory :asso, aliases: [:club] do
    sequence(:name) {|n| "Asso #{n}" }

    association :owner, factory: :user
  end

  factory :answer do
    content "Yes AND No"
  end

  factory :carpool do
    description "Wanna ride home?"
    departure "Troyes"
    arrival "Your home"
    date { 2.days.from_now }
    is_driver { [true, false].sample }
    user
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

  factory :document do
    asset { file_from_assets('document.pdf') }
  end

  factory :event do
    name "Big stuff!"
  end

  factory :news do
    sequence(:title) {|n| "News #{n}" }

    content "What a news!"
    is_moderated true
  end

  factory :quote do
    content "This is a good quote."
    tag "quote"
    author "Unknown"
  end

  factory :user do
    sequence(:login) {|n| "login#{n}" }

    email { "#{login}@utt.fr" }
    password { SecureRandom.base64 }

    factory :user_with_schedule do
      after_create do |user|
        user.timesheets << FactoryGirl.create(:timesheet)
      end
    end

    factory :student do
      after_create do |user|
        user.add_role :student
      end
    end

    factory :moderator do
      after_create do |user|
        user.add_role :moderator
      end
    end

    factory :administrator do
      after_create do |user|
        user.add_role :administrator
      end
    end
  end

  factory :poll do
    sequence(:name) {|n| "Poll #{n}" }

    factory :poll_with_answers do
      after_create do |poll|
        FactoryGirl.create_list(:answer, 3, poll: poll, :content=> "Answer #{n}")
      end
    end
  end

  factory :preference do
    locale     'fr'
    quote_type 'all'
  end

  factory :project do
    sequence(:name) {|n| "Project #{n}" }
    association :owner, factory: :user
  end

  factory :role do
    name "tester"
  end

  factory :timesheet do
    start_at { Time.now }
    duration { 120 }
    category 'CM'
    course
  end

  factory :vote do
  end

  factory :wiki do
    title "Wiki"
  end
end

