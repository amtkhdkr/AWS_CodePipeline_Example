from flask import Flask

def hello_world():
    return 'Hello, World!'


app = Flask(__name__)

@app.route("/")
def hello():
    return "<p>Hello, World!</p>"

if __name == '__main__':
    app.run(debug=False, host='0.0.0.0')