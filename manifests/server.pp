# == Class samba::server
#
class samba::server($interfaces = '',
                    $security = '',
                    $server_string = '',
                    $unix_password_sync = '',
                    $netbios_name = '',
                    $workgroup = '',
                    $socket_options = '',
                    $deadtime = '',
                    $keepalive = '',
                    $load_printers = '',
                    $printing = '',
                    $printcap_name = '',
                    $map_to_guest = 'Never',
                    $guest_account = '',
                    $disable_spoolss = '',
                    $kernel_oplocks = '',
                    $pam_password_change = '',
                    $os_level = '',
                    $preferred_master = '',
                    $ldap_idmap_suffix = '',
                    $ldap_user_suffix = '',
                    $ldap_group_suffix = '',
                    $ldap_suffix = '',
                    $ldap_ssl = '',
                    $idmap_backend = '',
                    $realm = '',
                    $min_protocol = '',
                    $max_protocol = '',
                    $bind_interfaces_only = 'yes',
                    $shares = {},
                    $users = {}, ) {

  include samba::server::install
  include samba::server::config
  include samba::server::service

  $incl    = '/etc/samba/smb.conf'
  $context = '/files/etc/samba/smb.conf'
  $target  = 'target[. = "global"]'

  augeas { 'global-section':
    incl    => $incl,
    lens    => 'Samba.lns',
    context => $context,
    changes => "set ${target} global",
    require => Class['samba::server::config'],
    notify  => Class['samba::server::service']
  }

  samba::server::option {
    'interfaces':           value => $interfaces;
    'bind interfaces only': value => $bind_interfaces_only;
    'security':             value => $security;
    'server string':        value => $server_string;
    'unix password sync':   value => $unix_password_sync;
    'netbios name':         value => $netbios_name;
    'workgroup':            value => $workgroup;
    'socket options':       value => $socket_options;
    'deadtime':             value => $deadtime;
    'keepalive':            value => $keepalive;
    'load printers':        value => $load_printers;
    'printing':             value => $printing;
    'printcap name':        value => $printcap_name;
    'map to guest':         value => $map_to_guest;
    'guest account':        value => $guest_account;
    'disable spoolss':      value => $disable_spoolss;
    'kernel oplocks':       value => $kernel_oplocks;
    'pam password change':  value => $pam_password_change;
    'os level':             value => $os_level;
    'preferred master':     value => $preferred_master;
    'ldap idmap suffix':    value => $ldap_idmap_suffix;
    'ldap user suffix':     value => $ldap_user_suffix;
    'ldap group suffix':    value => $ldap_group_suffix;
    'ldap suffix':          value => $ldap_suffix;
    'ldap ssl':             value => $ldap_ssl;
    'idmap backend':        value => $idmap_backend;
    'realm':                value => $realm;
    'min protocol':         value => $min_protocol;
    'max protocol':         value => $max_protocol;
  }

  create_resources(samba::server::share, $shares)
  create_resources(samba::server::user, $users)
}
