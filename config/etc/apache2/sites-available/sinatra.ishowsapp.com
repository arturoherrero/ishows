<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName sinatra.ishowsapp.com

  DocumentRoot /var/www/sinatra.ishowsapp.com/public_html

  PassengerEnabled on
  PassengerAppRoot /home/apps/ishows
  PassengerRuby /usr/local/rvm/gems/ruby-2.4.1/wrappers/ruby

  <Directory />
    Options FollowSymLinks
    AllowOverride All
  </Directory>
  <Directory /var/www/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
  </Directory>

  ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
  <Directory "/usr/lib/cgi-bin">
    AllowOverride None
    Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
    Order allow,deny
    Allow from all
  </Directory>

  ErrorLog  /var/www/sinatra.ishowsapp.com/error.log

  # Possible values include: debug, info, notice, warn, error, crit,
  # alert, emerg.
  LogLevel info

  CustomLog ${APACHE_LOG_DIR}/access.log combined

  Alias /doc/ "/usr/share/doc/"
  <Directory "/usr/share/doc/">
    Options Indexes MultiViews FollowSymLinks
    AllowOverride None
    Order deny,allow
    Deny from all
    Allow from 127.0.0.0/255.0.0.0 ::1/128
  </Directory>
</VirtualHost>
