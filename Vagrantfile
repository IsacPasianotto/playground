servers = [
  { :hostname => "kube-00", :ip => "192.168.132.60" },
  { :hostname => "kube-01", :ip => "192.168.132.61" },
  { :hostname => "kube-02", :ip => "192.168.132.62" },
  # { :hostname => "kube-03", :ip => "192.168.132.63" },
  # ...
]

controlpscripts = [
  './scripts/00-bash_common_provisioning.sh',
  './scripts/10-k8s_common_provisioning.sh',
  './scripts/11-k8s_control_plane.sh',
  './scripts/20-munge_master.sh',
  './scripts/30-slurm_common_provisioning.sh',
  './scripts/31-slurm_master.sh',
  './scripts/40-nfs_master.sh',
  './scripts/50-compile_osu.sh'
]

scripts = [
  './scripts/00-bash_common_provisioning.sh',
  './scripts/10-k8s_common_provisioning.sh',
  './scripts/12-k8s_worker_nodes.sh',
  './scripts/21-munge_workers.sh',
  './scripts/30-slurm_common_provisioning.sh',
  './scripts/32-slurm_worker.sh',
  './scripts/41-nfs_workers.sh',
]

tocopy = [
  './CNIs/deploy_flannel.sh',
  './CNIs/deploy_calico.sh',
  './CNIs/install_cilium_cli.sh',
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
                            :args => [conf[:ip]],
                            :privileged => true
        end

        node.vm.provision :shell,
                          :inline => "kubectl wait --for=condition=ready node kube-00 --timeout=300s",
                          :privileged => false

        # Taint the control plane means that the control plane will also be used as a worker node
        # node.vm.provision :shell,
        #                   :inline => "kubectl taint nodes kube-00 node-role.kubernetes.io/control-plane-",
        #                   :privileged => true

        # Install the last stable release of MPI-operator
        node.vm.provision :shell,
                          :inline => "kubectl apply --server-side -f https://raw.githubusercontent.com/kubeflow/mpi-operator/v0.6.0/deploy/v2beta1/mpi-operator.yaml",
                          :privileged => false

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
