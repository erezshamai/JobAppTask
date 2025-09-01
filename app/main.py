from flask import Flask, jsonify, request  # Add request import
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
        # Create the response and add the X-Forwarded-For header
        response = jsonify({'running_containers': container_info})
        # Get X-Forwarded-For from the incoming request headers
        x_forwarded_for = request.headers.get('X-Forwarded-For', '')
        if x_forwarded_for:
            response.headers['X-Forwarded-For'] = x_forwarded_for
        return response
    except docker.errors.DockerException as e:
        response = jsonify({'error': str(e)})
        # Optionally add the header to error responses too
        x_forwarded_for = request.headers.get('X-Forwarded-For', '')
        if x_forwarded_for:
            response.headers['X-Forwarded-For'] = x_forwarded_for
        return response, 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=50001)