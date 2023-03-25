# Parse a JWT

## Keyfunc



## With Options

| <div style="width:5.5rem">Option Name</div> | <div style="width:4.5rem">Arguments</div> | Description                                                                                                                                                                                                                                                                                                                                                                         |
| :------------------------------------------ | :---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `WithValidMethods`                          | methods as `[]string`                     | Supplies a list of [signing methods](./signing_methods.md) that the parser will check against the algorithm on the token. Only the supplied methods will be considered valid. It is heavily encouraged to use this option in order to prevent "none" algorithm attacks.[^1]                                                                                                         |  |
| `WithJSONNumber`                            | -                                         | Configures the underlying JSON parser to use the [`UseNumber`](https://pkg.go.dev/encoding/json#Decoder.UseNumber) function, which decodes numeric JSON values into the [`json.Number`](https://pkg.go.dev/encoding/json#Number) type instead of `float64`. This type can then be used to convert the value into either a floating type or integer type.                            |
| `WithLeeway`                                | leeway as `time.Duration`                 | According to the RFC, a certain time window (leeway) is allowed when verifying time based claims, such as expiration time. This is due to the fact that a there is not perfect clock synchronization on the a distributed system such as the internet. While we do not enforce any restriction on the amount of leeway, it should generally not exceed more than a few minutes.[^2] |

[^1]: [https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries](https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries)
[^2]: [https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.4](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.4)