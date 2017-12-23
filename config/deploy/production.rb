server '13.230.180.23', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/root/.ssh/id_rsa.pub'
