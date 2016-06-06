# determine docker executable
Facter.add(:docker_executable) do
  setcode do
    Facter::Core::Execution.exec('which docker')
  end
end

# determine rancher agent instance id
Facter.add(:rancher_agent_instance_id) do
  confine :docker_executable => !nil
  setcode do
    Facter::Core::Execution.exec('docker ps --filter="label=io.rancher.container.system=NetworkAgent" -q')
  end
end


# query rancher-metadata service on the rancher agent docker instance
# docker exec -it $(docker ps --filter="label=io.rancher.container.system=NetworkAgent" -q) curl  --header 'Accept: application/json' http://localhost/latest/self/host/labels
Facter.add(:rancher_agent_labels) do
  confine :docker_executable => !nil
  confine :rancher_agent_instance_id => !nil
  dockerExec = Facter.value(:docker_executable)
  rancherInstanceId = Facter.value(:rancher_agent_instance_id)
  setcode do
    Facter::Core::Execution.exec( dockerExec, 'exec -it',  rancherInstanceId , 'curl  --header \'Accept: application/json\' http://localhost/latest/self/host/labels')
  end
end

