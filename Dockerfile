ARG CENTOS_VERSION=8
FROM centos:${CENTOS_VERSION} as intermediate

ARG QUESTA_FILE="QuestaSetup-21.1.1.850-linux.run"
ARG QUESTA_LICENSE_FILE="License.dat"

# Install package dependencies
RUN dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos \
    && dnf -y distro-sync \
    && yum install -y gcc libX11 libXext libXft libSM xterm sudo vim \
       glibc.i686 glibc-devel.i686 libX11.i686 libXext.i686 libXft.i686 libgcc.i686 libgcc.x86_64 qt5-qtbase \
       libstdc++.i686 libstdc++-devel.i686 ncurses-devel.i686 libnsl ncurses-compat-libs \
    && yum clean all

# Add default user (questa)
RUN adduser questa \
    && usermod -aG wheel questa \
    && echo "questa ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER questa
ENV HOME /home/questa
ENV LANG en_US.UTF-8

# Install Questa
WORKDIR /questa_install_files
COPY ${QUESTA_FILE} ./
COPY ${QUESTA_LICENSE_FILE} ./
RUN sudo chmod a+x ./${QUESTA_FILE} \
    && sudo chown questa ./${QUESTA_FILE} \
    && ./${QUESTA_FILE} --mode unattended --accept_eula 1 \
    && mkdir /home/questa/license \
    && cp ./${QUESTA_LICENSE_FILE} /home/questa/license/. \
    && sudo rm -rf /questa_install_files

# Configure .bashrc with Questa license location, PATH, and starting folder
RUN echo "" >> /home/questa/.bashrc \
    && echo "export LM_LICENSE_FILE=/home/questa/license/${QUESTA_LICENSE_FILE}" >> /home/questa/.bashrc \
    && echo "export PATH=$PATH:/home/questa/intelFPGA/21.1/questa_fse/bin" >> /home/questa/.bashrc \
    && echo "cd ~" >> /home/questa/.bashrc
