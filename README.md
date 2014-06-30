XSS Vulnerability Example Apps
==============================

This is the Rails app for a set of example applications vulnerable to XSS.

Related Apps
------------
* Admin - https://github.com/pcorliss/vuln_admin
* Sinatra - https://github.com/pcorliss/sinatra_step_1
* Rails - https://github.com/pcorliss/rails_step_3
* Node - https://github.com/pcorliss/node_step_2

Live Demo
---------
You can visit a live demo at http://vuln.alttab.org

Local Development
=================

```
git clone https://github.com/pcorliss/rails_step_3.git
cd rails_step_3
bundle install
rake db:create db:migrate db:seed
rails server
```

Heroku Deployment
=================

```
heroku create
heroku addons:add memcachier:dev
git push heroku master
heroku run rake db:migrate
heroku run rake db:seed
heroku ps:scale web=1
```
