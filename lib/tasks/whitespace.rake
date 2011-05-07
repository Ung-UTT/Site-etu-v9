namespace :whitespace do
  desc 'Removes trailing whitespace'
  task :cleanup do
    sh %{for f in `find . -type f | grep -v -e '.git/' -e 'public/' -e '.png' -e '.sqlite3'`;
          do cat $f | sed 's/[ \t]*$//' > tmpfile; cp tmpfile $f; rm tmpfile; echo -n .;
        done}
  end
  desc 'Converts hard-tabs into two-space soft-tabs'
  task :retab do
    sh %{for f in `find . -type f | grep -v -e '.git/' -e 'public/' -e '.png' -e '.sqlite3'`;
          do cat $f | sed 's/\t/  /g' > tmpfile; cp tmpfile $f; rm tmpfile; echo -n .;
        done}
  end
  desc 'Remove consecutive blank lines'
  task :scrub_gratuitous_newlines do
    sh %{for f in `find . -type f | grep -v -e '.git/' -e 'public/' -e '.png' -e '.sqlite3'`;
          do cat $f | sed '/./,/^$/!d' > tmpfile; cp tmpfile $f; rm tmpfile; echo -n .;
        done}
  end
  desc 'Execute all tasks'
  task :all do
    Rake::Task['whitespace:cleanup'].execute
    Rake::Task['whitespace:retab'].execute
    Rake::Task['whitespace:scrub_gratuitous_newlines'].execute
  end
end
