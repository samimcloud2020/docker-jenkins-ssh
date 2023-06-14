FROM centos
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum install -y passwd

RUN yum -y install openssh-server
RUN useradd remote_user && \
    echo "1234" | passwd remote_user --stdin && \
    mkdir  /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh 
COPY remote-key.pub     /home/remote_user/.ssh/authorized_keys
RUN chown remote_user:remote_user -R /home/remote_user/.ssh && \
    chmod 600 /home/remote_user/.ssh/authorized_keys
RUN /usr/sbin/sshd-keygen
CMD /usr/sbin/sshd -D
