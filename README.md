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
    rake db:create db:migrate # If you want to change sqlite edit config/database.yml
    rake ci:run # Start the runner
    rails s -e production # Start the server

