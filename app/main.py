import logging
from flask import Flask, request

app = Flask(__name__)

# Configure logging
logging.basicConfig(
    filename="app.log",  # Log to a file named app.log
    level=logging.INFO,   # Set log level to INFO
    format="%(asctime)s - %(levelname)s - %(message)s"
)

@app.before_request
def log_request():
    """Log details of each request before processing."""
    logging.info(f"Request: {request.method} {request.path} from {request.remote_addr}")

@app.route("/")
def hello():
    return "Hello, World!"

@app.route("/healthz")
def health():
    logging.info("Health check endpoint was hit.")
    return {"status": "ok"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
