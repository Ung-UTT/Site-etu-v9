namespace :whitespace do
  desc 'Removes trailing whitespace'
  task :cleanup do
    sh %{for f in `find . | grep -v '/doc/' | egrep '(.rb|.erb|.html|.yml|.css|.js|.rake)$'`;
      do sed -i 's/[ \t]*$//' $f; echo -n .;
    done}
  end

  desc 'Converts hard-tabs into two-space soft-tabs'
  task :retab do
    sh %{for f in `find . | grep -v '/doc/' | egrep '(.rb|.erb|.html|.yml|.css|.js|.rake)$'`;
      do sed -i 's/\t/  /g' $f; echo -n .;
    done}
  end

  desc 'Remove consecutive blank lines'
  task :scrub_gratuitous_newlines do
    sh %{for f in `find . | grep -v '/doc/' | egrep '(.rb|.erb|.html|.yml|.css|.js|.rake)$'`;
      do sed -i '/./,/^$/!d' $f; echo -n .;
    done}
  end

  desc 'Execute all tasks'
  task :all do
    Rake::Task['whitespace:cleanup'].execute
    Rake::Task['whitespace:retab'].execute
    Rake::Task['whitespace:scrub_gratuitous_newlines'].execute
  end
end
