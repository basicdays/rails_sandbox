# Rails Sandbox

This project is a sandbox environment to test out Capistrano deployments and Ansible provisioning. The rails
project is just a run through of the rails tutorial.


## Setup

```shell
brew install chruby ruby-install vagrant ansible ansible-lint
```

### Config chruby

[chruby config docs](https://github.com/postmodern/chruby#configuration): Add following to the `~/.bashrc` or `~/.zshrc` file:

```shell
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh # Or run `brew info chruby` to find out installed directory
```

### Install ruby version

`cd` to project directory and run the following:

```shell
ruby-install $(cat .ruby-version)
```

### To switch terminal to project ruby

`cd` to project directory and run the following:

```shell
chruby .
```


## VBox test environment deployment

Make sure you have an SSH key generated and its public key available at `~/.ssh/id_rsa.pub`.

To spin up a virtual box test environment and deploy the rails app in a "production" environment.

```shell
vagrant up && bin/cap vbox deploy
```

To update virtualbox provisioning:

```shell
vagrant up --provision
```


## Docs and References

- Ansible
  - [User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html#table-of-contents)
  - [Ansible Lint](https://ansible-lint.readthedocs.io/)
  - [Collections](https://docs.ansible.com/ansible/latest/collections/index.html)
    - [ansible.builtin](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
    - [community.general](https://docs.ansible.com/ansible/latest/collections/community/general/index.html)
  - Configs
    - [Ansible conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html#)
    - [Jinja expressions](https://jinja.palletsprojects.com/en/3.1.x/templates/#expressions)
    - [Jinja builtin filters](https://jinja.palletsprojects.com/en/3.1.x/templates/#builtin-filters)
- [Vagrant](https://www.vagrantup.com/docs)
- Ruby
  - [Ruby tutorials](https://www.tutorialspoint.com/ruby/index.htm)
  - [chruby](https://github.com/postmodern/chruby#readme)
  - [ruby-install](https://github.com/postmodern/ruby-install#readme)
  - [bundle](https://bundler.io/v2.3/man/bundle.1.html)
  - [puma](https://puma.io/puma/)
  - [Ruby on Rails](https://guides.rubyonrails.org/)
  - [rake](https://github.com/ruby/rake#readme)
    - [rake manual](https://ruby.github.io/rake/)
    - [Rakefile Format](https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc)
- [Capistrano](https://capistranorb.com/documentation/overview/what-is-capistrano/)
  - [Capistrano::Bundle](https://github.com/capistrano/bundler#readme)
  - [Capistrano::Rails](https://github.com/capistrano/rails#readme)
  - [Capistrano::Puma](https://github.com/seuros/capistrano-puma/tree/v5.2.0)
  - [Module: Capistrano::DSL](https://rubydoc.info/gems/capistrano/Capistrano/DSL)
  - [Module: Rake::DSL](https://rubydoc.info/gems/rake/13.0.6/Rake/DSL)
- Guides
  - [Intellij: Tutorial: Deploy a Rails app using Capistrano](https://www.jetbrains.com/help/ruby/capistrano.html#prerequisites)
  - [ansible-examples: tomcat-standalone](https://github.com/ansible/ansible-examples/tree/master/tomcat-standalone)
  - [Deploying Rails Applications with the Puma Web Server](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server)


## Scratch Notes

Systemd service generation:

```
 ✘  ~/wip/sandbox/rails_sandbox   main ±  ./bin/cap vbox puma:systemd:config puma:systemd:enable
/Users/paulsanchez/.gem/ruby/3.1.2/gems/capistrano3-puma-5.2.0/lib/capistrano/puma.rb:47: warning: Passing safe_level with the 2nd argument of ERB.new is deprecated. Do not use it, and specify other arguments as keyword arguments.
/Users/paulsanchez/.gem/ruby/3.1.2/gems/capistrano3-puma-5.2.0/lib/capistrano/puma.rb:47: warning: Passing trim_mode with the 3rd argument of ERB.new is deprecated. Use keyword argument like ERB.new(str, trim_mode: ...) instead.
00:00 puma:systemd:config
      Uploading /tmp/puma_rails_sandbox_vbox.service 100.0%
      01 sudo mv /tmp/puma_rails_sandbox_vbox.service /etc/systemd/system/
    ✔ 01 deploy@localhost 0.009s
      02 sudo /bin/systemctl daemon-reload
    ✔ 02 deploy@localhost 0.214s
00:00 puma:systemd:enable
      01 sudo /bin/systemctl enable puma_rails_sandbox_vbox
      01 Created symlink /etc/systemd/system/multi-user.target.wants/puma_rails_sandbox_vbox.service → /etc/systemd/system/puma_rails_sandbox_vbox.service.
    ✔ 01 deploy@localhost 0.258s
```
