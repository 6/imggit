worker_processes 2
timeout 20
preload_app true

before_fork do |server, worker|
end

after_fork do |server, worker|
end
