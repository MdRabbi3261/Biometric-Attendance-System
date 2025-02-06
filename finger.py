from flask import Flask, request, jsonify
from flask_cors import CORS
import pymysql

app = Flask(__name__)
CORS(app)  # Enable CORS to allow ESP32 communication

# Database configuration
db_config = {
    "host": "localhost",
    "user": "root",  # Default MySQL username
    "password": "",  # Default MySQL password for XAMPP
    "database": "app1"
}

@app.route('/store_fingerprint', methods=['POST'])
def store_fingerprint():
    try:
        # Retrieve JSON data from the POST request
        data = request.get_json()
        fingerprint_id = data.get('fingerprint_id')
        fingerprint_data = data.get('fingerprint_data')

        if not fingerprint_id or not fingerprint_data:
            return jsonify({"error": "Missing fingerprint_id or fingerprint_data"}), 400

        # Connect to the database
        connection = pymysql.connect(**db_config)
        cursor = connection.cursor()

        # Insert fingerprint data into the database
        sql = "INSERT INTO fingerprints (fingerprint_id, fingerprint_data) VALUES (%s, %s)"
        cursor.execute(sql, (fingerprint_id, fingerprint_data))
        connection.commit()

        cursor.close()
        connection.close()

        return jsonify({"message": "Fingerprint stored successfully!"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
