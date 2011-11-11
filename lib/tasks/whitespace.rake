namespace :whitespace do
  desc 'Removes trailing whitespace'
  task :cleanup do
    sh %{find -type f -not \
         \\( -path './.git/*' -or -path './app/assets/*' -or -path './test/images/*' -or -name '*.sqlite3' \\) \
         -exec sed -i 's/[ \t]*$//' \{\} \\; -exec echo -n . \\;}
  end
  desc 'Converts hard-tabs into two-space soft-tabs'
  task :retab do
    sh %{find -type f -not \
         \\( -path './.git/*' -or -path './app/assets/*' -or -path './test/images/*' -or -name '*.sqlite3' \\) \
         -exec sed -i 's/\t/  /g' \{\} \\; -exec echo -n . \\;}
  end
  desc 'Remove consecutive blank lines'
  task :scrub_gratuitous_newlines do
    sh %{find -type f -not \
         \\( -path './.git/*' -or -path './app/assets/*' -or -path './test/images/*' -or -name '*.sqlite3' \\) \
         -exec sed -i '/./,/^$/!d' \{\} \\; -exec echo -n . \\;}
  end
  desc 'Execute all tasks'
  task :all do
    Rake::Task['whitespace:cleanup'].execute
    Rake::Task['whitespace:retab'].execute
    Rake::Task['whitespace:scrub_gratuitous_newlines'].execute
  end
end
