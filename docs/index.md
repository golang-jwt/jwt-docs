---
description: Getting started with golang-jwt/jwt
---

# Getting Started

Welcome to `jwt-go`, a [go](http://www.golang.org) (or 'golang' for search engine friendliness) implementation of [JSON Web Tokens](https://datatracker.ietf.org/doc/html/rfc7519). 


### Supported Go versions

Our support of Go versions is aligned with Go's [version release
policy](https://golang.org/doc/devel/release#policy). So we will support a major
version of Go until there are two newer major releases. We no longer support
building jwt-go with unsupported Go versions, as these contain security
vulnerabilities which will not be fixed.

## What the heck is a JWT?

JWT.io has [a great introduction](https://jwt.io/introduction) to JSON Web Tokens.

In short, it's a signed JSON object that does something useful (for example, authentication).  It's commonly used for `Bearer` tokens in OAuth 2.0  A token is made of three parts, separated by `.`'s.  The first two parts are JSON objects, that have been [base64url](https://datatracker.ietf.org/doc/html/rfc4648) encoded.  The last part is the signature, encoded the same way.

The first part is called the header.  It contains the necessary information for verifying the last part, the signature.  For example, which encryption method was used for signing and what key was used.

The part in the middle is the interesting bit.  It's called the Claims and contains the actual stuff you care about.  Refer to [RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519) for information about reserved keys and the proper way to add your own.

## What's in the box?

This library supports the parsing and verification as well as the generation and signing of JWTs.  Current supported signing algorithms are HMAC SHA, RSA, RSA-PSS, ECDSA and EdDSA, though hooks are present for adding your own.

## Installation Guidelines

To install the jwt package, you first need to have [Go](https://go.dev/doc/install) installed, then you can use the command below to add `jwt-go` as a dependency in your Go program.

```sh
go get -u github.com/golang-jwt/jwt/v5
```

Then import it in your code:

```go
import "github.com/golang-jwt/jwt/v5"
```