import pickle
import numpy as np
from flask import Flask, request


with open('model.pkl', 'rb') as pkl_file:
    regressor_from_file = pickle.load(pkl_file) # Load the model previously fit and saved by 'serial_model.py' script
app = Flask(__name__)


def model_predict(value):
    value_to_predict = np.array([value]).reshape(-1, 1)
    return regressor_from_file.predict(value_to_predict) 


@app.route('/predict')
def proc_func():
    value = request.args.get('value')
    try:
        value = float(value)
        prediction = model_predict(value) # Make prediction by the model
        result = f'the result is {prediction}!'
    except Exception as e:
        result = f'Oops!{e}' # Show error description, if for any reason 'value' cannot be converted to float
    return result


if __name__ == '__main__':
    app.run('localhost', 5000)
    		