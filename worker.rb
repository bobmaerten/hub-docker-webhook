require 'sidekiq'
require 'net/http'
require 'open3'

class UpdateContainerWorker
  include Sidekiq::Worker
  def perform(json)
    logger.debug "#{json.inspect}"
    status = docker_pull  json['repository']['repo_name']
    status = docker_restart json['repository']['namespace'], json['repository']['name'] if status
    send_callback json['callback_url'] if status
  end

private

  def docker_pull(name)
    run_command "docker pull #{name}"
  end

  def docker_restart(namespace, name)
    run_command "docker rm -f #{name}"
    run_command "docker run --name #{name} -e VIRTUAL_HOST=#{name} -d #{namespace}/#{name}:latest"
  end

  def run_command (command)
    logger.info "Running: #{command}"
    stdout, stderr, status = Open3.capture3(command)
    if status.success?
      logger.info stdout
      return true
    else
      logger.error stderr
      return false
    end
  end

  def send_callback(uri, status = 'success')
    `echo #{uri} > success.txt`
    # uri = URI.parse(uri)

    # Net::HTTP.new(uri.host, uri.port).start do |client|
    #   request                 = Net::HTTP::Post.new(uri.path)
    #   request.body            = { status: status }.to_json
    #   request['Content-Type'] = 'application/json'
    #   client.request(request)
    # end
  end
end
