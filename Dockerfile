ARG IMAGE=debian:12-slim

# Installer
FROM ${IMAGE} AS installer
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN apt-get update
RUN apt-get install -y \
    perl \
    wget \
    xz-utils \
    fontconfig
COPY ./texlive.profile ./
RUN wget -nv https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=texlive.profile --location https://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
RUN tlmgr install \
    collection-fontsrecommended \
    collection-langjapanese \
    collection-latexextra \
    latexmk \
    epsf \
    newtx \
    fontaxes \
    boondox \
    txfonts \
    helvetic \
    wrapfig \
    algorithms


# Production
FROM ${IMAGE} AS production
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apt-get update \
    && apt-get install -y \
        perl \
        wget \
        && rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive

CMD ["bash"]
