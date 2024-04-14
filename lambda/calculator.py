import json

class Calculator:
    def add(self, x, y):
        return x + y

    def subtract(self, x, y):
        return x - y

    def multiply(self, x, y):
        return x * y

    def divide(self, x, y):
        return x / y if y != 0 else "Error: Division by zero"

def lambda_handler(event, context):
    # Retrieve parameters from the event
    operation = event['operation']
    num1 = event['num1']
    num2 = event['num2']

    # Create a Calculator instance
    calc = Calculator()

    # Perform the specified operation
    if operation == 'add':
        result = calc.add(num1, num2)
    elif operation == 'subtract':
        result = calc.subtract(num1, num2)
    elif operation == 'multiply':
        result = calc.multiply(num1, num2)
    elif operation == 'divide':
        result = calc.divide(num1, num2)
    else:
        result = "Error: Invalid operation"

    # Return the result
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }
