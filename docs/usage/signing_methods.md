# Signing Methods

There are several signing methods available, and you should probably take the time to learn about the various options before choosing one.  The principal design decision is most likely going to be **symmetric** vs **asymmetric**.

Symmetric signing methods, such as HMAC, use only a single secret. This is probably the simplest signing method to use since any `[]byte` can be used as a valid secret. They are also slightly computationally faster to use, though this rarely is enough to matter. Symmetric signing methods work the best when both producers and consumers of tokens are trusted, or even the same system. Since the same secret is used to both sign and validate tokens, you can't easily distribute the key for validation.

Asymmetric signing methods, such as RSA, use different keys for signing and verifying tokens. This makes it possible to produce tokens with a private key, and allow any consumer to access the public key for verification.

## Signing Methods and Key Types

Each signing method expects a different object type for its signing keys. The following table lists all supported signing methods in the core library.

| Name                                                                                                   | `"alg"` Parameter Values | Signing Key  Type                                                    | Verification Key Type                                              |
| ------------------------------------------------------------------------------------------------------ | ------------------------ | -------------------------------------------------------------------- | ------------------------------------------------------------------ |
| [HMAC signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodHMAC)[^hmac]        | `HS256`,`HS384`,`HS512`  | `[]byte`                                                             | `[]byte`                                                           |
| [RSA signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodRSA)[^rsa]           | `RS256`,`RS384`,`RS512`  | [`*rsa.PrivateKey`](https://pkg.go.dev/crypto/rsa#PrivateKey)        | [`*rsa.PublicKey`](https://pkg.go.dev/crypto/rsa#PublicKey)        |
| [ECDSA signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodECDSA)[^ecdsa]     | `ES256`,`ES384`,`ES512`  | [`*ecdsa.PrivateKey`](https://pkg.go.dev/crypto/ecdsa#PrivateKey)    | [`*ecdsa.PublicKey`](https://pkg.go.dev/crypto/ecdsa#PublicKey)    |
| [RSA-PSS signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodRSAPSS)[^rsapss] | `PS256`,`PS384`,`PS512`  | [`*rsa.PrivateKey`](https://pkg.go.dev/crypto/rsa#PrivateKey)        | [`*rsa.PublicKey`](https://pkg.go.dev/crypto/rsa#PublicKey)        |
| [EdDSA signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodEd25519)[^eddsa]   | `Ed25519`                | [`ed25519.PrivateKey`](https://pkg.go.dev/crypto/ed25519#PrivateKey) | [`ed25519.PublicKey`](https://pkg.go.dev/crypto/ed25519#PublicKey) |

[^hmac]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.2)
[^rsa]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.3)
[^ecdsa]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.4)
[^rsapss]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.5)
[^eddsa]: [Section 3.1 of RFC 8037](https://datatracker.ietf.org/doc/html/rfc8037#section-3.1)
