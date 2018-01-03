server '13.230.180.23', user: 'ec2-user', roles: %w{app db web}
set :ssh_options, keys: '/Users/yukiiwamoto/.ssh/id_rsa'
