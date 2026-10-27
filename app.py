from flask import Flask, jsonify, render_template

app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
    return render_template('index.html')

@app.route('/api/info', methods=['GET'])
def info():
    return jsonify({
        "status": "success",
        "autor": "Adrian",
        "mensaje": "Hola, mi nombre es Adrian"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)