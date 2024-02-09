import subprocess
import argparse
import os
import paramiko

def scp_transfer(src, dest):
    scp_cmd = f"scp {src} {dest}"
    subprocess.run(scp_cmd, shell=True, check=True)

def ssh_run_code(remote_host, command):
    ssh_cmd = f"ssh {remote_host} {command}"
    subprocess.run(ssh_cmd, shell=True, check=True)

# main
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process a design file.")
    parser.add_argument("f", default="design.v", help="The design file to evaluate.")
    parser.add_argument("t", default="Top", help="Top module name.")
    args = parser.parse_args()

    designFile = args.f
    topModule = args.t
    
    # transfer the design file to the remote server
    src_path = "./"+designFile
    dest_path = "bonany@162.105.183.6:/path/to/destination/directory"
    scp_transfer(src_path, dest_path)
    with open('topModule.txt','w') as f:
        f.write(f'set MAIN_MODULE "{designFile}"')
    scp_transfer("./topModule.txt", dest_path)
    os.remove("topModule.txt")
    
    # run design synthesis
    remote_host = "bonany@162.105.183.6"
    ssh_run_code(remote_host, "cat topModule.txt run_generic.sh > run.sh")
    ssh_run_code(remote_host, "dc_shell-xg-t -f run.sh")
    
    # fetch remote design PPA reports: a)timing (performance), b) power, c) area
    src_path = "bonany@162.105.183.6:/path/to/destination/directory/"+designFile+"g"
    dest_path = "./"
    scp_transfer(src_path, dest_path)
    
    

