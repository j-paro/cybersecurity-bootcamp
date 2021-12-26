# Load-Balanced Web Servers and an ELK Stack Deployed by Ansible
The following diagram documents the Azure environment created for running and monitoring the Damn Vulnerable Web Application.

![](./Diagrams/Unit-13-NetworkDiagram.png)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

## Description of the Topology
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network by acting as a gateway to the webservers thus shielding the web servers from the Internet directly. Load balancers also protect against DDoS attacks.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the system logs and system performance.

The configuration details of each machine may be found below.

| Name               | Function                    | IP Address | Operating System |
|--------------------|-----------------------------|------------|------------------|
| JumpBoxProvisioner | Ansible Server and Gateway  | 10.0.0.4   | Ubuntu 20.04     |
| Web-1              | DVWA Web Server             | 10.0.0.5   | Ubuntu 20.04     |
| Web-2              | DVWA Web Server             | 10.0.0.6   | Ubuntu 20.04     |
| ELK-Server         | ELK Server                  | 10.0.1.4   | Ubuntu 20.04     |

## Access Policies
The web servers on the RedTeamNetwork are not exposed to the public Internet. They are accessed through the load balancer. 

Only the JumpBoxProvisioner machine on the RedTeamNetwork can accept connections (SSH) from the Internet. Access to this machine is only allowed from the following IP addresses:
- My residential IP address which I will not print here.

Machines within the RedTeamNetwork can only be accessed by the JumpBoxProvisioner (SSH).

A summary of the access policies in place can be found in the table below.

| Name               | Publicly Accessible         | Allowed IP Addresses                        |
|--------------------|-----------------------------|---------------------------------------------|
| JumpBoxProvisioner | Yes (SSH)                   | My Residential IP                           |
| Web-1              | No                          | 10.0.0.4 (JumpBoxProvisioner)               |
| Web-2              | No                          | 10.0.0.4 (JumpBoxProvisioner)               |
| ELK-Server         | Yes (Kibana over port 5601) | My Residential IP (5601) and 10.0.0.4 (SSH) |
| Load Balancer      | Yes (Port 80)               | My Residential IP                           |

## Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because of many reasons. It's main advantage is its representation of infrastructure as code (IAC). In case configuration needs to be performed again, we're guaranteed to get the same configuration and avoid manual keying errors. Also, the Ansible playbook acts as documentation of exactly what was configured for future reference.

The playbook implements the following tasks:
- Using Ansible's `apt` module, `docker.io` and `pip` (Python's package manager) are installed.
- Using Ansible's `pip` module, the `docker` Python SDK is installed.
- Virtual memory is increased so ELK can run properly. See the following: [Virtual Memory and ELK](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)
- Using Ansible's `docker_container` module, a docker ELK container is downloaded and launched.
- Using Ansible's `systemd` module, the docker service is set so it launches upon boot.

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![](./Ansible/Images/docker-ps.PNG)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.0.0.5
- Web-2: 10.0.0.6

We have installed the following Beats (installation instructions and configuration are not in this README) on these machines:
- Metricbeat
- Filebeat

These Beats allow us to collect the following information from each machine:
- Metricbeat will collect metrics and statistics from both a machine's operating system as well as the services running on the machine. One of the basic stats I would expect to see is the machine's CPU usage.
- Filebeat will monitor logs -- we set which logs to monitor -- and track changes to those logs. Given we're shipping log data off to an ELK server, I would expect to see log change events related to Kibana, Elasticsearch, Metricbeat, etc.

## Using Ansible
In order to use the playbook, you will need to have an Ansible control node already configured. All steps in the following sections assume you have such a control node provisioned and running.

### Web Servers
SSH into the control node and perform the following steps:
- Copy the [dvwa-for-webservers.yml](https://github.com/BizTheDad/cybersecurity-bootcamp/blob/main/AzureEnvironment/Ansible/Playbooks/dvwa-for-webservers.yml) file to `/etc/ansible`.
  - Do this with the following command `curl https://raw.githubusercontent.com/BizTheDad/cybersecurity-bootcamp/main/AzureEnvironment/Ansible/Playbooks/dvwa-for-webservers.yml > /etc/ansible/dvwa-for-webservers.yml`
- Update the `/etc/ansible/hosts` file to include the line `[webservers]' -- this creates a group called "webservers" -- and add the webservers' internal IP addresses on separate lines underneath it.
- Run the playbook using the command `ansible-playbook /etc/ansible/dvwa-for-webservers.yml`

### ELK Server
SSH into the control node and perform the following steps:
- Copy the [install-elk.yml](https://github.com/BizTheDad/cybersecurity-bootcamp/blob/main/AzureEnvironment/Ansible/Playbooks/install-elk.yml) file to `/etc/ansible`.
  - Do this with the following command: ` curl https://raw.githubusercontent.com/BizTheDad/cybersecurity-bootcamp/main/AzureEnvironment/Ansible/Playbooks/install-elk.yml > /etc/ansible/install-elk.yml`
- Update the `/etc/ansible/hosts` file to include the line `[elk]' -- this creates a group called "elk" -- and add the ELK server's internal IP address on a separate line underneath it.
- Run the playbook using the command `ansible-playbook /etc/ansible/install-elk.yml`
- Run the playbook, and navigate to http://52.165.177.244:5601/app/kibana to check that the installation worked as expected.
