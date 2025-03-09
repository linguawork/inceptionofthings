/*
Use vagrant file which is not in folders. The folders contain versions for research
Explanation of the Vagrantfile:

    Machine Names: The first machine is named areggieS (Server) and the second one areggieSW (ServerWorker), as requested.

    Network Configuration:
        The areggieS machine is assigned IP 192.168.56.110.
        The areggieSW machine is assigned IP 192.168.56.111.
        Both machines use a private network on the eth1 interface.

    Minimal Resources:
        Both machines are configured with 1 CPU and 1024 MB of RAM, which is the recommended minimum for your use case.

    K3s Installation:
        areggieS (Server): Installs K3s in controller mode.
        areggieSW (ServerWorker): Installs K3s in agent mode, connecting to the server using the K3s URL and token fetched from areggieS.

    kubectl Installation:
        Both machines will have kubectl installed, which is necessary to manage the Kubernetes cluster. The script downloads and installs the appropriate version of kubectl.

    Passwordless SSH: Vagrant automatically sets up passwordless SSH for you. As long as you’re using Vagrant’s default SSH key, this will work out of the box.

How to Use:

    Save this Vagrantfile in your project directory.
    Run the following command in the same directory:

    vagrant up

    This will start the two virtual machines, provision them with K3s and kubectl, and configure the network.

Let me know if you need further modifications or have any questions!



*/