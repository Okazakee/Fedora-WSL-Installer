FROM fedora:latest

ARG UNIX_USER
ENV UNIX_USER=$UNIX_USER

# Add man pages first so we have to reinstall the fewest packages.
RUN dnf install -y man man-pages
RUN dnf reinstall -qy $(dnf repoquery --installed --qf "%{name}")

RUN dnf upgrade -y && dnf update -y && dnf install -y \
    cracklib-dicts \
    findutils \
    iproute \
    iputils \
    man \
    man-pages \
    ncurses \
    passwd \
    procps-ng \
    rsync \
    neofetch \
    util-linux \
    vim
RUN dnf clean all

RUN useradd -G wheel $UNIX_USER
RUN printf "\n[user]\ndefault = $UNIX_USER\n" | sudo tee -a /etc/wsl.conf

ENTRYPOINT passwd $UNIX_USER