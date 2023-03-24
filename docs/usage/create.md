# Creating a New JWT

One of the primary goals of this library is to create a new JWT (or in short
*token*).

## With Default Options

 The easiest way to create a token is to use the
[`jwt.New`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#New) function. It
then needs one of the available [signing methods](./signing_methods.md), to
finally sign and convert the token into a string format (using the
[`SignedString`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Token.SignedString)
method). In the first example, we are using a **symmetric** signing method, i.e.,
HS256. For a symmetric method, both the signing and the verifying key are the
same and thus, both must be equally protected (and should definitely NOT be
stored in your code).

```go
var (
  key []byte
  t   *jwt.Token
  s   string
)

key = /* Load key from somewhere, for example an environment variable */
t = jwt.New(jwt.SigningMethodHS256) // (1)!
s = t.SignedString(key) // (2)!
```

1. This initializes a new
   [`jwt.Token`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Token) struct
   based on the supplied signing method. In this case a **symmetric** method is
   chosen.
2. This step computes a cryptographic signature based on the supplied key. 

Signing using an *asymmetric* signing method (for example ECDSA) works quite
similar. For an **asymmetric** method, the private key (which must be kept
secret) is used to *sign* and the corresponding public key (which can be freely
transmitted) is used to *verify* the token.

```go
var (
  key *ecdsa.PrivateKey
  t   *jwt.Token
  s   string
)

key = /* Load key from somewhere, for example a file */
t = jwt.New(jwt.SigningMethodES256) // (1)!
s = t.SignedString(key) // (2)!
```

1. This initializes a new [`jwt.Token`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Token) struct based on the supplied signing method. In this case a **asymmetric** method is chosen.
2. This step computes a cryptographic signature based on the supplied private
   key.

Note, that the chosen signing method and the type of key must match. Please refer to [Signing Methods](./signing_methods.md) for a complete overview.


## With Additional Claims

## With Options

While we already prepared a
[`jwt.TokenOption`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#TokenOption)
type, which can be supplied as a varargs to
[`jwt.New`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#New) and
[`jwt.NewWithClaims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#NewWithClaims),
these are strictly for future compatibility and are currently not used.