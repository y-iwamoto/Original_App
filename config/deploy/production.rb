server '13.230.180.23', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/yukiiwamoto/.ssh/id_rsa'
