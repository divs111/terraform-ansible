Terraform + Ansible Automation
This project demonstrates the use of Terraform for infrastructure provisioning and Ansible for configuration management. It automates the setup of servers (e.g., EC2 instances), configures SSH access, and installs Docker using Ansible playbooks.

🧱 Project Structure

terraform-ansible/
├── inventories/
│   ├── dev
│   └── prd
├── playbooks/
│   └── install_docker.yml
└── README.md
⚙️ Prerequisites
Ubuntu 20.04+ system

SSH access to target servers

Terraform installed (optional, not in history)

Ansible installed

Install Ansible:

sudo apt update
sudo apt-add-repository ppa:ansible/ansible
sudo apt install ansible
ansible --version
🔐 SSH Key Setup
Ensure your SSH private key (terra-ansible-key.pem) is created and securely stored:


mkdir ~/keys
vim ~/keys/terra-ansible-key.pem
chmod 400 ~/keys/terra-ansible-key.pem
🧾 Inventory Configuration
Two inventories are maintained: dev and prd.

Example dev Inventory:


[server1]
13.221.105.191 ansible_user=ec2-user ansible_ssh_private_key_file=~/keys/terra-ansible-key.pem

[server2]
54.147.134.181 ansible_user=ubuntu ansible_ssh_private_key_file=~/keys/terra-ansible-key.pem
Place them under:


terraform-ansible/inventories/dev
terraform-ansible/inventories/prd
📦 Ansible Playbook
install_docker.yml
This playbook installs Docker on the target instances.


---
- name: Install Docker on target servers
  hosts: all
  become: yes
  tasks:
    - name: Update apt packages
      apt:
        update_cache: yes

    - name: Install dependencies
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
        state: present

    - name: Add Docker GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker repository
      apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Install Docker
      apt:
        name: docker-ce
        state: latest

    - name: Ensure Docker is running
      service:
        name: docker
        state: started
        enabled: yes
🚀 Running the Playbook
Ping All Servers

ansible -i inventories/dev all -m ping
ansible -i inventories/prd all -m ping
Install Docker

ansible-playbook -i inventories/dev install_docker.yml
ansible-playbook -i inventories/prd install_docker.yml
🔧 Useful Ansible Commands
Check Docker status:


ansible -i inventories/dev server1 -a "sudo docker ps"
ansible -i inventories/dev server2 -a "docker --version"
Gather OS info:


ansible div_servers -m setup -a 'filter=ansible_distribution*'
📁 Git Workflow

git clone https://github.com/divs111/terraform-ansible.git
mv playbooks/ terraform-ansible/
mv inventories/ terraform-ansible/
cd terraform-ansible
git add .
git commit -m "Added ansible playbooks and inventories"
git push origin main
