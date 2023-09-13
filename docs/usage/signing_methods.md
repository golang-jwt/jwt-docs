# Signing Methods

## Signing vs Encryption

A token is simply a JSON object that is signed by its author. this tells you exactly two things about the data:

* The author of the token was in the possession of the signing secret
* The data has not been modified since it was signed

It's important to know that JWT does not provide encryption, which means anyone who has access to the token can read its contents. If you need to protect (encrypt) the data, there is a companion spec, JSON Web Encryption (JWE)[^jwe], that provides this functionality. The companion project [https://github.com/golang-jwt/jwe](https://github.com/golang-jwt/jwe) aims at a (very) experimental implementation of the JWE standard.

## Choosing a Signing Method

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
| [EdDSA signing method](https://pkg.go.dev/github.com/golang-jwt/jwt/v5#SigningMethodEd25519)[^eddsa]   | `EdDSA`                | [`ed25519.PrivateKey`](https://pkg.go.dev/crypto/ed25519#PrivateKey) | [`ed25519.PublicKey`](https://pkg.go.dev/crypto/ed25519#PublicKey) |

[^jwe]: [RFC 7516](https://datatracker.ietf.org/doc/html/rfc7516)
[^hmac]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.2)
[^rsa]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.3)
[^ecdsa]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.4)
[^rsapss]: [Section 3.2 of RFC 7518](https://datatracker.ietf.org/doc/html/rfc7518#section-3.5)
[^eddsa]: [Section 3.1 of RFC 8037](https://datatracker.ietf.org/doc/html/rfc8037#section-3.1)

## Frequently Asked Questions

**Why is the HMAC signing method not accepting `string` as a key type?**

We often get asked why the HMAC signing method only supports `[]byte` and not `string`. This is intentionally and there are different reasons for doing so. First, we aim to use the key type that the underlying cryptographic operation in the Go library uses (this also applies to the other signing methods). In case of HMAC, this is [`hmac.New`](https://pkg.go.dev/crypto/hmac#New) and it uses `[]byte` as the type to represent a key.

Second, using `string` as a key type to represent a symmetric key can lead to unwanted situations. It gives the impression that this is something 'human readable' (like a password), but it is not. A symmetric key should contain as much entropy as possible and therefore include characters from the whole character set (even 'unreadable' ones) and ideally be generated by a cryptographic random source, such as [`rand.Read`](https://pkg.go.dev/crypto/rand#Read). Signing tokens with a cryptographically weak key will compromise the security of the tokens and in effect everything that depends on it, e.g., user authentication.

If you have trouble handling a `[]byte` key in our setup, e.g., because you are reading it from your environment variables on your cluster or similar, you can always use base64 encoding to have the key as a "string" type outside of your program and then use [`base64.Encoding.DecodeString`](https://pkg.go.dev/encoding/base64#Encoding.DecodeString) to decode the base64 string into the `[]byte` slice that the signing method needs.
