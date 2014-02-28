require_relative '_lib/s3cmd/S3Bucket'

## Build Settings
lock_file = ".ws.lock"
deploy_target = "_site"
deploy_exclude = %w(Rakefile README.md config.rb bower.json Gemfile Gemfile.lock)
deploy_include = {"_bower_components/jquery/dist/jquery.min.js" => "/js/vendor",
                  "_bower_components/foundation/js/foundation.min.js" => "/js/vendor"}

staging_bucket = S3Bucket.new(bucket_name: "soc-sitetest", region: "eu-west-1")                  

task :build do
  Dir.mkdir(deploy_target) unless File.exists?(deploy_target)
  
  sh "compass compile"

  file_list = Dir.glob('*')
  file_list.reject! {|file| file.start_with?('_') or deploy_exclude.include?(file)}
  FileUtils.cp_r(file_list, deploy_target, :remove_destination => true)
  deploy_include.each {|k,v| FileUtils.cp_r(k,"#{deploy_target}/#{v}")}
end  

task :deploy => [:build] do
    puts("Deploying to STAGING")
    staging_bucket.sync(deploy_target)
end

task :clean_deploy do
    puts("Cleaning up STAGING")
    staging_bucket.sync(deploy_target,true)  
end

task :view do
  puts("Opening staging location...")
  sh "open #{staging_bucket.static_hosting_url}"
end

task :ws_start do
  unless File.exists? lock_file
    puts "Starting webserver..."
    
    pid = fork do
      exec "ruby -run -e httpd #{deploy_target} -p 5000"
    end
    
    File.new(lock_file,"w").puts(pid)
  
  else
    pid = File.open(lock_file).readline.to_i 

    processes = `ps -ax`
    proc = processes.match(/^ #{pid}.*$/)
    
    unless proc.nil?
      puts "Webserver seems to be already running (PID:#{pid})"
    else
      puts "No process with id #{pid} found. Stale lock file?"
    end
  end
end

task :ws_stop do
  if File.exists? lock_file
    pid = File.open(lock_file).readline.to_i 
    Process.kill "TERM", pid
    File.delete(lock_file)
  else
    puts "Webserver seems not to be running (lock file does not exists)"
  end
end

