# calorie-count-elm

Demo of a simple calorie calculator built with the Elm language

Build to compare functional web app creation with unidirectional data flow using Cycle JS and Elm.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

This project uses the Elm language. Instructions for installing the tool to compile and build Elm projects can be [found here](https://guide.elm-lang.org/install.html).

### Installing

Run the Elm Reactor

```
elm-reactor
```

Navigate to the project

```
http://localhost:8000/calorie-calc.elm
```

## Deployment

You can use Elm Make to create an HTML file containing both the HTML and JS bundled together.

```
elm-make calorie-calc.elm  --output=index.html
```

## License

This project is free to use and modify
