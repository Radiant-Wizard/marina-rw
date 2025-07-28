from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route("/marina")
def run_marina():
    laza = request.args.get("laza")
    if not laza:
        return jsonify({"error": "Missing 'laza' parameter"}), 400

    try:
        # Consider validating 'formula' here
        result = subprocess.check_output(["./marina", laza], stderr=subprocess.STDOUT)
        return jsonify({"result": result.decode().strip()})
    except subprocess.CalledProcessError as e:
        return jsonify({"error": e.output.decode()}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)