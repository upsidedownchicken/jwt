#!/usr/bin/env ruby

require 'base64'
require 'jwt'

if ARGV.size == 2
  token = ARGV[0] #Base64.decode64(ARGV[0])
  secret = ARGV[1]

  contents = JWT.decode token, secret, false, {algorithm: 'HS256'}

  puts contents.first.to_json

  valid_sig = false

  begin
    JWT.decode token, secret, true, {algorithm: 'HS256'}
    valid_sig = true
  rescue JWT::VerificationError
  end

  puts "valid_sig = #{valid_sig}"
else
  payload = {
    "iss": "https://#{ENV['AUTH0_SUBDOMAIN']}.auth0.com/",
		"sub": "testClientId@clients",
		"aud": "http://localhost:3000/api/v2",
		"iat": Time.now.to_i,
		"scope": "read:orders"
	}
  secret = ENV['AUTH0_SECRET']

  print JWT.encode payload, secret, 'HS256'
end
