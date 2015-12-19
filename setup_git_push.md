# Server
apt-get update
apt-get install git apache2 apache2-utils
git config --global user.name "Git Gibbon"
git config --global user.email git.gibbon@example.com
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
mv ./cf /usr/local/bin

mkdir -p /repositories/pushers
htpasswd -c /repositories/passwd.git sample
chown -R vcap:vcap /repositories

vim /etc/apache2/ports.conf # Tell it to listen on 9023
vim /etc/apache2/apache2.conf
# restart apache2

# Routing: /var/vcap/jobs/route_registrar/config/config.yml
  - port: 9023
    uris: ["git.bosh-lite.com"]

# apache2.conf
SetEnv GIT_PROJECT_ROOT /repositories
SetEnv GIT_HTTP_EXPORT_ALL
ScriptAlias /git/ /usr/lib/git-core/git-http-backend/

RewriteEngine On
RewriteCond %{QUERY_STRING} service=git-receive-pack [OR]
RewriteCond %{REQUEST_URI} /git-receive-pack$
RewriteRule ^/git/ - [E=AUTHREQUIRED]

<Files "git-http-backend">
    AuthType Basic
    AuthName "Git Access"
    AuthUserFile /repositories/passwd.git
    Require valid-user
    Order deny,allow
    Deny from env=AUTHREQUIRED
    Satisfy any
</Files>

# Local
git clone git_server ./git_local
cd git_local
git config --global push.default simple
git commit --allow-empty -m "FIRST TEST COMMIT"
