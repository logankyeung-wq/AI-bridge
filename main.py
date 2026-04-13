import os
import subprocess
import logging
from flask import Flask, request

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

app = Flask(__name__)

@app.route('/auto-update', methods=['POST'])
def auto_update():
    subprocess.run(['git', 'pull'], capture_output=True)

    try:
        # CHANGED: We now run the AI's code as a powerful Bash script
        result = subprocess.run(
            ['bash', 'run.sh'], 
            capture_output=True, 
            text=True, 
            timeout=60 # 30 seconds max so the AI doesn't accidentally crash your server
        )

        console_answers = result.stdout
        if result.stderr:
            console_answers += f"\n[AI SYSTEM ERRORS]:\n{result.stderr}"

        # If the AI just deleted a file, it might not output text. We catch that here.
        if not console_answers.strip():
            console_answers = "[Task completed successfully. No console output.]"

        return console_answers, 200

    except subprocess.TimeoutExpired:
        return "[SYSTEM ERROR]: The code took too long to run and was stopped.", 500
    except Exception as e:
        return f"[SYSTEM ERROR]: {str(e)}", 500

@app.route('/')
def home():
    return "Universal AI Environment is online."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)