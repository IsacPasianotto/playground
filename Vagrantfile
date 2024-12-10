servers = [
  { :hostname => "kube-00", :ip => "192.168.132.60" },
  { :hostname => "kube-01", :ip => "192.168.132.61" },
  { :hostname => "kube-02", :ip => "192.168.132.62" },
  # { :hostname => "kube-03", :ip => "192.168.132.63" },
  # ...
]

controlpscripts = [
  './scripts/bash_common_provisioning.sh',
  './scripts/install_k8s.sh',
  './scripts/other_conveniences.sh',
  './scripts/slurm_install.sh',
  './scripts/enable_MPI.sh',
]

scripts = [
  './scripts/bash_common_provisioning.sh',
  './scripts/install_k8s_worker.sh',
  './scripts/slurm_worker.sh',
  './scripts/enable_MPI.sh',
]

tocopy = [
  './scripts/deploy_flannel.sh',
  './scripts/deploy_calico.sh',
]

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/39-cloud-base"
  
  config.vm.provider :libvirt do |lv|
    lv.qemu_use_session = false
    lv.memory = 2048
    lv.cpus = 2
  end

  # Configure the worker nodes
  servers.each do |conf|
    config.vm.define conf[:hostname] do |node|
      node.vm.hostname = conf[:hostname]
      node.vm.network :private_network,
                      :libvirt__network_name => 'kube-net'

      # Provisioning based on node type
      if conf[:hostname] == "kube-00"
        controlpscripts.each do |script|
          node.vm.provision :shell,
                            :path => script,
                            :args => [conf[:ip]]
        end

        node.vm.provision :shell,
                          :inline => "kubectl wait --for=condition=ready node kube-00 --timeout=300s",
                          :privileged => false

        # Taint the control plane means that the control plane will also be used as a worker node
        # node.vm.provision :shell,
        #                   :inline => "kubectl taint nodes kube-00 node-role.kubernetes.io/control-plane-",
        #                   :privileged => true

        tocopy.each do |script|
          node.vm.provision :file,
                            :source => script,
                            :destination => "/home/vagrant/"
        end
      else  # worker nodes
        scripts.each do |script|
          node.vm.provision :shell,
                            :path => script,
                            :args => [conf[:ip]]
        end
      end
    end
  end
end
