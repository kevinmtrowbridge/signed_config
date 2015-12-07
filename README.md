# SignedConfig

SignedConfig has two modes: 

Writer mode : intended to be used by a sort of "licensing console", takes a config hash and a private key and generates 
signed "license text."  The licensed text contains a YML serialized "human readable" version of the config hash and
a matching signature.

Reader mode: intended to be used by the "licensed application" takes a public key (which should be distributed with the
application) and the "license text."  It confirms the signature matches the config hash, and deserializes the license text 
from YML back into a Ruby hash.

This gem was extracted from an enterprise Rails webapp.  It's unusual for a Rails application in that, it's installed onsite
on clients' servers.  (This is not unusual for an "enterprise application," however.) 


## Writing licenses

    config_hash = {
      :client_name: "Acme Inc."
      :license_level: "high"
      :licensed_features: ["widget_management", "foobar_creation"],
      :expiration_date: 2099-01-01 00:00:00 UTC
      :num_superusers: 1
      :num_users: 20
    }
    org_name = "BRANDED"

    writer = SignedConfig::Writer.new(SIGNED_CONFIG_PRIVATE_KEY, config_hash, org_name)
    self.signed_config = writer.signed_config


## Reading licenses

    def verify
      begin
        reader = SignedConfig::Reader.new(SIGNED_CONFIG_PUBLIC_KEY, params[:license])
        @config = reader.config
        flash[:success] = 'License is valid.'
      rescue SignedConfig::SignatureDoesNotMatch
        flash[:error] = 'License is invalid.'
        flash.discard
        render :new
      end
    end



## Example of generated license:

=========================BEGIN BRANDED LICENSE=========================
---
:config: |
  ---
  :client_name: Acme Inc.
  :license_level: high
  :licensed_features:
  - widget_management
  - foobar_creation
  :expiration_date: 2099-01-01 00:00:00 UTC
  :num_superusers: 1
  :num_users: 20
:signature: |
  VUiNY22N9cIs+RUJ1+w+T7pXEkBwOhGx2heeo3ekxybWjm+gEBXkt8n3Y8+s
  pUyK0RfLM6NK9LMP6/Ke5IXL199hDLKXJnfy/nuZ+uIkNmoL1Bd7FhMqXCmd
  HyRuuSkHTsQG4hk1VCS/mn/KaZWn1P+dyng4HWYWCAJYt2dtJqf/ZbLmIXdI
  xX9GplIG5wCto7Dss7ksBR2x97QFe5P3OGQAjX0qw/jFWY8pOy+JCaJqB4b4
  U/xy9p/+VWPhdmQPY8/hIowx9WC2UqbV5QKTEJzqWebG7xbvwmJfywE60+qO
  rhEqh8fza8jagTbmzBtpsXyyTd4ZAusXuwc7uMTtFQ==

=========================END BRANDED LICENSE=========================


## How "secure" is this? 

Since Ruby is not compiled and trivially easy to modify, it's very unsuited for being "hacker proof."  Normally this doesn't
matter as, enforcing license compliance is trivial for a classic consumer webapp where users only interact with the app via
their web browsers.

However, for enterprise clients, it makes sense to just make it "slightly difficult" to modify the license to add users,
enable additional features, or extend the expiration date.  The security that this gem provides raises the bar just from 
the point where anyone could read and alter a plain text configuration file, to the point where any "programmer" type could
figure out modifications in an hour or two.  

However, I believe this is sufficient to enforce 95% of business agreements.
 
Additionally SignedConfig only uses a SHA1 hashing algorithm which is not hacker-proof anymore.


## Development

### Running the tests

    rake