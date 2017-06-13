# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set included_configs: ["/Users/cortman/aptamer.sys.config"]
  set cookie: :"o50JgBb:y%RKHIZ*J8Nb~sKN|rwr7~4*0MGP5<>L^Hb/Vn7m(oj1o{Q*B5NvVzdC"
end

environment :habitat do
  set include_erts: false
  set include_src: false
  set cookie: :"qsd<Ntl,YC{3oWegv;w>h,kqND`0W3a$Hl?_kCIp*MK4/IO!drEm%}/BY]IL9ot<"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :aptamer do
  set version: current_version(:aptamer)
  set applications: [
    :runtime_tools
  ]
end

