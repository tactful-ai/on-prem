# Dstny engage On-Prem Quick Start Guide

This guide will help you quickly set up and run Your On-Prem Cluster. Follow the steps below to get started.

## Prerequisites

- **Jump Server**: You will need an Ubuntu 20.04 machine to serve as the jump server. This server will act as a central point for managing and configuring other machines in your environment.

- **Additional VMs**: You should have at least two additional Virtual Machines (VMs), each running Ubuntu 20.04. These VMs should have a minimum of 2 vCPUs and 4GB of RAM to ensure smooth operation of the Dstny engage On-Prem solution.


## Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/tactful-ai/on-prem.git
```

## Navigate to the Repository

Change your current directory to the cloned repository:

```bash
cd on-prem
```

### Switch to Root User (sudo -i)

To ensure proper permissions for the setup, become the root user using `sudo -i`:

```bash
sudo -i
```
make sure that you are root for all of the next steps.

### Copy SSH Key

Copy the SSH key for the specified machines to your `~/.ssh/key.pem`. Make sure to adjust the file path and permissions:

```bash
cp path/to/your/ssh_key.pem ~/.ssh/key.pem
chmod 400 ~/.ssh/key.pem
```

## Configure User Information

Edit the `user_fill.sh` file to add information about your machines. You can specify your machine details using one of the following formats:

- Password-based authentication:
  ```shell
  node_info[0]="ip_address|password|user|node_name"
  ```

- SSH key-based authentication:
  ```shell
  node_info[0]="ip_address|ssh_key_path|user|node_name"
  ```

Example:

```shell
node_info[0]="xxx.xx.xx.xx|password|remote_machine_username|node_name"
```



### Run the Setup Script

Now, you're ready to start the setup process. Run the following command:

```bash
bash dstny.sh
```

Watch the magic ✨✨✨.
