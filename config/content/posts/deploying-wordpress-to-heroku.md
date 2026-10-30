---
date: "2014-05-02"
title: Deploying Wordpress to Heroku
summary: A guide on how to use Heroku to host Wordpress
tags:
  - wordpress
  - heroku
---

# Step 1. Downloading

Run the following from the terminal:

```bash
curl -sS http://wordpress.org/latest.zip > wordpress.zip
unzip wordpress.zip
rm wordpress.zip
cd wordpress
touch Procfile
touch composer.json
mv wp-config-sample.php wp-config.php
```

# Step 2. Configuration

Copy the following in **Procfile**:

```yaml
web: vendor/bin/heroku-hhvm-nginx
```

Copy the following in **composer.json**:

```json
{ "require": { "hhvm": "3.2.0" } }
```

Find and replace the following in **wp-config.php**:

```php
// ** MySQL settings - You can get this info from your web host ** //
$url = parse_url(getenv('DATABASE_URL') ? getenv('DATABASE_URL') : getenv('CLEARDB_DATABASE_URL'));

/** The name of the database for WordPress */
define('DB_NAME', trim($url['path'], '/'));

/** MySQL database username */
define('DB_USER', $url['user']);

/** MySQL database password */
define('DB_PASSWORD', $url['pass']);

/** MySQL hostname */
define('DB_HOST', $url['host']);

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');
```

```php
define('AUTH_KEY',         getenv('AUTH_KEY'));
define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY'));
define('NONCE_KEY',        getenv('NONCE_KEY'));
define('AUTH_SALT',        getenv('AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT'));
define('NONCE_SALT',       getenv('NONCE_SALT'));
```

# Step 3: Deployment

Setup the basics with:

```bash
git init
git add .
git commit -m "import"
heroku create
heroku addons:add cleardb
heroku addons:add sendgrid
```

Then set the following environment variables with **new** values (they can be generated [here](https://api.wordpress.org/secret-key/1.1/salt/)):

```bash
heroku config:set AUTH_KEY=''
heroku config:set SECURE_AUTH_KEY=''
heroku config:set LOGGED_IN_KEY=''
heroku config:set NONCE_KEY=''
heroku config:set AUTH_SALT=''
heroku config:set SECURE_AUTH_SALT=''
heroku config:set LOGGED_IN_SALT=''
heroku config:set NONCE_SALT=''
```

Finally deploy the application:

```bash
git push heroku master
heroku open
```

# Notes

Heroku supports an [ephemeral filesystem](https://devcenter.heroku.com/articles/dynos#ephemeral-filesystem). This means that installing plugins or addons should be done and tested locally then deployed by:

```bash
git add .
git commit -m "addons and plugins"
git push heroku master
```

For media uploads (images or videos) check out [WPRO](http://wordpress.org/plugins/wpro/).

# Addendum

The free version of ClearDB on Heroku has a 5mb database limit. [Amazon RDS](https://aws.amazon.com/rds/) is a great alternative (albeit it requires some ops experience). To get started visit [AWS](http://aws.amazon.com/) then after registering go to [RDS](https://console.aws.amazon.com/rds/home). From here:

1. Click "Launch DB Instance"
2. Select "MySQL"
3. Fill in the database preferences being sure to generate a **secure and strong** username and password

Once the database is setup configure it using the username, password, hostname, and dbname from RDS:

```bash
heroku config:set DATABASE_URL='mysql://username:password@hostname/dbname'
```
