require 'faraday'
require 'uri'

class LearnCreate
  def initialize
    puts 'Note: You must have write access to the learn-co-curriculum org on GitHub to use this tool'

    # Checks to see if chosen name already exists as a repository
    @repo_name = ''

    loop do
      puts 'What is the name of the repository you would like to create?'
      @repo_name = gets.strip.gsub(/\s+/, '-').downcase
      url = 'https://api.github.com/repos/learn-co-curriculum/' + @repo_name
      encoded_url = URI.encode(url).slice(0, url.length)

      # Will hit rate limint on github is used too much
      check_existing = Faraday.get URI.parse(encoded_url)

      break if check_existing.body.include? '"Not Found"'

      puts 'A repository with that name already exists:'
      puts 'https://github.com/learn-co-curriculum/' + @repo_name
      puts ''
    end

    readme = ''
    loop do
      puts 'Is this a Readme? (y/n)'
      readme = gets.chomp.downcase
      break if readme =~ /^(y|n)/ || readme == ''
      puts 'Please enter yes or no'
      puts ''
    end

    # If not a readme, create language specific lab, otherwise create a standard readme
    if readme =~ /^n$/

      language = choose_language

      case language
      when /^ru/
        create_local_lesson('lab', 'Ruby')
      when /^j/
        create_local_lesson('lab', 'JavaScript')
      when /^re/
        create_local_lesson('lab', 'React')
      else
        create_local_lesson('readme')
      end

    else

      create_local_lesson('readme')

    end

    create_new_repo
    puts ''
    puts "Repository created. Navigate into #{@repo_name} or open https://github.com/learn-co-curriculum/#{@repo_name} to get started"
  end

  private

  def choose_language
    language = ''
    loop do
      puts 'What lab template would you like to use? (Ruby/JavaScript/React)'
      language = gets.chomp.downcase
      break if language =~ /^(ru|j|re)/
      puts 'Please enter Ruby, JavaScript or React, or at minimum, the first two letters:'
      puts ''
    end
    language
  end

  def create_local_lesson(type = 'readme', language = nil)
    if !language
      puts "Creating #{type}..."
      template_folder = "/templates/#{type}_template"
    else
      puts "Creating #{language} #{type}..."
      template_folder = "/templates/#{language}_#{type}_template"
    end

    gem_template_location = File.dirname(__FILE__)
    template_path = File.expand_path(gem_template_location) + template_folder

    copy_template(template_path)
    create_dot_learn_file(type, language)
    create_dot_gitignore_file()
  end

  def copy_template(template_path)
    # copies a template folder from the learn_create gem to a subfolder of the current directory
    cmd = "cp -r #{template_path} #{Dir.pwd}/#{@repo_name}"
    `#{cmd}`
  end

  def create_dot_learn_file(type = 'undefined', language)
    `
cd #{@repo_name}
cat > .learn <<EOL
tags:
- #{type}
languages:
- #{language || 'undefined'}
    `
  end

  def create_dot_gitignore_file
    `
cd #{@repo_name}
cat > .gitignore <<EOL
.DS_Store
logs
*.log
npm-debug.log*
pids
*.pid
*.seed
lib-cov
build/Release
node_modules
jspm_packages
.npm
.node_repl_history
.results.json
/.bundle
/db/*.sqlite3
/db/*.sqlite3-journal
/log/*
!/log/.keep
/tmp
    `
  end

  def cd_into_and(command)
    "cd #{@repo_name} && #{command}"
  end

  def git_init
    cmd = cd_into_and('git init')
    `#{cmd}`
  end

  def git_add
    cmd = cd_into_and('git add .')
    `#{cmd}`
  end

  def git_commit
    cmd = cd_into_and('git commit -m "automated initial commit"')
    `#{cmd}`
  end

  def git_create
    cmd = cd_into_and("hub create learn-co-curriculum/#{@repo_name}")
    `#{cmd}`
  end

  def git_set_remote
    cmd = cd_into_and("git remote set-url origin https://github.com/learn-co-curriculum/#{@repo_name}")
    `#{cmd}`
  end

  def git_push
    cmd = cd_into_and('git push -u origin master')
    `#{cmd}`
  end

  def create_new_repo
    # 'cd' doesn't work the way it would in the shell, must be used before every command
    puts ''
    puts 'Initializing git repository'
    git_init
    puts ''
    puts 'Staging content for commit'
    git_add
    puts ''
    puts 'Creating initial commit'
    git_commit
    puts ''
    puts 'Creating remote learn-co-curriculum repository'
    git_create
    puts ''
    puts 'Setting git remote'
    git_set_remote
    puts ''
    puts 'Pushing to remote'
    git_push
  end
end
