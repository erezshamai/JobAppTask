from flask import Flask, jsonify
import docker

app = Flask(__name__)

@app.route('/running-containers', methods=['GET'])
def get_running_containers():
    try:
        client = docker.from_env()  # Connects via /var/run/docker.sock
        running_containers = client.containers.list(filters={'status': 'running'})
        container_info = [
            {
                'id': container.id[:12],  # Short container ID
                'name': container.name,
                'image': container.image.tags[0] if container.image.tags else 'untagged',
                'status': container.status
            }
            for container in running_containers
        ]
        return jsonify({'running_containers': container_info})
    except docker.errors.DockerException as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)