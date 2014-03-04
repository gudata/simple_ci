simple_ci
=========

Continuous Integration Server build with Ruby on Rails.

Support diffrent build scripts for different branches.
Builds only selected branches
No external services needed.


Install
=======

    git clone git@github.com:gudata/simple_ci.git
    cd simple_ci
    bundle

    # Edit config/database.yml to put your database settings

    rake db:create db:migrate
    rake assets:precompile
    rake ci:run # Start the runner
    rails s -e production # Start the server

Authentication
===============

The server starts without athentication. After the first commiter is discovered the authentication system is activated.

Commiters automatically become users after they are discovered for first time.

When need to login use commiter email as USERNAME and PASSWORD.