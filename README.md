# Project Task: Deployment of Vagrant Ubuntu Cluster with LAMP Stack

## Objective:

Develop a bash script to orchestrate the automated deployment
of two Vagrant-based Ubuntu systems, designated as `Master` and `Slave`, with an integrated LAMP stack on both systems.

## Infrastructure Configuration

### Deploy Two Ubuntu Systems

The `Master` node should be capable of acting as a control system, while the `Slave` node is managed by the `Master` node.

### User Management

On the Master node, create a user named `altschool`. Grant `altschool` user root (superuser) privileges.

## Inter-node Communication

### Enable SSH key-based authentication:

The `Master` node (and `altschool` user) should seamlessly SSH into the `Slave` node without requiring a password.

### Data Management and Transfer

On initiation, copy the contents of `/mnt/altschool` directory from the `Master` node to `/mnt/altschool/slave` on the `Slave` node. This operation should be performed using the `altschool` user from the `Master` node.

### Process Monitoring

The `Master` node should display an overview of the Linux process management, showcasing currently running processes.

## LAMP Stack Deployment:

1. Install a AMP (Apache, MySQL, PHP) stack on both nodes:
2. Ensure Apache is running and set to start on boot.
3. Secure the MySQL installation and initialize it with a default user and password.
4. Validate PHP functionality with Apache.

## Deliverables

1. A bash script encapsulating the entire deployment process adhering to the specifications mentioned above. Documentation accompanying the script, elucidating the steps and procedures for execution.
2. A test PHP page validating the LAMP setup on both nodes.
3. A Load balancer using nginx to allow for traffic to the LAMP using the master and the slave nodes.
