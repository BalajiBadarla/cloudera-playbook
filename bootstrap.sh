useradd -G wheel -d /home/badman -m badman
cd /home/badman
mkdir .ssh
chmod 700 .ssh
cd .ssh
chown -R badman:badman /home/badman
sudo su -c 'ssh-keygen -q -t rsa -b 2048 -f /home/badman/.ssh/id_rsa -N "" ' -l badman
cat id_rsa.pub > authorized_keys
chmod 600 authorized_keys
chown -R badman:badman /home/badman
yum install ansible git -y
sudo su -l badman -c 'git clone https://github.com/BalajiBadarla/cloudera-playbook.git'
sudo su -l badman -c 'ansible-galaxy install -r cloudera-playbook/requirements.yml'
sudo su -l badman -c 'sed -i "s#jira-ps7#`hostname -s`#g" cloudera-playbook/hosts'
sed -i "s/^#host_key_checking/host_key_checking/" /etc/ansible/ansible.cfg
sudo su -l badman -c 'ansible-playbook -i cloudera-playbook/hosts cloudera-playbook/install-postgres-scl-rh.yml'
usermod -G wheel postgres
sudo su -l badman -c "ansible db_server -i cloudera-playbook/hosts -m file -a 'src=/opt/rh/rh-postgresql96/root/usr/lib64/libpq.so.rh-postgresql96-5  dest=/usr/lib64/libpq.so.rh-postgresql96-5 state=link' -b"
sudo su -l badman -c "ansible db_server -i cloudera-playbook/hosts -m file -a 'src=/opt/rh/rh-postgresql96/root/usr/lib64/libpq.so.rh-postgresql96-5  dest=/usr/lib/libpq.so.rh-postgresql96-5 state=link' -b"
sudo su -l badman -c 'ansible-playbook -i cloudera-playbook/hosts cloudera-playbook/install-postgres-dbs.yml'
