# app.py
from flask import Flask, render_template, request, Response, send_file
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        num_nodes = int(request.form['numNodes'])
        connection_way = int(request.form['connectionWay'])

        # Process form data, generate the script, and save it as 'user_fill.sh'
        # Replace this with your script generation logic

        # Redirect to the 'run.html' page after generating the script
        return render_template('run.html')

    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate_script():
    num_nodes = int(request.form['numNodes'])
    connection_way = int(request.form['connectionWay'])
    sudo_password = request.form['sudoPassword']  # Get sudo password from the form
    new_password = request.form['newPassowrd']  # Get sudo password from the form
    storage_system = request.form['storageSystem']
    load_balancer = request.form['loadBalancer']
    monitoring_system = request.form['monitoringSystem']
    install_redis = request.form['installRedis']
    rke_version = request.form['rkeVersion']
    docker_version = request.form['dockerVersion']
    cert_manager = request.form['certManager']
    install_rancher = request.form['installRancher']
    install_adminer = request.form['installAdminer']
    install_kubedash = request.form['installKubeDash']

    # Create a list to store the node_info lines
    node_info_lines = []

    for i in range(1, num_nodes + 1):
        ip_address = request.form[f'ip{i}']
        user = request.form[f'user{i}']
        node_name = request.form[f'nodeName{i}']

        if connection_way == 0:  # Password
            password = request.form[f'password{i}']
            node_info_lines.append(f"{ip_address}|password|{user}|{node_name}")
        elif connection_way == 1:  # SSH Key
            ssh_key_path = request.form[f'sshKeyPath{i}']
            node_info_lines.append(f"{ip_address}|{ssh_key_path}|{user}|{node_name}")

    # Generate the bash script content using triple-quotes
    script_content = f'''#!/bin/bash
# Node information array
declare -a node_info
''' + ''.join([f"node_info[{i}]=\"{line}\"\n" for i, line in enumerate(node_info_lines)]) + f'''

# sudo password from main machine
sudo_password="{sudo_password}"

# if the machines require changing the password, the new password will be
NEW_MACHINES_PASSWORD="{new_password}"

# connection way to the remote nodes
# it can be PASSWORD=0 or SSH_KEY=1
CONNECTION_WAY={connection_way}

# Number of nodes
num_nodes={num_nodes}

# chose whicih rke version you want to install
# we have rke1, rke2
# rke1 is the old version of rke that use docker as container runtime
# rke2 is the new version of rke that use containerd as container runtime
RKE_VERSION="{rke_version}"

# select the docker version that compatible with you os and the k8s
# to know the used k8s version you can run
docker_version="{docker_version}"


################################# Services Section #################################

# chose certification manager you want
# we have cert-manager, None
# if you dont want to install one of them write NONE
CERT_MANAGER="{cert_manager}"

# chose storage system you want to install
# we have longhorn, none
# if you don't want to install one of them, write NONE
STORAGE_SYSTEM="{storage_system}"

# chose load balancer system you want to install
# we have metallb, none
# if you don't want to install one of them, write NONE
LOAD_BALANCER="{load_balancer}"

# chose monitoring system you want to install
# we have prometheus, none
# if you don't want to install one of them, write NONE
MONITORING_SYSTEM="{monitoring_system}"

# do you want to install Rancher DashBoard
# if you dont want to install write yes
INSTALL_RANCHER_DASHBOARD="{install_rancher}"

# do you want to install redis
INSTALL_REDIS="{install_redis}"

# do you want to install Adminer
# if you dont want to install write yes
INSTALL_ADMINER="{install_adminer}"

# do you want install k8s-dashboard
INSTALL_DASHBOARD="{install_kubedash}"

'''

    # Save the generated script to 'user_fill.sh'
    with open('./user_fill.sh', 'w') as script_file:
        script_file.write(script_content)

    # Redirect to the 'run.html' page
    return render_template('run.html')

@app.route('/run', methods=['GET'])
def run_script():
    def generate_output():
        try:
            # Execute the Bash script using subprocess and capture its output
            process = subprocess.Popen(['bash', './dstny.sh'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1, universal_newlines=True)
            
            # Stream the output to the web page in real-time
            for line in process.stdout:
                yield line
            for line in process.stderr:
                yield line

            # Wait for the script to finish and capture its return code
            return_code = process.wait()

            if return_code == 0:
                yield "Script execution completed successfully."
            else:
                yield f"Script execution failed with return code {return_code}."
        
        except Exception as e:
            yield f"An error occurred: {str(e)}"

    return Response(generate_output(), content_type='text/plain')

if __name__ == '__main__':
    app.run(debug=True)