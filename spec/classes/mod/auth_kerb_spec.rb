# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::auth_kerb', type: :class do
  it_behaves_like 'a mod class, without including apache'

  context 'default configuration with parameters' do
    context 'on a Debian OS', :compile do
      let :facts do
        {
          id: 'root',
          kernel: 'Linux',
          lsbdistcodename: 'jessie',
          osfamily: 'Debian',
          operatingsystem: 'Debian',
          operatingsystemrelease: '8',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('libapache2-mod-auth-kerb') }
    end
    context 'on a RedHat OS', :compile do
      let :facts do
        {
          id: 'root',
          kernel: 'Linux',
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemrelease: '6',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('mod_auth_kerb') }
    end
    context 'on a FreeBSD OS', :compile do
      let :facts do
        {
          id: 'root',
          kernel: 'FreeBSD',
          osfamily: 'FreeBSD',
          operatingsystem: 'FreeBSD',
          operatingsystemrelease: '9',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('www/mod_auth_kerb2') }
    end
    context 'on a Gentoo OS', :compile do
      let :facts do
        {
          id: 'root',
          kernel: 'Linux',
          osfamily: 'Gentoo',
          operatingsystem: 'Gentoo',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
          operatingsystemrelease: '3.16.1-gentoo',
          is_pe: false,
        }
      end

      it { is_expected.to contain_class('apache::params') }
      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('www-apache/mod_auth_kerb') }
    end
  end
  context 'overriding mod_packages' do
    context 'on a RedHat OS', :compile do
      let :facts do
        {
          id: 'root',
          kernel: 'Linux',
          osfamily: 'RedHat',
          operatingsystem: 'RedHat',
          operatingsystemrelease: '6',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          is_pe: false,
        }
      end
      let :pre_condition do
        <<-MANIFEST
        include apache::params
        class { 'apache':
          mod_packages => merge($::apache::params::mod_packages, {
            'auth_kerb' => 'httpd24-mod_auth_kerb',
          })
        }
        MANIFEST
      end

      it { is_expected.to contain_apache__mod('auth_kerb') }
      it { is_expected.to contain_package('httpd24-mod_auth_kerb') }
      it { is_expected.not_to contain_package('mod_auth_kerb') }
    end
  end
end
