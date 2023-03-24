# Creating a New JWT

One of the primary goals of this library is to create a new JWT (or in short
*token*). The easiest way to create a token is to use the `jwt.New` function. It
then needs one of the available [signing methods](./signing_methods.md), to
finally sign and convert the token into a string format.

```go
t := jwt.New(jwt.SigningMethodHS256) // (1)!
jwt := t.SignedString(myKey) // (2)!
```

1. This initializes a new `jwt.Token` struct based on the supplied signing method
2. This step computes a cryptographic signature based on the supplied key

## With Additional Claims

## With Options

