After starting VM in VB, make a snapshot.
Run install1.sh as root(this will add user to sudo and restart sys)
Run install2.sh (this will install Vagrant, VB, net-tools, git, codium and Openssh)
After installing check all the programs. 
Shutdown VM. In the VB settings add nested virtualization and NAT network with port-forwarding for SSH connection: 
for HOST: -p 2222 on localhost(usual host ip 127.0.0.1), for GUEST: -p 22 and 10.0.2.15 (usual VM address or omit it)

Useful commands on terminal:
Openssh: ssh -p 2222 user@127....

scp -P 2222 user@127....
(for popts use ifconfig )
