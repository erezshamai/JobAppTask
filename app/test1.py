import paramiko

def update_remote_config(hostname, username, private_key_path, config_path, new_value):
    """
    Connects to a remote server via SSH and updates a configuration file.
    """
    try:
        key = paramiko.RSAKey.from_private_key_file(private_key_path)
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname, username=username, pkey=key)

        # Example: Replace a line in a config file
        command = f"sed -i 's/^MY_SETTING=.*/MY_SETTING={new_value}/' {config_path}"
        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read().decode().strip()
        errors = stderr.read().decode().strip()

        if errors:
            print(f"Error updating config on {hostname}: {errors}")
            return False
        else:
            print(f"Successfully updated {config_path} on {hostname}. Output: {output}")
            return True
    except Exception as e:
        print(f"Failed to connect or execute command on {hostname}: {e}")
        return False
    finally:
        if 'client' in locals():
            client.close()

if __name__ == "__main__":
    # Example usage:
    # This would typically be run as part of a CI/CD job with secrets managed securely.
    remote_host = "your_remote_server.example.com"
    ssh_user = "your_ssh_user"
    ssh_key = "/path/to/your/ssh/private_key" # IMPORTANT: Use secure methods for keys in production
    remote_config_file = "/etc/myapp/config.conf"
    updated_setting_value = "new_production_value"

    if update_remote_config(remote_host, ssh_user, ssh_key, remote_config_file, updated_setting_value):
        print("Configuration update initiated successfully.")
    else:
        print("Configuration update failed.")