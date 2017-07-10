# System for solving mathematical equations

### Test task for [bePaid](https://bepaid.by/) job application.

The system should contain 2 main components: frontend and backend servers
1. **Front-end server requirements**
RoR application must provide:
* Selection of the type of equation (the default are linear and quadratic)
* The form for inputting the parameters of the equation
* Sending the parameters of the equation to the backend server using
JSON
* Displaying the results in friendly format
Features that are welcomed:
* TestUnit / RSpec / Cucumber (one or more) with good test coverage
* JS / Ajax in forms, selection page, input, output, and validation
* CSS for web page design (input form, result page, progress bar/spinner)
* Parameters validation and exception handling (500 from the backend,
entering letters parameters, etc.)
2. **Backend server requirements**
The application must be written in Ruby using Sinatra or similar lightweight
framework, NOT Ruby on Rails.
The application must:
* Provide an API for the equation parameters
* Solve the equation
* Return the response in JSON format
Features that are welcomed:
* TestUnit / RSpec / Cucumber (one or more) with good test coverage
* Parameters validations, exception handling (insufficient number of
parameters, wrong type of equation, wrong type of argument, etc.) and the error
response in friendly format
* Class inheritance to provide single object interface for solving various
types of equations
* Authentication for accessing backend server

Семенюк Виталий
- svitas1997@gmail.com
- Linkedin: https://www.linkedin.com/in/vitali-semenyuk/
- Github: https://github.com/qwertyniop1
