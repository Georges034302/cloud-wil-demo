from flask import Flask, jsonify
import random

app = Flask(__name__)

jokes = [
    "Why don’t developers like nature? It has too many bugs.",
    "Why did the developer go broke? Because he used up all his cache.",
    "Why do programmers prefer dark mode? Because light attracts bugs.",
    "What is a programmer’s favorite hangout place? The Foo Bar."
]

@app.route("/joke")
def joke():
    return jsonify({"joke": random.choice(jokes)})