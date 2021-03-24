# MemAc API

MemAc API is a RESTful application that helps you memorize the acronyms.

## Description

MemAc was created using Swift programming language and Vapor 4 framework.
The goal of the application is to let users create acronyms by entering the acronym and its meaning.
You can share your acronyms with other users or keep them private.
MemAc also help you organize your acronyms in categories.

## About Vapor Framework

Vapor is an open source web framework written in Swift. It can be used to create RESTful APIs, web apps, and real-time applications using WebSockets. In addition to the core framework, Vapor provides an ORM, a templating language, and packages to facilitate user authentication and authorization.

## Application Install

- Download and install Swift and Vapor 4 framework
- Clone this repository
- Generate random RSA private and public keys
- Create a file in the app folder, call it 'jwtRS256.key' and store there your private key (Disclaimer: not the optimal solution)
- Create a file in the app folder, call it 'jwtRS256.key.pub' and store there your public key
- Open terminal in the app directory and fire up the following command: swift run

## Documentation

All the endpoints are very well documented. Check the [docs folder](docs) for more details...
