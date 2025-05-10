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

While the step above using [`jwt.New`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#New) creates a valid token, it contains an empty set of *claims*. Claims are certain pieces of information that are encoded into the token. Since they are encoded and signed by the issuer of the token, one can assume that this information is valid (in the scope of the issuer). Claims can be used to provide the basis for user authentication or authorization, e.g., by encoding a user name or ID or roles into the token. This is also commonly in combination with OAuth 2.0. Furthermore, claims can also contain certain metadata about the token itself, e.g., the time until which the token is regarded as valid and not expired.

[RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519) provides a list of so called *registered claim names* [^claims], which each JWT parser needs to understand. Using the [`jwt.NewWithClaims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#NewWithClaims), a token with different claims can be created.

```go
var (
  key *ecdsa.PrivateKey
  t   *jwt.Token
  s   string
)

key = /* Load key from somewhere, for example a file */
t = jwt.NewWithClaims(jwt.SigningMethodES256, // (1)!
  jwt.MapClaims{ // (2)!
    "iss": "my-auth-server", // (3)!
    "sub": "john", // (4)!
    "foo": 2, // (5)!
  })
s = t.SignedString(key) // (6)!
```

1. This initializes a new [`jwt.Token`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Token) struct based on the supplied signing method. In this case a **asymmetric** method is chosen, which is the first parameter.
2. The second parameter contains the desired claims in form of the [`jwt.Claims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Claims) interface. In this case [`jwt.MapClaims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#MapClaims) are used, which is a wrapper type around a Go map containing `string` keys.
3. The `"iss"`[^iss] claim is a registered claim name that contains the issuer of the token. More technical, this claim identifies the principal that *issued* the token.
4. The `"sub"`[^sub] claim is a registered claim name that contains the subject this token identifies, e.g. a user name. More technical, this claim identifies the principal that is the *subject* of the token.
5. The `"foo"` claim is a custom claim containing a numeric value. Any string value can be chosen as a claim name, as long as it does not interfere with a registered claim name.
6. This step computes a cryptographic signature based on the supplied private
   key.

[^claims]: [Section 4.1 of RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
[^iss]: [Section 4.1.1 of RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1)
[^sub]: [Section 4.1.2 of RFC 7519](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.2)

## With Custom Claims

In the above examples Custom Claims have been used with [`jwt.MapClaims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#MapClaims) type. However, when working with a consistent structure across multiple tokens, it's often cleaner and more maintainable to define your own struct type embedding jwt.RegisteredClaims. This allows for type safety and easier reusablility.

```go
var (
 key *ecdsa.PrivateKey
 t   *jwt.Token
 s   string
 claims CustomClaims
)

type CustomClaims struct {
 Foo  string `json:"foo"`
 jwt.RegisteredClaims
}

claims := CustomClaims{ // (1)!
 Foo: "bar", // (2) !
 RegisteredClaims: jwt.RegisteredClaims{ // (3) !
	 ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)), // (4) !
	 Issuer:    "john", // (5) !
	 Subject:   "subject", // (6) !
 },
}

key = /* Load key from somewhere, for example a file */

t = jwt.NewWithClaims(jwt.SigningMethodES256, claims) // (7)!
s = t.SignedString(key) // (8)!
```
1. This initializes claims variable based of the type CustomClaims struct as declared. This will have all definitions and values for the custom claims along with the registered claim values embedded via[`jwt.RegisteredClaims`] (https://datatracker.ietf.org/doc/html/rfc7519#section-4.1).
2. The "bar" string here is the actual value for the custom claim Foo. This is completely user-defined and not governed by any JWT standardization, allowing for flexible claim modeling across tokens.
3. jwt.RegisteredClaims{...} sets standard claims that are recognized across JWT-compliant systems. This may include expiry, issuer, and subject identifiers.
4. The ExpiresAt field uses jwt.NewNumericDate(...) to convert a Go time.Time into the numeric timestamp format expected in JWTs. Here, the token is valid for 24 hours.
5. The `"john"` value assigned to the Issuer[^iss] claim helps the recipient validate who issued the token — a critical aspect when tokens are exchanged across systems.
6. The `"subject"` value assigned to Subject[^sub] identifies the principal for whom the token was issued, often corresponding to the authenticated user.
7. This initializes a new [`jwt.Token`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#Token) struct based on the supplied signing method. Here as well an **asymmetric** method is chosen, as the first parameter.
8. This step computes a cryptographic signature based on the supplied private key.

## With Options

While we already prepared a
[`jwt.TokenOption`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#TokenOption)
type, which can be supplied as a varargs to
[`jwt.New`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#New) and
[`jwt.NewWithClaims`](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#NewWithClaims),
these are strictly for future compatibility and are currently not used.