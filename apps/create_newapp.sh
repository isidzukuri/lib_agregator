#!/bin/sh

capitalized_name=`echo $1 | tr [A-Z] [a-z] | sed -e 's/^./\U&/g; s/ ./\U&/g'`

echo "New apps/$1"

echo "Make newapp duplicate"
cp -a newapp "$1"

echo "Renaming core directories & files"
mv "$1/app/assets/images/newapp" "$1/app/assets/images/$1"
mv "$1/app/assets/javascripts/newapp" "$1/app/assets/javascripts/$1"
mv "$1/app/assets/stylesheets/newapp" "$1/app/assets/stylesheets/$1"
mv "$1/app/controllers/newapp" "$1/app/controllers/$1"
mv "$1/app/models/newapp" "$1/app/models/$1"

# mv "$1/config/locales/en.newapp.yml" "$1/config/locales/en.$1.yml"
mv "$1/lib/newapp" "$1/lib/$1"
mv "$1/lib/tasks/newapp_tasks.rake" "$1/lib/tasks/$1_tasks.rake"

mv "$1/lib/newapp.rb" "$1/lib/$1.rb"

mv "$1/newapp.gemspec" "$1/$1.gemspec"


cd "$1"

echo "Find and replacing Newapp with ${capitalized_name}"
grep -rl "Newapp" . | xargs sed -i "s/Newapp/$capitalized_name/g"

echo "Find and replacing newapp with $1"
grep -rl "newapp" . | xargs sed -i "s/newapp/$1/g"

# echo "$1 -> Bundle"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Configure $1.gemspec manually and run bundle"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
# bundle

# echo "$1/spec/dummy -> Setup"
# cd "spec/dummy"
# rake db:setup RAILS_ENV=test
