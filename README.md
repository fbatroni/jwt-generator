# jwt-generator
App to generate JWT tokens.

## API

### /generate

#### Email Parameter
Expects an email address to be provided via either get or post as the parameter "email".
Example:

    http://services.glgresearch.com/jwt-generator/?email=cm_email@foo.com

#### Success
Returns a JWT if successfull:

    { "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ" }

#### Error
Returns an error if not succesfull:

    { "error": "Some error message" }

## Use Cases

### Development and Production Verification

If you need to test logging in to a jwt-protected app during development or to verify an app is running correctly in production, you can use the jwt generator to generate a token, which you can append to your request as the querystring paramter "jwt"

### Crafting Emails

If your application sends CMs a link to a JWT-protected app (for example, reminder to invoice) You can (should) use the jwt-generator to generate a token.  That token should be appended to your link as the querystring parameter "jwt".

Example:

    http://services.glgresearch.com/pay-me/?jwt=my_generated_jwt_token
