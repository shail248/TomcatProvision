# # encoding: utf-8

# Inspec test for recipe tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

# describe 'tomcat::default' do

describe package('java-1.8.0-openjdk') do
  it { should be_installed }
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  it { should belong_to_group 'tomcat' }
  it { should have_home_directory '/opt/tomcat' }
end

describe file('/opt/tomcat') do
  it { should exist }
  it { should be_directory }
end

describe file('/home/vagrant/apache-tomcat-8.5.9.tar.gz') do
  it { should exist }
end

describe file '/opt/tomcat/conf' do
  it { should exist }
  it { should be_mode 0750 }
  it { should be_owned_by 'root' }
end

# ['webapps', 'work', 'temp', 'logs'].each do |path|
%w(webapps work temp logs).each do |path|
  describe file "/opt/tomcat/#{path}" do
    it { should exist }
    it { should be_owned_by 'tomcat' }
  end
end

describe command('curl http://localhost:8080') do
  its(:stdout) { should match(/Tomcat/) }
end

# end
